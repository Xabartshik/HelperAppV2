import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/network/api_endpoints.dart';
import '../utils/logger.dart';
import '../network/api_client.dart';
import '../models/tasks/mobile_base_task_dto.dart';
import '../models/tasks/task_models.dart';
import '../tasks/task_registry.dart';
import '../models/inventory/inventory_dtos.dart';
import '../models/order_assembly/order_assembly_dtos.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskService(apiClient);
});

class TaskService {
  final ApiClient _apiClient;
  Timer? _periodicSyncTimer;
  // Коллбэк периодической синхронизации работает с базовым типом для поддержки обоих видов задач
  Function(List<TaskItemBase>)? _onTasksUpdated;
  int _lastSyncEmployeeId = 0;

  TaskService(this._apiClient);

  /// Возвращает объединённый список задач инвентаризации и сборки заказов для сотрудника
Future<List<TaskItemBase>> getTasksForCurrentUserAsync(int employeeId) async {
    try {
      Logger.i('Запрос задач через агрегатор для сотрудника $employeeId');

      if (employeeId <= 0) return [];

      final response = await _apiClient.getAsync(ApiEndpoints.workerTasksPending(employeeId));
      
      if (response == null || response is! List) return [];
      
      final List<TaskItemBase> allTasks = [];

      for (var item in response) {
        final dto = MobileBaseTaskDto.fromJson(item as Map<String, dynamic>);
        final adapter = TaskRegistry.resolveByTaskType(dto.taskType);
        if (adapter == null) {
          Logger.w('Неизвестный тип задачи от агрегатора: ${dto.taskType}');
          continue;
        }

        final task = adapter.parseListItem(dto, employeeId);
        if (task != null) allTasks.add(task);
      }

      Logger.i('Получено ${allTasks.length} задач');
      return allTasks;
    } catch (e, stack) {
      Logger.e('TaskService: ошибка при загрузке задач', e, stack);
      rethrow;
    }
  }

  Future<InventoryTaskItem> getInventoryTaskDetailsAsync(int employeeId, int inventoryTaskId) async {
    try {
      Logger.i('Получение деталей задачи $inventoryTaskId для сотрудника $employeeId');

      if (employeeId <= 0 || inventoryTaskId <= 0) {
        throw ArgumentError('Некорректный ID сотрудника или задачи');
      }

      final tasks = await getTasksForCurrentUserAsync(employeeId);
      final task = tasks.whereType<InventoryTaskItem?>().firstWhere(
        (t) => t?.assignmentId == inventoryTaskId,
        orElse: () => null,
      );

      if (task == null) {
        Logger.w('Задача инвентаризации $inventoryTaskId не найдена для сотрудника $employeeId');
        throw StateError('Задача инвентаризации $inventoryTaskId не найдена');
      }

      Logger.i('Успешно получены детали задачи $inventoryTaskId: ${task.lines.length} строк');
      return task;
    } catch (e, stack) {
      Logger.e('Ошибка при получении деталей задачи инвентаризации $inventoryTaskId', e, stack);
      rethrow;
    }
  }

  void startPeriodicSync(Function(List<TaskItemBase>) onTasksUpdated, {int intervalSeconds = 30}) {
    try {
      if (intervalSeconds < 5) {
        Logger.w('Слишком малый интервал ($intervalSeconds). Используем 5 секунд');
        intervalSeconds = 5;
      }

      stopPeriodicSync();
      _onTasksUpdated = onTasksUpdated;

      Logger.i('Запуск периодической синхронизации с интервалом $intervalSeconds секунд');

      _periodicSyncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
        await _performPeriodicSync();
      });
      
      // Запускаем немедленно
      _performPeriodicSync();
    } catch (e, stack) {
      Logger.e('Ошибка при запуске периодической синхронизации', e, stack);
      rethrow;
    }
  }

  void stopPeriodicSync() {
    if (_periodicSyncTimer != null) {
      Logger.i('Остановка периодической синхронизации');
      _periodicSyncTimer!.cancel();
      _periodicSyncTimer = null;
    }
    _onTasksUpdated = null;
  }

  Future<void> _performPeriodicSync() async {
    try {
      if (_lastSyncEmployeeId <= 0) {
        Logger.i('Пропуск периодической синхронизации: ID сотрудника не установлен');
        return;
      }

      final tasks = await getTasksForCurrentUserAsync(_lastSyncEmployeeId);

      if (_onTasksUpdated != null) {
        _onTasksUpdated!(tasks);
      }
    } catch (e) {
      Logger.e('Ошибка во время периодической синхронизации', e);
      // Не пробрасываем, чтобы таймер продолжал работать
    }
  }

  bool get isPeriodicSyncActive => _periodicSyncTimer != null;

  void setEmployeeIdForPeriodicSync(int employeeId) {
    _lastSyncEmployeeId = employeeId;
    Logger.i('Установлен ID сотрудника для синхронизации: $employeeId');
  }

  int get employeeIdForPeriodicSync => _lastSyncEmployeeId;

  // Мапперы 

  OrderAssemblyTaskItem? _mapToOrderAssemblyTaskItem(WorkerAssemblyTaskDto dto, int employeeId) {
    try {
      final now = DateTime.now().toUtc();

      // Преобразуем статус назначения в статус задачи
      final taskStatus = switch (dto.status) {
        OrderAssemblyAssignmentStatus.inProgress => TaskStatus.inProgress,
        OrderAssemblyAssignmentStatus.completed  => TaskStatus.completed,
        OrderAssemblyAssignmentStatus.cancelled  => TaskStatus.cancelled,
        _                                         => TaskStatus.assigned,
      };

      final assignmentStatus = switch (dto.status) {
        OrderAssemblyAssignmentStatus.inProgress => AssignmentStatus.inProgress,
        OrderAssemblyAssignmentStatus.completed  => AssignmentStatus.completed,
        OrderAssemblyAssignmentStatus.cancelled  => AssignmentStatus.cancelled,
        _                                         => AssignmentStatus.assigned,
      };

      final cellPlacements = dto.cellPlacements.map((c) => CellPlacementInfo(
        targetPositionId: c.targetPositionId,
        items: c.items.map((i) => PlacementLineInfo(
          lineId: i.lineId,
          itemPositionId: i.itemPositionId,
          quantity: i.quantity,
          status: i.status.name, // Используем name от enum OrderAssemblyLineStatus
        )).toList(),
      )).toList();

      return OrderAssemblyTaskItem(
        taskId: dto.taskId,
        type: TaskType.orderAssembly,
        branchId: 0,
        title: 'Сборка заказа #${dto.orderId}',
        description: null,
        status: taskStatus,
        assignmentStatus: assignmentStatus,
        priority: 7,
        createdAt: now,
        assignedToEmployeeId: employeeId,
        assignedAt: now,
        assignmentId: dto.assignmentId,
        orderId: dto.orderId,
        totalLines: dto.totalLines,
        cellPlacements: cellPlacements,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи сборки ${dto.assignmentId}', e, stack);
      return null;
    }
  }

  /// Запуск или возобновление задачи
  Future<bool> startTaskAsync(int taskId, int workerId) async {
    try {
      Logger.i('Запуск задачи $taskId для работника $workerId');

      // Используем вынесенный эндпоинт
      final response = await _apiClient.postAsync(
        ApiEndpoints.workerTaskStart(taskId, workerId),
        data: {}, // Тело пустое, так как параметры в Query
      );

      // После успешного запуска обновляем список задач, 
      // чтобы получить актуальные статусы (включая Paused для других задач)
      await _performPeriodicSync();
      
      return true;
    } catch (e, stack) {
      Logger.e('Ошибка при старте задачи $taskId', e, stack);
      return false;
    }
  }

  InventoryLineItem? _mapToInventoryLineItem(InventoryAssignmentLineWithItemDto line) {
    try {
      return InventoryLineItem(
        lineId: line.id,
        itemPositionId: line.itemPositionId,
        expectedQuantity: line.expectedQuantity,
        actualQuantity: line.actualQuantity,
        positionCode: _mapToPositionCodeInfo(line.positionCode),
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга строки ${line.id}', e, stack);
      return null;
    }
  }

  PositionCodeInfo _mapToPositionCodeInfo(PositionCodeDto dto) {
    return PositionCodeInfo(
      branchId: dto.branchId,
      zoneCode: dto.zoneCode,
      firstLevelStorageType: dto.firstLevelStorageType,
      flsNumber: dto.flsNumber,
      secondLevelStorage: dto.secondLevelStorage,
      thirdLevelStorage: dto.thirdLevelStorage,
    );
  }

  void dispose() {
    stopPeriodicSync();
    Logger.i('TaskService уничтожен');
  }
}
