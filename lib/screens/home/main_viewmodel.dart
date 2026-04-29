import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/task_service.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/models/tasks/task_card_vm.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/logger.dart';

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
  
  // НОВОЕ: Статус активной смены
  final bool isActiveShift;
  final bool isShiftLoading;

  const MainState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
    this.rawTasks = const [],
    this.taskCards = const [],
    this.sortMode = TaskSortMode.byPriority,
    this.isActiveShift = false,
    this.isShiftLoading = false,
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
    );
  }
}

final mainViewModelProvider = AutoDisposeNotifierProvider<MainViewModel, MainState>(() {
  return MainViewModel();
});

class MainViewModel extends AutoDisposeNotifier<MainState> {
  @override
  MainState build() {
    Future.microtask(() {
      checkShiftStatus();
      refreshTasks();
    });

    ref.onDispose(() {
      final taskService = ref.read(taskServiceProvider);
      taskService.stopPeriodicSync();
    });

    return const MainState();
  }

  /// НОВОЕ: Проверка, находится ли сотрудник на смене
  Future<void> checkShiftStatus() async {
    state = state.copyWith(isShiftLoading: true);
    try {
      // TODO: Здесь должен быть вызов вашего API для проверки статуса смены.
      // Например: final status = await ref.read(apiClientProvider).get('/api/QrCheckIn/status');
      // Пока имитируем задержку и считаем, что смены нет:
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = state.copyWith(isActiveShift: false, isShiftLoading: false);
    } catch (e) {
      Logger.e('Ошибка при проверке статуса смены', e);
      state = state.copyWith(isShiftLoading: false);
    }
  }

  /// НОВОЕ: Обработка отсканированного QR кода (Приход/Уход)
Future<bool> processQrCheckIn(String qrRawData, String checkType) async {
  state = state.copyWith(isShiftLoading: true, errorMessage: '');
  try {
    // 1. Пытаемся распарсить JSON, который зашит в QR-код с экрана
    final Map<String, dynamic> qrData = jsonDecode(qrRawData);
    final String payload = qrData['p'] ?? '';
    final int branchId = qrData['b'] ?? 1;

    if (payload.isEmpty) {
      throw Exception('Неверный формат QR-кода');
    }

    // 2. Получаем ApiClient (убедитесь, что у вас есть такой провайдер, 
    // либо читайте его так же, как TaskService)
    final apiClient = ref.read(apiClientProvider);

    // 3. Отправляем запрос на наш C# бэкенд
    await apiClient.scanQrCheckInAsync(payload, branchId, checkType);

    // 4. Если запрос успешен — обновляем статус UI
    final isNowActive = (checkType == 'in');
    state = state.copyWith(isActiveShift: isNowActive, isShiftLoading: false);
    
    // Если зашли на смену — грузим новые задачи
    if (isNowActive) {
      refreshTasks();
    }
    
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

  Future<void> refreshTasks() async {
    state = state.copyWith(isBusy: true, errorMessage: '');

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        Logger.w('CurrentUser не найден при обновлении задач');
        state = state.copyWith(isBusy: false);
        return;
      }

      final taskService = ref.read(taskServiceProvider);
      final tasks = await taskService.getTasksForCurrentUserAsync(currentUser.employeeId!);

      final taskCards = tasks.map(TaskCardVm.fromTask).toList();

      state = state.copyWith(
        rawTasks: tasks,
        taskCards: _applySort(taskCards, state.sortMode),
        hasNetwork: true,
        isBusy: false,
      );

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
      state = state.copyWith(
        errorMessage: 'Нет подключения к сети',
        hasNetwork: false,
        isBusy: false,
      );
    } on UnauthorizedException {
      await logout();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Ошибка загрузки задач: $e',
        isBusy: false,
      );
      Logger.e('Ошибка при загрузке задач', e);
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