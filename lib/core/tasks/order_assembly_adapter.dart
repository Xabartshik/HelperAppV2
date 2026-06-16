import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';
import 'package:helper_app/core/utils/logger.dart';

class OrderAssemblyTaskAdapter implements TaskTypeAdapter {
  @override
  String get taskType => 'OrderAssembly';

  @override
  TaskItemBase? parseListItem(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  @override
  TaskItemBase? parseDetails(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  OrderAssemblyTaskItem? _parse(MobileBaseTaskDto dto, int employeeId) {
    try {
      final cellPlacementsJson = dto.taskDetails['cellPlacements'] as List<dynamic>? ?? [];

      // Парсим детальную информацию о ячейках и товарах для руководителя
      final cellPlacements = cellPlacementsJson
          .map((c) => CellPlacementInfo(
                targetPositionId: c['targetPositionId'] ?? c['TargetPositionId'] ?? 0,
                cellCode: c['cellCode'] ?? c['CellCode'],
                cellDisplayName: c['cellDisplayName'] ?? c['CellDisplayName'],
                items: (c['items'] as List<dynamic>)
                      .map((i) => PlacementLineInfo(
                            lineId: i['lineId'] ?? i['LineId'] ?? 0,
                            itemPositionId: i['itemPositionId'] ?? i['ItemPositionId'] ?? 0,
                            quantity: i['quantity'] ?? i['Quantity'] ?? 0,
                            status: _parseLineStatus(i['status'] ?? i['Status']),
                            itemId: i['itemId'] ?? i['ItemId'],
                            itemName: i['itemName'] ?? i['ItemName'],
                            barcode: i['barcode'] ?? i['Barcode'],
                            sourceCellCode: i['sourceCellCode'] ?? i['SourceCellCode'],
                            pickedQuantity: i['pickedQuantity'] ?? i['PickedQuantity'] ?? 0,
                          ))
                      .toList(),
              ))
          .toList();

      final createdAt = (dto.createdAt ?? DateTime.now()).toUtc();
      final tDetails = dto.taskDetails;
      final totalLines = (tDetails['totalLines'] ?? tDetails['TotalLines'] ?? 0) as int;
      final completedLines = (tDetails['completedLines'] ?? tDetails['CompletedLines'] ?? 0) as int;
      final deadline = dto.deadline?.toUtc();
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
        assignmentId: dto.taskDetails['assignmentId'] ?? dto.taskId,
        orderId: dto.taskDetails['orderId'] ?? 0,
        totalLines: totalLines,
        completedLinesCount: completedLines,
        cellPlacements: cellPlacements,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи сборки из DTO агрегатора', e, stack);
      return null;
    }
  }

  @override
  TaskNavigationPayload buildNavigationPayload(TaskCardVm taskCard, int employeeId) {
    return TaskNavigationPayload(route: '/order-assembly/active', extra: {
      'assignmentId': taskCard.navigationId,
      'taskId': taskCard.rawTask?.taskId ?? 0,
      'taskStatusIndex': taskCard.rawTask?.assignmentStatus.index,
    });
  }
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

String _parseLineStatus(dynamic serverStatus) {
  // Если сервер уже прислал строку (например, 'picked') - просто возвращаем её
  if (serverStatus is String) {
    return serverStatus;
  }
  
  // Если сервер прислал число (Enum из C#) - мапим в нужную строку
  if (serverStatus is int) {
    switch (serverStatus) {
      case 0: return 'pending';
      case 1: return 'picked';
      case 2: return 'placed';
      case 3: return 'discrepancy'; // Если есть такой статус
      default: return 'pending';
    }
  }
  
  // Фолбэк по умолчанию
  return 'pending';
}