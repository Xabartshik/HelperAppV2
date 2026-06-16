import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';
import 'package:helper_app/core/utils/logger.dart';
import 'package:helper_app/core/models/return_to_stock/return_to_stock_dtos.dart';

class ReturnToStockAdapter implements TaskTypeAdapter {
  @override
  String get taskType => 'ReturnToStock';

  @override
  TaskItemBase? parseListItem(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  @override
  TaskItemBase? parseDetails(MobileBaseTaskDto dto, int employeeId) => _parse(dto, employeeId);

  ReturnToStockTaskItem? _parse(MobileBaseTaskDto dto, int employeeId) {
    try {
      // Благодаря freezed, taskDetails гарантированно является Map<String, dynamic>
      final tDetails = dto.taskDetails;

      final assignmentId = _getInt(tDetails, 'assignmentId') ?? dto.taskId;
      final isCooperative = _getBool(tDetails, 'isCooperative');
      final partnerName = _getString(tDetails, 'partnerName');

      final itemsList = _getList(tDetails, 'itemsToScan');
      final totalLines = itemsList.length;
      
      int completedLines = 0;
      for (var item in itemsList) {
        if (item is Map<String, dynamic>) {
          final qty = _getInt(item, 'quantity') ?? 0;
          final scanned = _getInt(item, 'scannedQuantity') ?? 0;
          if (qty > 0 && scanned >= qty) completedLines++;
        }
      }

      // Парсим список товаров для возврата на полку
      final lines = itemsList
          .map((e) => ReturnItemDto.fromJson(e as Map<String, dynamic>))
          .toList();

      return ReturnToStockTaskItem(
        taskId: dto.taskId,
        type: TaskType.returnToStock,
        branchId: dto.branchId,
        title: dto.title,
        description: dto.description,
        status: _parseStatusFromInt(dto.status), // В вашей DTO это уже int
        assignmentStatus: _parseAssignmentStatusFromInt(dto.assignmentStatus),
        priority: dto.priority, // В вашей DTO это priority (а не priorityLevel)
        deadline: dto.deadline?.toUtc(),
        createdAt: (dto.createdAt ?? DateTime.now()).toUtc(),
        assignedToEmployeeId: employeeId,
        assignedAt: (dto.createdAt ?? DateTime.now()).toUtc(),
        assignmentId: assignmentId,
        isCooperative: isCooperative,
        partnerName: partnerName,
        totalLines: totalLines,
        completedLinesCount: completedLines,
        lines: lines,
      );
    } catch (e, stack) {
      Logger.e('Ошибка маппинга задачи возврата (ID: ${dto.taskId})', e, stack);
      return null;
    }
  }

  @override
  TaskNavigationPayload buildNavigationPayload(TaskCardVm taskCard, int employeeId) {
    return TaskNavigationPayload(
      route: '/return-to-stock/active', 
      extra: {
        'assignmentId': taskCard.navigationId,
        'taskId': taskCard.rawTask?.taskId ?? 0,
        'taskStatusIndex': taskCard.rawTask?.status.index,
        'assignmentStatusIndex': taskCard.rawTask?.assignmentStatus.index,
      },
    );
  }

  // --- Безопасные хелперы для парсинга JSON ---
  // ASP.NET иногда может отдавать ключи в PascalCase, эти методы защищают от сбоев
  
  int? _getInt(Map<String, dynamic> map, String key) {
    final val = map[key] ?? map[_capitalize(key)];
    if (val is int) return val;
    if (val is String) return int.tryParse(val);
    return null;
  }

  bool _getBool(Map<String, dynamic> map, String key) {
    final val = map[key] ?? map[_capitalize(key)];
    if (val is bool) return val;
    if (val is String) return val.toLowerCase() == 'true';
    return false;
  }

  String? _getString(Map<String, dynamic> map, String key) {
    final val = map[key] ?? map[_capitalize(key)];
    return val?.toString();
  }

  List<dynamic> _getList(Map<String, dynamic> map, String key) {
    final val = map[key] ?? map[_capitalize(key)];
    if (val is List) return val;
    return [];
  }

  String _capitalize(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}

// --- Вспомогательные парсеры статусов ---

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