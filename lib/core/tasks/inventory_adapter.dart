import 'package:helper_app/core/models/inventory/inventory_dtos.dart';
import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';
import 'package:helper_app/core/utils/logger.dart';

class InventoryTaskAdapter implements TaskTypeAdapter {
  @override
  String get taskType => 'Inventory';

  @override
  TaskItemBase? parseListItem(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  @override
  TaskItemBase? parseDetails(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  InventoryTaskItem? _parse(MobileBaseTaskDto dto, int employeeId) {
    try {
      final linesJson = _extractInventoryLines(dto.taskDetails);

      final lines = linesJson
          .map((l) => InventoryAssignmentLineWithItemDto.fromJson(l))
          .map(_mapToInventoryLineItem)
          .whereType<InventoryLineItem>()
          .toList();

      final createdAt = (dto.createdAt ?? DateTime.now()).toUtc();
      final tDetails = dto.taskDetails;
      final totalLines = (tDetails['totalLines'] ?? tDetails['TotalLines'] ?? 0) as int;
      final completedLines = (tDetails['completedLines'] ?? tDetails['CompletedLines'] ?? 0) as int;

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
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи инвентаризации из DTO агрегатора', e, stack);
      return null;
    }
  }

  @override
  TaskNavigationPayload buildNavigationPayload(TaskCardVm taskCard, int employeeId) {
    return TaskNavigationPayload(route: '/inventory-details', extra: {
      'workerId': employeeId,
      'assignmentId': taskCard.navigationId,
      'taskId': taskCard.rawTask?.taskId ?? 0,
      'taskStatusIndex': taskCard.rawTask?.assignmentStatus.index,
    });
  }
}

InventoryLineItem? _mapToInventoryLineItem(InventoryAssignmentLineWithItemDto dto) {
  final itemPositionId = dto.itemPositionId > 0 ? dto.itemPositionId : dto.positionId;
  if (itemPositionId <= 0) {
    return null;
  }

  final rawPosition = dto.positionCode;
  PositionCodeInfo? position;
  if (rawPosition != null) {
    position = PositionCodeInfo(
      branchId: rawPosition.branchId,
      zoneCode: rawPosition.zoneCode,
      firstLevelStorageType: rawPosition.firstLevelStorageType,
      flsNumber: rawPosition.fLSNumber,
      secondLevelStorage: rawPosition.secondLevelStorage,
      thirdLevelStorage: rawPosition.thirdLevelStorage,
    );
  }

  return InventoryLineItem(
    lineId: dto.id,
    itemPositionId: itemPositionId,
    expectedQuantity: dto.expectedQuantity,
    actualQuantity: dto.actualQuantity,
    positionCode: position,
  );
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
    case 0:
      return TaskStatus.assigned;
    case 1:
      return TaskStatus.inProgress;
    case 2:
      return TaskStatus.paused;
    case 3:
      return TaskStatus.completed;
    case 4:
      return TaskStatus.cancelled;
    default:
      return TaskStatus.newStatus;
  }
}

AssignmentStatus _parseAssignmentStatusFromInt(int serverStatus) {
  switch (serverStatus) {
    case 0:
      return AssignmentStatus.assigned;
    case 1:
      return AssignmentStatus.inProgress;
    case 2:
      return AssignmentStatus.paused;
    case 3:
      return AssignmentStatus.completed;
    case 4:
      return AssignmentStatus.cancelled;
    default:
      return AssignmentStatus.assigned;
  }
}
