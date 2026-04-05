enum TaskType {
  inventory,
  orderAssembly,
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
  onHold,
  blocked
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
  int priority;
  DateTime createdAt;
  DateTime? completedAt;
  int assignedToEmployeeId;
  DateTime assignedAt;

  TaskItemBase({
    required this.taskId,
    required this.type,
    required this.branchId,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.completedAt,
    required this.assignedToEmployeeId,
    required this.assignedAt,
  });
}

class InventoryLineItem {
  final int lineId;
  final int itemPositionId;
  final int expectedQuantity;
  int? actualQuantity;
  final PositionCodeInfo? positionCode;

  InventoryLineItem({
    required this.lineId,
    required this.itemPositionId,
    required this.expectedQuantity,
    this.actualQuantity,
    this.positionCode,
  });
}

class InventoryTaskItem extends TaskItemBase {
  final int assignmentId;
  final List<InventoryLineItem> lines;

  InventoryTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    required this.lines,
  });
}

/// Информация об одной строке сборки (товар → ячейка PICKUP)
class PlacementLineInfo {
  final int lineId;
  final int itemPositionId;
  final int quantity;
  final String status;

  PlacementLineInfo({
    required this.lineId,
    required this.itemPositionId,
    required this.quantity,
    required this.status,
  });
}

/// Группа товаров, которые нужно разместить в одну ячейку PICKUP
class CellPlacementInfo {
  final int targetPositionId;
  final List<PlacementLineInfo> items;

  CellPlacementInfo({
    required this.targetPositionId,
    required this.items,
  });
}

/// Задача сборки заказа — отображается рядом с задачами инвентаризации
class OrderAssemblyTaskItem extends TaskItemBase {
  final int assignmentId;
  final int orderId;
  final int totalLines;
  final List<CellPlacementInfo> cellPlacements;

  OrderAssemblyTaskItem({
    required super.taskId,
    required super.type,
    required super.branchId,
    required super.title,
    super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    super.completedAt,
    required super.assignedToEmployeeId,
    required super.assignedAt,
    required this.assignmentId,
    required this.orderId,
    required this.totalLines,
    required this.cellPlacements,
  });
}
