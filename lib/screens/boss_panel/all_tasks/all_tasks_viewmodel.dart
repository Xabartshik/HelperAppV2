import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/boss_panel/boss_panel_models.dart';
import '../../../core/network/api_client.dart';

enum TaskFilterStatus { all, completed, uncompleted, notStarted }
enum TaskSortType { newest, oldest, progressDesc, progressAsc }

class AllTasksState {
  final bool isLoading;
  final List<BossPanelTaskCardDto> allTasks;
  final List<BossPanelTaskCardDto> filteredTasks;
  final DateTimeRange? dateRange;
  final int? selectedEmployeeId;
  final List<EmployeeWorkloadDto> branchEmployees;
  final TaskFilterStatus filterStatus;
  final TaskSortType sortType;

  AllTasksState({
    this.isLoading = false,
    this.allTasks = const [],
    this.filteredTasks = const [],
    this.dateRange,
    this.selectedEmployeeId,
    this.branchEmployees = const [],
    this.filterStatus = TaskFilterStatus.all,
    this.sortType = TaskSortType.newest,
  });

  AllTasksState copyWith({
    bool? isLoading,
    List<BossPanelTaskCardDto>? allTasks,
    List<BossPanelTaskCardDto>? filteredTasks,
    DateTimeRange? dateRange,
    int? selectedEmployeeId,
    List<EmployeeWorkloadDto>? branchEmployees,
    TaskFilterStatus? filterStatus,
    TaskSortType? sortType,
  }) {
    return AllTasksState(
      isLoading: isLoading ?? this.isLoading,
      allTasks: allTasks ?? this.allTasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      dateRange: dateRange ?? this.dateRange,
      selectedEmployeeId: selectedEmployeeId ?? this.selectedEmployeeId,
      branchEmployees: branchEmployees ?? this.branchEmployees,
      filterStatus: filterStatus ?? this.filterStatus,
      sortType: sortType ?? this.sortType,
    );
  }
}

final allTasksViewModelProvider = StateNotifierProvider.autoDispose<AllTasksViewModel, AllTasksState>((ref) {
  return AllTasksViewModel(ref);
});

class AllTasksViewModel extends StateNotifier<AllTasksState> {
  final Ref ref;

  AllTasksViewModel(this.ref) : super(AllTasksState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      final employees = await client.getBossPanelEmployeeWorkloadAsync();
      state = state.copyWith(branchEmployees: employees);
    } catch (e) {
      // ignore
    }
    await loadTasks();
  }

  Future<void> loadTasks() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      final tasks = await client.getBossPanelAllTasksAsync(
        from: state.dateRange?.start,
        to: state.dateRange?.end,
        employeeId: state.selectedEmployeeId,
      );
      state = state.copyWith(isLoading: false, allTasks: tasks);
      _applyFilterAndSort();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
    loadTasks();
  }

  void updateEmployee(int? employeeId) {
    state = state.copyWith(selectedEmployeeId: employeeId);
    loadTasks();
  }

  void updateFilterStatus(TaskFilterStatus status) {
    state = state.copyWith(filterStatus: status);
    _applyFilterAndSort();
  }

  void updateSortType(TaskSortType type) {
    state = state.copyWith(sortType: type);
    _applyFilterAndSort();
  }

  // Применяет выбранные фильтры и сортировку к загруженным задачам
  void _applyFilterAndSort() {
    var list = List<BossPanelTaskCardDto>.from(state.allTasks);

    // Фильтрация по прогрессу выполнения
    switch (state.filterStatus) {
      case TaskFilterStatus.completed:
        list = list.where((t) => t.overallProgressPercentage == 100).toList();
        break;
      case TaskFilterStatus.uncompleted:
        list = list.where((t) => t.overallProgressPercentage < 100).toList();
        break;
      case TaskFilterStatus.notStarted:
        list = list.where((t) => t.overallProgressPercentage == 0).toList();
        break;
      case TaskFilterStatus.all:
        break;
    }

    // Сортировка по времени создания или по прогрессу
    switch (state.sortType) {
      case TaskSortType.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSortType.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TaskSortType.progressDesc:
        list.sort((a, b) => b.overallProgressPercentage.compareTo(a.overallProgressPercentage));
        break;
      case TaskSortType.progressAsc:
        list.sort((a, b) => a.overallProgressPercentage.compareTo(b.overallProgressPercentage));
        break;
    }

    state = state.copyWith(filteredTasks: list);
  }
}
