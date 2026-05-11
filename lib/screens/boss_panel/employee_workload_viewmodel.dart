import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/services/auth_service.dart';

enum WorkloadSortType { name, tasks, complexity }

class WorkloadState {
  final bool isLoading;
  final List<EmployeeWorkloadDto> employees;
  final WorkloadSortType sortType;
  final bool isChartExpanded;

  WorkloadState({
    this.isLoading = false,
    this.employees = const [],
    this.sortType = WorkloadSortType.complexity,
    this.isChartExpanded = false,
  });

  WorkloadState copyWith({
    bool? isLoading,
    List<EmployeeWorkloadDto>? employees,
    WorkloadSortType? sortType,
    bool? isChartExpanded,
  }) {
    return WorkloadState(
      isLoading: isLoading ?? this.isLoading,
      employees: employees ?? this.employees,
      sortType: sortType ?? this.sortType,
      isChartExpanded: isChartExpanded ?? this.isChartExpanded,
    );
  }
}

final employeeWorkloadProvider = AutoDisposeNotifierProvider<EmployeeWorkloadViewModel, WorkloadState>(
  () => EmployeeWorkloadViewModel(),
);

class EmployeeWorkloadViewModel extends AutoDisposeNotifier<WorkloadState> {
  @override
  WorkloadState build() {
    Future.microtask(() => loadData());
    return WorkloadState();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final user = ref.read(currentUserProvider);
    if (user?.branchId == null) return;

    try {
      final data = await ref.read(apiClientProvider).getDetailedBranchWorkloadAsync(user!.branchId!);
      // Фильтруем: только те, кто на работе
      final activeEmployees = data.where((e) => e.isAtWork).toList();
      state = state.copyWith(employees: activeEmployees, isLoading: false);
      _sort();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void changeSort(WorkloadSortType type) {
    state = state.copyWith(sortType: type);
    _sort();
  }

  void toggleChart() {
    state = state.copyWith(isChartExpanded: !state.isChartExpanded);
  }

  void _sort() {
    final list = List<EmployeeWorkloadDto>.from(state.employees);
    switch (state.sortType) {
      case WorkloadSortType.name:
        list.sort((a, b) => a.fullName.compareTo(b.fullName));
        break;
      case WorkloadSortType.tasks:
        list.sort((a, b) => b.activeTasksCount.compareTo(a.activeTasksCount));
        break;
      case WorkloadSortType.complexity:
        list.sort((a, b) => b.totalComplexity.compareTo(a.totalComplexity));
        break;
    }
    state = state.copyWith(employees: list);
  }
}