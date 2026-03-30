import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';
import '../network/api_client.dart';
import '../models/tasks/task_models.dart';
import '../models/inventory/inventory_dtos.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TaskService(apiClient);
});

class TaskService {
  final ApiClient _apiClient;
  Timer? _periodicSyncTimer;
  Function(List<InventoryTaskItem>)? _onTasksUpdated;
  int _lastSyncEmployeeId = 0;

  TaskService(this._apiClient);

  Future<List<InventoryTaskItem>> getTasksForCurrentUserAsync(int employeeId) async {
    try {
      Logger.i('Получение задач для сотрудника $employeeId');

      if (employeeId <= 0) {
        Logger.w('Некорректный ID сотрудника: $employeeId');
        return [];
      }

      final response = await _apiClient.getAsync('v1/Inventory/worker/$employeeId/new-tasks');
      
      if (response == null || (response is List && response.isEmpty)) {
        Logger.i('Задачи не найдены для сотрудника $employeeId');
        return [];
      }

      final List<dynamic> dataList = response;
      final assignments = dataList
          .map((json) => InventoryAssignmentDetailedWithItemDto.fromJson(json))
          .toList();

      final tasks = assignments.map((a) => _mapToInventoryTaskItem(a, employeeId)).whereType<InventoryTaskItem>().toList();

      Logger.i('Успешно смаплено ${tasks.length} задач для сотрудника $employeeId');
      return tasks;
    } catch (e, stack) {
      Logger.e('Ошибка при получении задач для сотрудника $employeeId', e, stack);
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

  void startPeriodicSync(Function(List<InventoryTaskItem>) onTasksUpdated, {int intervalSeconds = 30}) {
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

  // --- Mappers ---

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
