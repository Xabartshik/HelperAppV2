import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/task_service.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/models/tasks/task_card_vm.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/logger.dart';

// Импорты для системы перерывов
import '../../core/models/attendance/break_status_dto.dart';
import '../../core/models/config/app_config_dto.dart';

enum TaskSortMode {
  byPriority,
  byDeadline,
  byType,
}

class MainState {
  final bool isBusy;
  final String errorMessage;
  final bool hasNetwork;
  final List<TaskItemBase> rawTasks;
  final List<TaskCardVm> taskCards;
  final TaskSortMode sortMode;
  
  final bool isActiveShift;
  final bool isShiftLoading;

  // НОВОЕ: Поля для системы перерывов[cite: 8]
  final BreakStatusDto? breakStatus;
  final AppConfigDto? appConfig;

  const MainState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
    this.rawTasks = const [],
    this.taskCards = const [],
    this.sortMode = TaskSortMode.byPriority,
    this.isActiveShift = false,
    this.isShiftLoading = false,
    this.breakStatus,
    this.appConfig,
  });

  MainState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool? hasNetwork,
    List<TaskItemBase>? rawTasks,
    List<TaskCardVm>? taskCards,
    TaskSortMode? sortMode,
    bool? isActiveShift,
    bool? isShiftLoading,
    BreakStatusDto? breakStatus,
    AppConfigDto? appConfig,
  }) {
    return MainState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNetwork: hasNetwork ?? this.hasNetwork,
      rawTasks: rawTasks ?? this.rawTasks,
      taskCards: taskCards ?? this.taskCards,
      sortMode: sortMode ?? this.sortMode,
      isActiveShift: isActiveShift ?? this.isActiveShift,
      isShiftLoading: isShiftLoading ?? this.isShiftLoading,
      breakStatus: breakStatus ?? this.breakStatus,
      appConfig: appConfig ?? this.appConfig,
    );
  }
}

final mainViewModelProvider = AutoDisposeNotifierProvider<MainViewModel, MainState>(() {
  return MainViewModel();
});

class MainViewModel extends AutoDisposeNotifier<MainState> {
  Timer? _breakStatusTimer;
  Timer? _taskFetchTimer;

  // Геттеры для лимитов из конфигурации[cite: 8]
  int get maxBreakMinutes => state.appConfig?.workMinutesRequiredForBreak ?? 60;
  int get breakDurationMinutes => state.appConfig?.breakDurationMinutes ?? 10;

  @override
@override
  MainState build() {
    Future.microtask(() async {
      await checkShiftStatus();
      await refreshTasks(); // Первый запуск — обычный (с лоадером)
      
      // Инициализация системы перерывов (Охрана труда)
      await _fetchConfig();
      await _fetchBreakStatus();
      
      // Настройка таймера обновления статуса перерыва раз в минуту
      _breakStatusTimer = Timer.periodic(
        const Duration(minutes: 1), 
        (_) => _fetchBreakStatus()
      );

      // НОВОЕ: Настройка таймера фонового обновления задач (раз в 5 минут)
      // Мы делаем это "тихо", чтобы не показывать лоадер каждые 5 минут
      _taskFetchTimer = Timer.periodic(
        const Duration(minutes: 5), 
        (_) => refreshTasks(isSilent: true)
      );
    });

    ref.onDispose(() {
      _breakStatusTimer?.cancel(); // Очистка таймера перерывов
      _taskFetchTimer?.cancel();   // Очистка таймера задач
      final taskService = ref.read(taskServiceProvider);
      taskService.stopPeriodicSync();
    });

    return const MainState();
  }

  /// Загрузка конфигурации приложения[cite: 8]
  Future<void> _fetchConfig() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final config = await apiClient.getAppConfigAsync();
      state = state.copyWith(appConfig: config);
    } catch (e) {
      Logger.w('Не удалось загрузить конфигурацию приложения: $e');
    }
  }

  /// Обновление текущего статуса перерыва[cite: 8]
  Future<void> _fetchBreakStatus() async {
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser?.employeeId == null) return;

      final apiClient = ref.read(apiClientProvider);
      final status = await apiClient.getBreakStatusAsync(currentUser!.employeeId!);
      state = state.copyWith(breakStatus: status);
    } catch (e) {
      Logger.w('Не удалось обновить статус перерыва: $e');
    }
  }

  /// Логика начала или завершения перерыва[cite: 8]
  Future<void> toggleBreak() async {
    state = state.copyWith(isBusy: true, errorMessage: '');
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser?.employeeId == null) return;

      final apiClient = ref.read(apiClientProvider);

      if (state.breakStatus?.isOnBreak == true) {
        // Если сотрудник на перерыве — возвращаем его к работе[cite: 8]
        await apiClient.endBreakAsync(currentUser!.employeeId!);
      } else {
        // Если работает — проверяем возможность ухода на перерыв[cite: 8]
        if (state.breakStatus?.canStartBreak == true) {
          await apiClient.startBreakAsync(currentUser!.employeeId!);
        } else {
          // Если перерыв недоступен, выводим причину (например, не накоплено время)[cite: 8]
          state = state.copyWith(
            errorMessage: 'Перерыв недоступен. Накоплено: ${state.breakStatus?.accumulatedMinutes ?? 0} мин.',
            isBusy: false
          );
          return;
        }
      }
      
      // Обновляем состояние после выполнения действия[cite: 8]
      await _fetchBreakStatus();
    } catch (e) {
      Logger.e('Ошибка при смене статуса перерыва', e);
      state = state.copyWith(errorMessage: 'Ошибка перерыва: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> checkShiftStatus() async {
    state = state.copyWith(isShiftLoading: true);
    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser?.employeeId == null) return;

      final apiClient = ref.read(apiClientProvider);
      final lastCheck = await apiClient.getLastCheckAsync(currentUser!.employeeId!);

      if (lastCheck != null && lastCheck.checkType == 'in') {
        final checkTime = lastCheck.checkTimeStamp;
        final now = DateTime.now().toUtc();
        final difference = now.difference(checkTime);

        if (difference.inHours < 14) {
          state = state.copyWith(isActiveShift: true, isShiftLoading: false);
          return;
        }
      }
      
      state = state.copyWith(isActiveShift: false, isShiftLoading: false);
    } catch (e) {
      Logger.e('Ошибка при проверке статуса смены', e);
      state = state.copyWith(isActiveShift: false, isShiftLoading: false);
    }
  }

  Future<bool> processQrCheckIn(String qrRawData, String checkType) async {
    state = state.copyWith(isShiftLoading: true, errorMessage: '');
    try {
      final Map<String, dynamic> qrData = jsonDecode(qrRawData);
      final String payload = qrData['p'] ?? '';
      final int branchId = qrData['b'] ?? 1;

      if (payload.isEmpty) throw Exception('Неверный формат QR-кода');

      final apiClient = ref.read(apiClientProvider);
      await apiClient.scanQrCheckInAsync(payload, branchId, checkType);

      final isNowActive = (checkType == 'in');
      state = state.copyWith(isActiveShift: isNowActive, isShiftLoading: false);
      
      if (isNowActive) refreshTasks();
      return true;
    } catch (e) {
      Logger.e('Ошибка при QR-отметке на смене', e);
      state = state.copyWith(
        errorMessage: 'Ошибка отметки: Неверный QR-код или срок его действия истек.',
        isShiftLoading: false,
      );
      return false;
    }
  }

/// Обновление списка задач. 
  /// [isSilent] - если true, обновление происходит без показа индикатора загрузки
  Future<void> refreshTasks({bool isSilent = false}) async {
    // Если обновление "тихое", не включаем глобальный индикатор загрузки (isBusy)
    if (!isSilent) {
      state = state.copyWith(isBusy: true, errorMessage: '');
    }

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        if (!isSilent) state = state.copyWith(isBusy: false);
        return;
      }

      final taskService = ref.read(taskServiceProvider);
      final tasks = await taskService.getTasksForCurrentUserAsync(currentUser.employeeId!);

      final taskCards = tasks.map(TaskCardVm.fromTask).toList();

      state = state.copyWith(
        rawTasks: tasks,
        taskCards: _applySort(taskCards, state.sortMode),
        hasNetwork: true,
        isBusy: false, // Всегда выключаем лоадер при успехе
      );

      // Управление периодической синхронизацией через TaskService (если она используется)
      taskService.setEmployeeIdForPeriodicSync(currentUser.employeeId!);
      if (!taskService.isPeriodicSyncActive) {
        taskService.startPeriodicSync((updatedTasks) {
          final updatedCards = updatedTasks.map(TaskCardVm.fromTask).toList();
          state = state.copyWith(
            rawTasks: updatedTasks,
            taskCards: _applySort(updatedCards, state.sortMode),
            hasNetwork: true,
          );
        });
      }
    } on NoNetworkException {
      if (!isSilent) {
        state = state.copyWith(
          errorMessage: 'Нет подключения к сети',
          hasNetwork: false,
          isBusy: false,
        );
      }
    } on UnauthorizedException {
      await logout();
    } catch (e) {
      // В тихом режиме ошибки только логируем, в обычном — показываем пользователю
      if (!isSilent) {
        state = state.copyWith(
          errorMessage: 'Ошибка загрузки задач: $e',
          isBusy: false,
        );
      }
      Logger.e('Ошибка при загрузке задач (фоновое обновление: $isSilent)', e);
    }
  }
  
  void setSortMode(TaskSortMode mode) {
    state = state.copyWith(
      sortMode: mode,
      taskCards: _applySort(state.taskCards, mode),
    );
  }

  List<TaskCardVm> _applySort(List<TaskCardVm> source, TaskSortMode mode) {
    final items = [...source];

    int compareByPriority(TaskCardVm a, TaskCardVm b) {
      final priorityCmp = b.priority.compareTo(a.priority);
      if (priorityCmp != 0) return priorityCmp;

      final aDeadline = a.deadline;
      final bDeadline = b.deadline;
      if (aDeadline != null && bDeadline != null) {
        final cmp = aDeadline.compareTo(bDeadline);
        if (cmp != 0) return cmp;
      } else if (aDeadline != null) {
        return -1;
      } else if (bDeadline != null) {
        return 1;
      }

      final progressCmp = b.progressFraction.compareTo(a.progressFraction);
      if (progressCmp != 0) return progressCmp;
      return b.createdAt.compareTo(a.createdAt);
    }

    int compareByDeadline(TaskCardVm a, TaskCardVm b) {
      if (a.deadline == null && b.deadline == null) return compareByPriority(a, b);
      if (a.deadline == null) return 1;
      if (b.deadline == null) return -1;
      final deadlineCmp = a.deadline!.compareTo(b.deadline!);
      if (deadlineCmp != 0) return deadlineCmp;
      return compareByPriority(a, b);
    }

    int compareByType(TaskCardVm a, TaskCardVm b) {
      final typeCmp = a.kind.compareTo(b.kind);
      if (typeCmp != 0) return typeCmp;
      return compareByPriority(a, b);
    }

    switch (mode) {
      case TaskSortMode.byPriority:
        items.sort(compareByPriority);
        break;
      case TaskSortMode.byDeadline:
        items.sort(compareByDeadline);
        break;
      case TaskSortMode.byType:
        items.sort(compareByType);
        break;
    }

    return items;
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    final taskService = ref.read(taskServiceProvider);

    taskService.stopPeriodicSync();
    await authService.logoutAsync();
  }
}