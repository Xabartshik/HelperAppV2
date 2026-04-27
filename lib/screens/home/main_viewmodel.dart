import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  const MainState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
    this.rawTasks = const [],
    this.taskCards = const [],
    this.sortMode = TaskSortMode.byPriority,
  });

  MainState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool? hasNetwork,
    List<TaskItemBase>? rawTasks,
    List<TaskCardVm>? taskCards,
    TaskSortMode? sortMode,
  }) {
    return MainState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNetwork: hasNetwork ?? this.hasNetwork,
      rawTasks: rawTasks ?? this.rawTasks,
      taskCards: taskCards ?? this.taskCards,
      sortMode: sortMode ?? this.sortMode,
    );
  }
}

final mainViewModelProvider = AutoDisposeNotifierProvider<MainViewModel, MainState>(() {
  return MainViewModel();
});

class MainViewModel extends AutoDisposeNotifier<MainState> {
  @override
  MainState build() {
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
        Logger.w('CurrentUser не найден при обновлении задач');
        state = state.copyWith(isBusy: false);
        return;
      }

      final taskService = ref.read(taskServiceProvider);
      final tasks = await taskService.getTasksForCurrentUserAsync(currentUser.employeeId);

      final taskCards = tasks.map(TaskCardVm.fromTask).toList();

      state = state.copyWith(
        rawTasks: tasks,
        taskCards: _applySort(taskCards, state.sortMode),
        hasNetwork: true,
        isBusy: false,
      );

      taskService.setEmployeeIdForPeriodicSync(currentUser.employeeId);
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
