import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:helper_app/core/models/order_handover/order_handover_dtos.dart';
import 'package:helper_app/core/models/return_to_stock/return_to_stock_dtos.dart';


enum TaskType {
  inventory,
  orderAssembly,
  orderHandover,
  returnToStock,
  receipt,
  movement,
  shipping,
  packing,
  audit,
  labeling,
  loading
}

enum TaskStatus {
  newStatus,
  assigned,
  inProgress,
  completed,
  cancelled,
  paused,
  blocked
}

enum AssignmentStatus{
    @JsonValue(0) assigned,
    @JsonValue(1) inProgress,
    @JsonValue(2) paused,
    @JsonValue(3) completed,
    @JsonValue(4) cancelled
}

class PositionCodeInfo {
  final int branchId;
  final String zoneCode;
  final String firstLevelStorageType;
  final String flsNumber;
  final String? secondLevelStorage;
  final String? thirdLevelStorage;

  PositionCodeInfo({
    required this.branchId,
    required this.zoneCode,
    required this.firstLevelStorageType,
    required this.flsNumber,
    this.secondLevelStorage,
    this.thirdLevelStorage,
  });

  String get fullDescription {
    var result = '$branchId-$zoneCode-$firstLevelStorageType-$flsNumber';
    if (secondLevelStorage != null && secondLevelStorage!.isNotEmpty) {
      result += '-$secondLevelStorage';
    }
    if (thirdLevelStorage != null && thirdLevelStorage!.isNotEmpty) {
      result += '-$thirdLevelStorage';
    }
    return result;
  }

  String get shortDescription => '$zoneCode-$firstLevelStorageType-$flsNumber';
}

abstract class TaskItemBase {
  int taskId;
  TaskType type;
  int branchId;
  String title;
  String? description;
  TaskStatus status;
  AssignmentStatus assignmentStatus;
  int priority;      // Уровень приоритета (уже был, убедимся в использовании)
  DateTime createdAt;
  DateTime? deadline;
  DateTime? completedAt;
  int assignedToEmployeeId;
  DateTime assignedAt;
  MobileTaskDetailsBase? details;

  TaskItemBase({
    required this.taskId,
    required this.type,
    required this.branchId,
    required this.title,
    this.description,
    required this.status,
    required this.assignmentStatus,
    required this.priority,
    this.deadline,
    required this.createdAt,
    this.completedAt,
    required this.assignedToEmployeeId,
    required this.assignedAt,
    this.details,
  });
}

abstract class MobileTaskDetailsBase {
  final int schemaVersion;
  const MobileTaskDetailsBase({required this.schemaVersion});
}

class OrderAssemblyDetails extends MobileTaskDetailsBase {
  final int assignmentId;
  final int orderId;
  final int totalLines;
  final int completedLines;
  final List<CellPlacementInfo> lines;

  const OrderAssemblyDetails({
    required super.schemaVersion,
    required this.assignmentId,
    required this.orderId,
    required this.totalLines,
    required this.completedLines,
    required this.lines,
  });
}

class InventoryDetails extends MobileTaskDetailsBase {
  final int assignmentId;
  final int totalLines;
  final int completedLines;
  final List<InventoryLineItem> lines;

  const InventoryDetails({
    required super.schemaVersion,
    required this.assignmentId,
    required this.totalLines,
    required this.completedLines,
    required this.lines,
  });
}

class InventoryLineItem {
  final int lineId;
  final int itemPositionId;
  final int expectedQuantity;
  int? actualQuantity;
  final PositionCodeInfo? positionCode;
  final int? itemId;
  final String? itemName;

  InventoryLineItem({
    required this.lineId,
    required this.itemPositionId,
    required this.expectedQuantity,
    this.actualQuantity,
    this.positionCode,
    this.itemId,
    this.itemName,
  });
}

/// Информация об одной строке сборки (товар → ячейка PICKUP)
class PlacementLineInfo {
  final int lineId;
  final int itemPositionId;
  final int quantity;
  final String status;
  final int? itemId;
  final String? itemName;
  final String? barcode;
  final String? sourceCellCode;
  final int? pickedQuantity;

  PlacementLineInfo({
    required this.lineId,
    required this.itemPositionId,
    required this.quantity,
    required this.status,
    this.itemId,
    this.itemName,
    this.barcode,
    this.sourceCellCode,
    this.pickedQuantity,
  });
}

/// Группа товаров, которые нужно разместить в одну ячейку PICKUP
class CellPlacementInfo {
  final int targetPositionId;
  final List<PlacementLineInfo> items;
  final String? cellCode;
  final String? cellDisplayName;

  CellPlacementInfo({
    required this.targetPositionId,
    required this.items,
    this.cellCode,
    this.cellDisplayName,
  });
}

/// Задача сборки заказа — отображается рядом с задачами инвентаризации
class InventoryTaskItem extends TaskItemBase {
  final int assignmentId;
  final List<InventoryLineItem> lines;
  final int totalLinesCount;      
  final int completedLinesCount;

  InventoryTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.assignmentStatus,
    required super.priority,
    super.deadline,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    required this.lines,
    this.totalLinesCount = 0,
    this.completedLinesCount = 0,
    super.details,
  });
}

/// Задача сборки заказа — отображается рядом с задачами инвентаризации
class OrderAssemblyTaskItem extends TaskItemBase {
  final int assignmentId;
  final int orderId;
  final int totalLines;
  final int completedLinesCount;
  final List<CellPlacementInfo> cellPlacements;

  OrderAssemblyTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.assignmentStatus,
    required super.priority,
    super.deadline,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    required this.orderId,
    required this.totalLines,
    this.completedLinesCount = 0,
    required this.cellPlacements,
    super.details,
  });

  
}

class OrderHandoverDetails extends MobileTaskDetailsBase {
  final int assignmentId;
  final int orderId;
  final String handoverType;
  final int totalLines;
  final int completedLines;

  const OrderHandoverDetails({
    required super.schemaVersion,
    required this.assignmentId,
    required this.orderId,
    required this.handoverType,
    required this.totalLines,
    required this.completedLines,
  });
}

class OrderHandoverTaskItem extends TaskItemBase {
  final int assignmentId;
  final int orderId;
  final String handoverType;
  final int totalLines;
  final int completedLinesCount;
  final List<HandoverItemDto> lines;

  OrderHandoverTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.assignmentStatus,
    required super.priority,
    super.deadline,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    required this.orderId,
    required this.handoverType,
    required this.totalLines,
    this.completedLinesCount = 0,
    this.lines = const [],
    super.details,
  });
}

class ReturnToStockTaskItem extends TaskItemBase {
  final int assignmentId;
  final bool isCooperative;
  final String? partnerName;
  final int totalLines;
  final int completedLinesCount;
  final List<ReturnItemDto> lines;

  ReturnToStockTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.assignmentStatus,
    required super.priority,
    super.deadline,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    this.isCooperative = false,
    this.partnerName,
    required this.totalLines,
    this.completedLinesCount = 0,
    this.lines = const [],
    super.details,
  });
}
