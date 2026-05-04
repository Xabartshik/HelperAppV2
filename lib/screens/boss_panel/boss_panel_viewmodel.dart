import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/utils/logger.dart';

class BossPanelState {
  final bool isLoading;
  final String errorMessage;
  final List<BossPanelTaskCardDto> activeTasks;
  final List<EmployeeWorkloadDto> employeeWorkloads;
  final int currentTabIndex; // Индекс для навигации через Drawer[cite: 2]

  const BossPanelState({
    this.isLoading = false,
    this.errorMessage = '',
    this.activeTasks = const [],
    this.employeeWorkloads = const [],
    this.currentTabIndex = 0,
  });

  BossPanelState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BossPanelTaskCardDto>? activeTasks,
    List<EmployeeWorkloadDto>? employeeWorkloads,
    int? currentTabIndex,
  }) {
    return BossPanelState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      activeTasks: activeTasks ?? this.activeTasks,
      employeeWorkloads: employeeWorkloads ?? this.employeeWorkloads,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

final bossPanelViewModelProvider = AutoDisposeNotifierProvider<BossPanelViewModel, BossPanelState>(() {
  return BossPanelViewModel();
});

class BossPanelViewModel extends AutoDisposeNotifier<BossPanelState> {
  @override
  BossPanelState build() {
    Future.microtask(() => loadDataAsync());
    return const BossPanelState();
  }

  /// Переключение вкладок через боковое меню[cite: 2]
  void setTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }

  /// Загрузка актуальных данных по задачам и персоналу[cite: 2]
  Future<void> loadDataAsync() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      
      final results = await Future.wait([
        client.getBossPanelActiveTasksAsync(),
        client.getBossPanelEmployeeWorkloadAsync(),
      ]);

      final tasks = results[0] as List<BossPanelTaskCardDto>;
      final workloads = results[1] as List<EmployeeWorkloadDto>;
      
      workloads.sort((a, b) => b.activeTasksCount.compareTo(a.activeTasksCount));

      state = state.copyWith(
        activeTasks: tasks,
        employeeWorkloads: workloads,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Не удалось обновить данные: $e', 
        isLoading: false
      );
      Logger.e('BossPanel refresh error', e);
    }
  }
}