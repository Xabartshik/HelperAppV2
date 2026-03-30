import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/task_service.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/models/tasks/task_card_vm.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/logger.dart';

class MainState {
  final bool isBusy;
  final String errorMessage;
  final bool hasNetwork;
  final List<TaskItemBase> rawTasks;
  final List<TaskCardVm> taskCards;

  const MainState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
    this.rawTasks = const [],
    this.taskCards = const [],
  });

  MainState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool? hasNetwork,
    List<TaskItemBase>? rawTasks,
    List<TaskCardVm>? taskCards,
  }) {
    return MainState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNetwork: hasNetwork ?? this.hasNetwork,
      rawTasks: rawTasks ?? this.rawTasks,
      taskCards: taskCards ?? this.taskCards,
    );
  }
}

final mainViewModelProvider = AutoDisposeNotifierProvider<MainViewModel, MainState>(() {
  return MainViewModel();
});

class MainViewModel extends AutoDisposeNotifier<MainState> {
  @override
  MainState build() {
    // При инициализации запускаем загрузку
    Future.microtask(() => refreshTasks());
    
    ref.onDispose(() {
      final taskService = ref.read(taskServiceProvider);
      taskService.stopPeriodicSync();
    });
    
    return const MainState();
  }

  Future<void> refreshTasks() async {
    state = state.copyWith(isBusy: true, errorMessage: '');

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        Logger.w("CurrentUser не найден при обновлении задач");
        return;
      }

      final taskService = ref.read(taskServiceProvider);
      final tasks = await taskService.getTasksForCurrentUserAsync(currentUser.employeeId);

      final taskCards = tasks.map((t) => TaskCardVm.fromTask(t)).toList();

      state = state.copyWith(
        rawTasks: tasks,
        taskCards: taskCards,
        hasNetwork: true,
        isBusy: false,
      );

      // Запускаем периодическую синхронизацию
      taskService.setEmployeeIdForPeriodicSync(currentUser.employeeId);
      if (!taskService.isPeriodicSyncActive) {
        taskService.startPeriodicSync((updatedTasks) {
          final updatedCards = updatedTasks.map((t) => TaskCardVm.fromTask(t)).toList();
          state = state.copyWith(
            rawTasks: updatedTasks,
            taskCards: updatedCards,
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

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    final taskService = ref.read(taskServiceProvider);
    
    taskService.stopPeriodicSync();
    await authService.logoutAsync();
    
    // Переход на логин сработает через GoRouter автоматически
  }
}
