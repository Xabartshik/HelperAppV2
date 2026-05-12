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
      final client = ref.read(apiClientProvider);
      
      // Запрашиваем полный список сотрудников и детальную нагрузку параллельно
      final results = await Future.wait([
        client.getAllBranchEmployeesAsync(), // Твой новый метод для employees/all
        client.getDetailedBranchWorkloadAsync(user!.branchId!), // Эндпоинт employees/workload
      ]);

      final allEmployees = results[0] as List<AvailableEmployeeDto>;
      final activeWorkloads = results[1] as List<EmployeeWorkloadDto>;

      // Собираем итоговый список
      final mergedList = allEmployees.map((emp) {
        if (emp.isAtWork) {
          // Ищем нагрузку активного сотрудника
          return activeWorkloads.firstWhere(
            (w) => w.employeeId == emp.employeeId,
            orElse: () => EmployeeWorkloadDto(
              employeeId: emp.employeeId,
              fullName: emp.fullName,
              isAtWork: true,
              activeTasksCount: 0,
              activeTasks: [],
            ),
          );
        } else {
          // Если не на смене, создаем "пустую" карточку нагрузки
          return EmployeeWorkloadDto(
            employeeId: emp.employeeId,
            fullName: emp.fullName,
            isAtWork: false,
            activeTasksCount: 0,
            activeTasks: [],
          );
        }
      }).toList();

      state = state.copyWith(employees: mergedList, isLoading: false);
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
    
    list.sort((a, b) {
      // 1. Приоритет статуса: активные всегда выше отдыхающих
      if (a.isAtWork && !b.isAtWork) return -1;
      if (!a.isAtWork && b.isAtWork) return 1;

      // 2. Вторичная сортировка внутри группы
      switch (state.sortType) {
        case WorkloadSortType.name:
          return a.fullName.compareTo(b.fullName);
        case WorkloadSortType.tasks:
        case WorkloadSortType.complexity:
          // Для простоты сортируем по количеству задач
          return b.activeTasksCount.compareTo(a.activeTasksCount);
      }
    });

    state = state.copyWith(employees: list);
  }
}