import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/network/api_endpoints.dart';
import '../utils/logger.dart';
import '../network/api_client.dart';
import '../network/api_exceptions.dart';
import '../models/tasks/mobile_base_task_dto.dart';
import '../models/tasks/task_models.dart';
import '../models/inventory/inventory_dtos.dart';
import '../models/order_assembly/order_assembly_dtos.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskService(apiClient);
});

class TaskService {
  final ApiClient _apiClient;
  bool useUnifiedWorkerTasksApi = true;
  Timer? _periodicSyncTimer;
  // Коллбэк периодической синхронизации работает с базовым типом для поддержки обоих видов задач
  Function(List<TaskItemBase>)? _onTasksUpdated;
  int _lastSyncEmployeeId = 0;

  TaskService(this._apiClient);
  late final Map<String, TaskItemBase? Function(MobileBaseTaskDto dto, int employeeId)> _taskParsers = {
    'Inventory': _mapToUnifiedInventoryTask,
    'OrderAssembly': _mapToUnifiedOrderAssemblyTask,
  };

  /// Возвращает объединённый список задач инвентаризации и сборки заказов для сотрудника
Future<List<TaskItemBase>> getTasksForCurrentUserAsync(int employeeId) async {
    try {
      Logger.i('Запрос задач через агрегатор для сотрудника $employeeId');

      if (employeeId <= 0) return [];

      final response = await _apiClient.getAsync(ApiEndpoints.workerTasksPending(employeeId));
      
      if (response == null || response is! List) return [];
      
      final List<TaskItemBase> allTasks = [];

      for (var item in response) {
        // 1. Строго типизируем ответ бэкенда через DTO
        final dto = MobileBaseTaskDto.fromJson(item as Map<String, dynamic>);
        
        // 2. Маппим DTO в доменные объекты в зависимости от типа задачи
        final parser = _taskParsers[dto.taskType];
        if (parser == null) {
          Logger.w('Неизвестный тип задачи от агрегатора: ${dto.taskType}');
          continue;
        }
        final task = parser(dto, employeeId);
        if (task != null) allTasks.add(task);
      }

      Logger.i('Получено ${allTasks.length} задач');
      return allTasks;
    } catch (e, stack) {
      Logger.e('TaskService: ошибка при загрузке задач', e, stack);
      rethrow;
    }
  }

  // Обновленный метод парсинга Инвентаризации (принимает DTO, а не Map)
  InventoryTaskItem? _mapToUnifiedInventoryTask(MobileBaseTaskDto dto, int employeeId) {
    try {
      final linesJson = _extractInventoryLines(dto.taskDetails);
      
      final lines = linesJson
          .map((l) => InventoryAssignmentLineWithItemDto.fromJson(l as Map<String, dynamic>))
          .map(_mapToInventoryLineItem)
          .whereType<InventoryLineItem>()
          .toList();

      final createdAt = (dto.createdAt ?? DateTime.now()).toUtc();

      final tDetails = dto.taskDetails;
      final totalLines = (tDetails['totalLines'] ?? tDetails['TotalLines'] ?? 0) as int;
      final completedLines = (tDetails['completedLines'] ?? tDetails['CompletedLines'] ?? 0) as int;
      final schemaVersion = _readSchemaVersion(dto.taskDetails);
      final typedDetails = InventoryDetails(
        schemaVersion: schemaVersion,
        assignmentId: dto.taskDetails['assignmentId'] ?? dto.taskId,
        totalLines: totalLines,
        completedLines: completedLines,
        lines: lines,
      );
      return InventoryTaskItem(
        taskId: dto.taskId,
        type: TaskType.inventory,
        branchId: dto.branchId,
        title: dto.title,
        description: dto.description,
        status: _parseStatusFromInt(dto.status),
        assignmentStatus: _parseAssignmentStatusFromInt(dto.assignmentStatus),
        deadline: dto.deadline,
        priority: dto.priority,
        createdAt: createdAt,
        completedAt: null,
        assignedToEmployeeId: employeeId,
        assignedAt: createdAt,
        assignmentId: dto.taskDetails['assignmentId'] ?? dto.taskId,
        lines: lines,
        totalLinesCount: totalLines,
        completedLinesCount: completedLines,
        details: typedDetails,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи инвентаризации из DTO агрегатора', e, stack);
      return null;
    }
  }

  List<Map<String, dynamic>> _extractInventoryLines(Map<String, dynamic> taskDetails) {
    final rawLines = taskDetails['lines'];
    if (rawLines is List) {
      return rawLines.whereType<Map<String, dynamic>>().toList();
    }

    final rawCells = taskDetails['cellInventories'];
    if (rawCells is! List) return const [];

    final lines = <Map<String, dynamic>>[];

    for (final rawCell in rawCells) {
      if (rawCell is! Map<String, dynamic>) continue;

      final positionId = (rawCell['positionId'] as num?)?.toInt() ?? 0;
      final positionCode = _buildPositionCodeJson(rawCell);
      final rawItems = rawCell['items'];
      if (rawItems is! List) continue;

      for (final rawItem in rawItems) {
        if (rawItem is! Map<String, dynamic>) continue;

        lines.add({
          'id': (rawItem['lineId'] as num?)?.toInt() ?? 0,
          'itemPositionId': (rawItem['itemPositionId'] as num?)?.toInt() ?? positionId,
          'positionId': positionId,
          'expectedQuantity': (rawItem['expectedQuantity'] as num?)?.toInt() ?? 0,
          'actualQuantity': (rawItem['actualQuantity'] as num?)?.toInt(),
          'itemId': (rawItem['itemId'] as num?)?.toInt() ?? 0,
          'itemName': (rawItem['itemName'] ?? '').toString(),
          'displayName': (rawItem['displayName'] ?? rawItem['itemName'] ?? '').toString(),
          'positionCode': positionCode,
        });
      }
    }

    return lines;
  }

  Map<String, dynamic> _buildPositionCodeJson(Map<String, dynamic> rawCell) {
    final rawPositionCode = rawCell['positionCode'];
    if (rawPositionCode is Map<String, dynamic>) {
      return rawPositionCode;
    }

    return {
      'branchId': (rawCell['branchId'] as num?)?.toInt() ?? 0,
      'zoneCode': (rawCell['zoneCode'] ?? '').toString(),
      'firstLevelStorageType': (rawCell['firstLevelStorageType'] ?? '').toString(),
      'flsNumber': (rawCell['flsNumber'] ?? rawCell['fLSNumber'] ?? '').toString(),
      'secondLevelStorage': rawCell['secondLevelStorage'],
      'thirdLevelStorage': rawCell['thirdLevelStorage'],
    };
  }


  TaskStatus _parseStatusFromInt(int serverStatus) {
    switch (serverStatus) {
      case 0: return TaskStatus.assigned;
      case 1: return TaskStatus.inProgress;
      case 2: return TaskStatus.paused;
      case 3: return TaskStatus.completed;
      case 4: return TaskStatus.cancelled;
      default: return TaskStatus.newStatus;
    }
  }

  AssignmentStatus _parseAssignmentStatusFromInt(int serverStatus) {
    switch (serverStatus) {
      case 0: return AssignmentStatus.assigned;
      case 1: return AssignmentStatus.inProgress;
      case 2: return AssignmentStatus.paused;
      case 3: return AssignmentStatus.completed;
      case 4: return AssignmentStatus.cancelled;
      default: return AssignmentStatus.assigned;
    }
  }

  OrderAssemblyTaskItem? _mapToUnifiedOrderAssemblyTask(MobileBaseTaskDto dto, int employeeId) {
    try {
      final rawLines = dto.taskDetails['lines'] ?? dto.taskDetails['cellPlacements'];
      final cellPlacementsJson = rawLines as List<dynamic>? ?? [];
      
      final cellPlacements = cellPlacementsJson.map((c) => CellPlacementInfo(
        targetPositionId: c['targetPositionId'],
        items: (c['items'] as List<dynamic>).map((i) => PlacementLineInfo(
          lineId: i['lineId'],
          itemPositionId: i['itemPositionId'],
          quantity: i['quantity'],
          status: i['status'] ?? 'pending',
        )).toList(),
      )).toList();

      final createdAt = (dto.createdAt ?? DateTime.now()).toUtc();

      final tDetails = dto.taskDetails;
      final totalLines = (tDetails['totalLines'] ?? tDetails['TotalLines'] ?? 0) as int;
      final completedLines = (tDetails['completedLines'] ?? tDetails['CompletedLines'] ?? 0) as int;
      final deadline = dto.deadline?.toUtc();
      final assignmentId = dto.taskDetails['assignmentId'] ?? dto.taskId;
      final orderId = dto.taskDetails['orderId'] ?? 0;
      final typedDetails = OrderAssemblyDetails(
        schemaVersion: _readSchemaVersion(dto.taskDetails),
        assignmentId: assignmentId,
        orderId: orderId,
        totalLines: totalLines,
        completedLines: completedLines,
        lines: cellPlacements,
      );
      return OrderAssemblyTaskItem(
        taskId: dto.taskId,
        type: TaskType.orderAssembly,
        branchId: dto.branchId,
        title: dto.title,
        description: dto.description,
        status: _parseStatusFromInt(dto.status),
        assignmentStatus: _parseAssignmentStatusFromInt(dto.assignmentStatus),
        priority: dto.priority,
        deadline: deadline,
        createdAt: createdAt,
        assignedToEmployeeId: employeeId,
        assignedAt: createdAt,
        assignmentId: assignmentId,
        orderId: orderId,
        totalLines: totalLines,
        completedLinesCount: completedLines,
        cellPlacements: cellPlacements,
        details: typedDetails,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи сборки из DTO агрегатора', e, stack);
      return null;
    }
  }

  int _readSchemaVersion(Map<String, dynamic> details) {
    final version = (details['schemaVersion'] as num?)?.toInt() ?? 1;
    if (version != _supportedSchemaVersion) {
      throw UnsupportedError('Неподдерживаемая schemaVersion: $version');
    }
    return version;
  }

  Future<InventoryTaskItem?> getUnifiedInventoryTaskDetailsAsync(int workerId, int taskId) async {
    final dto = await _apiClient.getWorkerTaskDetailsAsync(taskId, workerId);
    if (dto == null || dto.taskType != 'Inventory') return null;
    return _mapToUnifiedInventoryTask(dto, workerId);
  }

  Future<OrderAssemblyTaskItem?> getUnifiedOrderAssemblyTaskDetailsAsync(int workerId, int taskId) async {
    final dto = await _apiClient.getWorkerTaskDetailsAsync(taskId, workerId);
    if (dto == null || dto.taskType != 'OrderAssembly') return null;
    return _mapToUnifiedOrderAssemblyTask(dto, workerId);
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
      if (useUnifiedWorkerTasksApi) {
        await _apiClient.workerTaskStartAsync(taskId, workerId);
      } else {
        await _apiClient.postAsync(
          ApiEndpoints.workerTaskStart(taskId, workerId),
          data: {}, // legacy fallback
        );
      }

      await _performPeriodicSync();
      return true;
    } on NotFoundException catch (e) {
      Logger.w('Задача $taskId не найдена при старте: $e');
      await _performPeriodicSync();
      return false;
    } on ApiException catch (e, stack) {
      if (e.message.contains('400')) {
        Logger.w('Некорректный старт задачи $taskId (400): $e');
        await _performPeriodicSync();
        return false;
      }
      Logger.e('Ошибка API при старте задачи $taskId', e, stack);
      return false;
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
