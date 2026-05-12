import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/tasks/mobile_base_task_dto.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';

class GlobalPoolState {
  final bool isLoading;
  final String errorMessage;
  final List<MobileBaseTaskDto> poolTasks;
  final List<AvailableEmployeeDto> availableEmployees;

  const GlobalPoolState({
    this.isLoading = false,
    this.errorMessage = '',
    this.poolTasks = const [],
    this.availableEmployees = const [],
  });

  GlobalPoolState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<MobileBaseTaskDto>? poolTasks,
    List<AvailableEmployeeDto>? availableEmployees,
  }) {
    return GlobalPoolState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      poolTasks: poolTasks ?? this.poolTasks,
      availableEmployees: availableEmployees ?? this.availableEmployees,
    );
  }
}

final globalPoolTabViewModelProvider = AutoDisposeNotifierProvider<GlobalPoolTabViewModel, GlobalPoolState>(() {
  return GlobalPoolTabViewModel();
});

class GlobalPoolTabViewModel extends AutoDisposeNotifier<GlobalPoolState> {
  @override
  GlobalPoolState build() {
    Future.microtask(() => loadDataAsync());
    return const GlobalPoolState();
  }

  Future<void> loadDataAsync() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      final currentUser = ref.read(currentUserProvider);
      
      if (currentUser?.branchId == null) {
        state = state.copyWith(errorMessage: 'Филиал не определен', isLoading: false);
        return;
      }

      final results = await Future.wait([
        client.getGlobalPoolTasksAsync(currentUser!.branchId!),
        client.getBossPanelAvailableEmployeesAsync(),
      ]);

      final rawTasks = results[0] as List<MobileBaseTaskDto>;
      var employees = results[1] as List<AvailableEmployeeDto>;

      // Убираем задачи инвентаризации из интерфейса
      final filteredTasks = rawTasks.where((t) => t.taskType != 'Inventory').toList();
      
      // Оставляем только тех, кто на смене
      final workingEmployees = employees.where((e) => e.isAtWork).toList();

      state = state.copyWith(
        poolTasks: filteredTasks,
        availableEmployees: workingEmployees,
        isLoading: false,
      );
    } catch (e) {
      Logger.e('Ошибка загрузки пула задач', e);
      state = state.copyWith(
        errorMessage: 'Не удалось загрузить данные: $e',
        isLoading: false,
      );
    }
  }

  Future<bool> assignTaskToEmployee(int taskId, int employeeId) async {
    try {
      final client = ref.read(apiClientProvider);
      await client.claimTaskFromPoolAsync(taskId, employeeId);
      
      // После успешного назначения перезагружаем список
      await loadDataAsync();
      return true;
    } catch (e) {
      Logger.e('Ошибка назначения задачи', e);
      state = state.copyWith(errorMessage: 'Ошибка при назначении задачи: $e');
      return false;
    }
  }
}