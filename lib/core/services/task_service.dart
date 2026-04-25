import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/utils/task_factory.dart';
import '../utils/logger.dart';
import '../network/api_client.dart';
import '../models/tasks/task_models.dart';
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

      // Использование статического метода из ApiEndpoints
      final response = await _apiClient.getAsync(ApiEndpoints.workerTasksPending(employeeId));
      
      if (response == null || response is! List) return [];
      
      // Используем фабрику для каждой задачи в списке
      final allTasks = response
          .map((json) => TaskFactory.createFromJson(json as Map<String, dynamic>, employeeId))
          .whereType<TaskItemBase>() // Автоматически удаляет null (неизвестные типы)
          .toList();

      Logger.i('Получено ${allTasks.length} задач');
      return allTasks;
    } catch (e, stack) {
      Logger.e('TaskService: ошибка при загрузке задач', e, stack);
      rethrow;
    }
  }


  InventoryTaskItem? _parseUnifiedInventoryTask(Map<String, dynamic> json, int employeeId) {
    try {
      final createdAt = _parseCreatedDate(json['createdAt']);
      final details = json['taskDetails'] ?? {}; // Берем полиморфную нагрузку
      final linesJson = details['lines'] as List<dynamic>? ?? [];
      
      final lines = linesJson
          .map((l) => InventoryAssignmentLineWithItemDto.fromJson(l))
          .map(_mapToInventoryLineItem)
          .whereType<InventoryLineItem>()
          .toList();

      return InventoryTaskItem(
        taskId: json['taskId'],
        type: TaskType.inventory,
        branchId: json['branchId'] ?? 0,
        title: json['title'] ?? 'Инвентаризация',
        description: json['description'],
        status: TaskStatus.newStatus, // Либо парсить json['status'] если оно передается
        priority: json['priority'] ?? 5,
        createdAt: createdAt,
        completedAt: null,
        assignedToEmployeeId: employeeId,
        assignedAt: createdAt,
        assignmentId: details['assignmentId'] ?? json['taskId'],
        lines: lines,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи инвентаризации из агрегатора', e, stack);
      return null;
    }
  }

  OrderAssemblyTaskItem? _parseUnifiedOrderAssemblyTask(Map<String, dynamic> json, int employeeId) {
    try {
      final createdAt = _parseCreatedDate(json['createdAt']);
      final details = json['taskDetails'] ?? {};

      // Маппинг ячеек сборки (зависит от того, как Backend сериализует OrderAssemblyDetailsDto)
      final cellPlacementsJson = details['cellPlacements'] as List<dynamic>? ?? [];
      final cellPlacements = cellPlacementsJson.map((c) => CellPlacementInfo(
        targetPositionId: c['targetPositionId'],
        items: (c['items'] as List<dynamic>).map((i) => PlacementLineInfo(
          lineId: i['lineId'],
          itemPositionId: i['itemPositionId'],
          quantity: i['quantity'],
          status: i['status'] ?? 'pending',
        )).toList(),
      )).toList();

      return OrderAssemblyTaskItem(
        taskId: json['taskId'],
        type: TaskType.orderAssembly,
        branchId: json['branchId'] ?? 0,
        title: json['title'] ?? 'Сборка заказа',
        description: json['description'],
        status: TaskStatus.assigned, 
        priority: json['priority'] ?? 7,
        createdAt: createdAt,
        assignedToEmployeeId: employeeId,
        assignedAt: createdAt,
        assignmentId: details['assignmentId'] ?? json['taskId'],
        orderId: details['orderId'] ?? 0,
        totalLines: details['totalLines'] ?? 0,
        cellPlacements: cellPlacements,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи сборки из агрегатора', e, stack);
      return null;
    }
  }



  Future<InventoryTaskItem> getInventoryTaskDetailsAsync(int employeeId, int inventoryTaskId) async {
    try {
      Logger.i('Получение деталей задачи $inventoryTaskId для сотрудника $employeeId');

      if (employeeId <= 0 || inventoryTaskId <= 0) {
        throw ArgumentError('Некорректный ID сотрудника или задачи');
      }

      final tasks = await getTasksForCurrentUserAsync(employeeId);
      final task = tasks.cast<InventoryTaskItem?>().firstWhere(
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

  InventoryTaskItem? _mapToInventoryTaskItem(InventoryAssignmentDetailedWithItemDto assignment, int employeeId) {
    try {
      final createdAt = _parseCreatedDate(assignment.createdDate);

      final lines = assignment.lines.map(_mapToInventoryLineItem).whereType<InventoryLineItem>().toList();

      return InventoryTaskItem(
        taskId: assignment.id,
        type: TaskType.inventory,
        branchId: 0,
        title: assignment.taskNumber.isNotEmpty ? assignment.taskNumber : 'Inventory ${assignment.id}',
        description: assignment.description,
        status: TaskStatus.newStatus,
        priority: 5,
        createdAt: createdAt,
        completedAt: null,
        assignedToEmployeeId: employeeId,
        assignedAt: createdAt,
        assignmentId: assignment.id,
        lines: lines,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи ${assignment.id}', e, stack);
      return null;
    }
  }

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
      flsNumber: dto.fLSNumber,
      secondLevelStorage: dto.secondLevelStorage,
      thirdLevelStorage: dto.thirdLevelStorage,
    );
  }

  DateTime _parseCreatedDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now().toUtc();
    }
    final parsed = DateTime.tryParse(dateString);
    if (parsed != null) return parsed;
    Logger.w('Не удалось распарсить CreatedDate "$dateString"');
    return DateTime.now().toUtc();
  }

  void dispose() {
    stopPeriodicSync();
    Logger.i('TaskService уничтожен');
  }
}