import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/services/auth_service.dart';

class ActiveTasksState {
  final bool isLoading;
  final List<BossPanelTaskCardDto> tasks;
  final BossPanelTaskCardDto? selectedTask; // Для "проваливания" в задачу

  ActiveTasksState({
    this.isLoading = false,
    this.tasks = const [],
    this.selectedTask,
  });

  ActiveTasksState copyWith({
    bool? isLoading,
    List<BossPanelTaskCardDto>? tasks,
    BossPanelTaskCardDto? selectedTask,
    bool clearSelection = false,
  }) {
    return ActiveTasksState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      selectedTask: clearSelection ? null : (selectedTask ?? this.selectedTask),
    );
  }
}

final activeTasksProvider = AutoDisposeNotifierProvider<ActiveTasksViewModel, ActiveTasksState>(
  () => ActiveTasksViewModel(),
);

class ActiveTasksViewModel extends AutoDisposeNotifier<ActiveTasksState> {
  @override
  ActiveTasksState build() {
    Future.microtask(() => loadTasks());
    return ActiveTasksState();
  }

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      final allTasks = await client.getBossPanelActiveTasksAsync();
      
      // Исключаем задачи инвентаризации на уровне клиента для чистоты дашборда
      final logisticsTasks = allTasks.where((t) => 
        t.taskType.toLowerCase() != 'inventory' && 
        t.taskType.toLowerCase() != 'inventarization'
      ).toList();

      state = state.copyWith(tasks: logisticsTasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectTask(BossPanelTaskCardDto task) {
    state = state.copyWith(selectedTask: task);
  }

  void deselectTask() {
    state = state.copyWith(clearSelection: true);
  }
}