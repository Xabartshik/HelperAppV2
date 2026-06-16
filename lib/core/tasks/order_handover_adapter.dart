import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';
import 'package:helper_app/core/utils/logger.dart';
import 'package:helper_app/core/models/order_handover/order_handover_dtos.dart';


class OrderHandoverTaskAdapter implements TaskTypeAdapter {
  @override
  String get taskType => 'OrderHandover';

  @override
  TaskItemBase? parseListItem(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  @override
  TaskItemBase? parseDetails(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  OrderHandoverTaskItem? _parse(MobileBaseTaskDto dto, int employeeId) {
    try {
      final createdAt = (dto.createdAt ?? DateTime.now()).toUtc();
      final deadline = dto.deadline?.toUtc();
      
      final tDetails = dto.taskDetails;
      
      // Парсим данные, игнорируя регистр первой буквы (на всякий случай)
      final assignmentId = (tDetails['assignmentId'] ?? tDetails['AssignmentId'] ?? dto.taskId) as int;
      final orderId = (tDetails['orderId'] ?? tDetails['OrderId'] ?? 0) as int;
      final handoverType = (tDetails['handoverType'] ?? tDetails['HandoverType'] ?? 'Unknown') as String;
      final totalLines = (tDetails['totalLines'] ?? tDetails['TotalLines'] ?? 0) as int;
      final completedLines = (tDetails['completedLines'] ?? tDetails['CompletedLines'] ?? 0) as int;

      // Парсим список товаров для выдачи
      final itemsToScanJson = tDetails['itemsToScan'] as List<dynamic>? ?? tDetails['ItemsToScan'] as List<dynamic>? ?? [];
      final lines = itemsToScanJson
          .map((e) => HandoverItemDto.fromJson(e as Map<String, dynamic>))
          .toList();

      return OrderHandoverTaskItem(
        taskId: dto.taskId,
        type: TaskType.orderHandover, // Убедись, что добавил его в enum в task_models.dart
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
        handoverType: handoverType,
        totalLines: totalLines,
        completedLinesCount: completedLines,
        lines: lines,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи выдачи из DTO агрегатора', e, stack);
      return null;
    }
  }

  @override
  TaskNavigationPayload buildNavigationPayload(TaskCardVm taskCard, int employeeId) {
    return TaskNavigationPayload(
      route: '/order-handover/active', // Маршрут, который мы добавили в app_router.dart
      extra: {
        'assignmentId': taskCard.navigationId,
        'taskId': taskCard.rawTask?.taskId ?? 0,
        'taskStatusIndex': taskCard.rawTask?.status.index,
        'assignmentStatusIndex': taskCard.rawTask?.assignmentStatus.index,
      },
    );
  }
}

// Вспомогательные парсеры статусов (как в сборке)
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