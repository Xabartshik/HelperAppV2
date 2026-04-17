import 'package:json_annotation/json_annotation.dart';

// ---------------------------------------------------------------------------
// Статусы
// ---------------------------------------------------------------------------

enum OrderAssemblyAssignmentStatus {
  @JsonValue(0)
  assigned,
  @JsonValue(1)
  inProgress,
  @JsonValue(2)
  completed,
  @JsonValue(3)
  cancelled,
}

enum OrderAssemblyLineStatus {
  @JsonValue(0)
  pending,
  @JsonValue(1)
  picked,
  @JsonValue(2)
  placed,
  @JsonValue(3)
  discrepancy,
}

// ---------------------------------------------------------------------------
// DTOs
// ---------------------------------------------------------------------------

class PlacementLineDto {
  final int lineId;
  final int itemPositionId;
  final int itemId;
  final String itemName;
  final String barcode;
  final int quantity;
  final int pickedQuantity;
  final OrderAssemblyLineStatus status;

  PlacementLineDto({
    required this.lineId,
    required this.itemPositionId,
    required this.itemId,
    required this.itemName,
    required this.barcode,
    required this.quantity,
    required this.pickedQuantity,
    required this.status,
  });

  factory PlacementLineDto.fromJson(Map<String, dynamic> json) {
    final lineId = (json['lineId'] ?? json['LineId']) as int;
    final itemPositionId = (json['itemPositionId'] ?? json['ItemPositionId']) as int;
    final itemId = (json['itemId'] ?? json['ItemId']) as int? ?? 0;
    final itemName = (json['itemName'] ?? json['ItemName']) as String? ?? 'Неизвестный товар';
    final barcode = (json['barcode'] ?? json['Barcode']) as String? ?? '';
    final quantity = (json['quantity'] ?? json['Quantity']) as int;
    final pickedQuantity = (json['pickedQuantity'] ?? json['PickedQuantity']) as int? ?? 0;
    final status = $enumDecode(_$OrderAssemblyLineStatusEnumMap, json['status'] ?? json['Status']);

    return PlacementLineDto(
      lineId: lineId,
      itemPositionId: itemPositionId,
      itemId: itemId,
      itemName: itemName,
      barcode: barcode,
      quantity: quantity,
      pickedQuantity: pickedQuantity,
      status: status,
    );
  }

  Map<String, dynamic> toJson() => {
        'lineId': lineId,
        'itemPositionId': itemPositionId,
        'itemId': itemId,
        'itemName': itemName,
        'barcode': barcode,
        'quantity': quantity,
        'pickedQuantity': pickedQuantity,
        'status': _$OrderAssemblyLineStatusEnumMap[status],
      };
}

const _$OrderAssemblyLineStatusEnumMap = {
  OrderAssemblyLineStatus.pending: 0,
  OrderAssemblyLineStatus.picked: 1,
  OrderAssemblyLineStatus.placed: 2,
  OrderAssemblyLineStatus.discrepancy: 3,
};

class CellPlacementInfoDto {
  final int targetPositionId;
  final String? cellCode;
  final String? cellDisplayName;
  final List<PlacementLineDto> items;

  CellPlacementInfoDto({
    required this.targetPositionId,
    this.cellCode,
    this.cellDisplayName,
    required this.items,
  });

  factory CellPlacementInfoDto.fromJson(Map<String, dynamic> json) {
    final targetPositionId = (json['targetPositionId'] ?? json['TargetPositionId']) as int;
    final cellCode = (json['cellCode'] ?? json['CellCode']) as String?;
    final cellDisplayName = (json['cellDisplayName'] ?? json['CellDisplayName']) as String?;
    final itemsList = (json['items'] ?? json['Items']) as List<dynamic>;

    return CellPlacementInfoDto(
      targetPositionId: targetPositionId,
      cellCode: cellCode,
      cellDisplayName: cellDisplayName,
      items: itemsList.map((e) => PlacementLineDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'targetPositionId': targetPositionId,
        'cellCode': cellCode,
        'cellDisplayName': cellDisplayName,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class WorkerAssemblyTaskDto {
  final int assignmentId;
  final int taskId;
  final String? taskNumber;
  final int orderId;
  final OrderAssemblyAssignmentStatus status;
  final DateTime? createdDate;
  final int totalLines;
  final List<CellPlacementInfoDto> cellPlacements;

  WorkerAssemblyTaskDto({
    required this.assignmentId,
    required this.taskId,
    this.taskNumber,
    required this.orderId,
    required this.status,
    this.createdDate,
    required this.totalLines,
    required this.cellPlacements,
  });

  factory WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) {
    final assignmentId = (json['assignmentId'] ?? json['AssignmentId']) as int;
    final taskId = (json['taskId'] ?? json['TaskId']) as int;
    final taskNumber = (json['taskNumber'] ?? json['TaskNumber']) as String?;
    final orderId = (json['orderId'] ?? json['OrderId']) as int;
    final status = $enumDecode(_$OrderAssemblyAssignmentStatusEnumMap, json['status'] ?? json['Status']);
    
    final createdDateRaw = json['createdDate'] ?? json['CreatedDate'];
    final createdDate = createdDateRaw == null ? null : DateTime.parse(createdDateRaw as String);
    
    final totalLines = (json['totalLines'] ?? json['TotalLines']) as int;
    final cellPlacementsList = (json['cellPlacements'] ?? json['CellPlacements']) as List<dynamic>;

    return WorkerAssemblyTaskDto(
      assignmentId: assignmentId,
      taskId: taskId,
      taskNumber: taskNumber,
      orderId: orderId,
      status: status,
      createdDate: createdDate,
      totalLines: totalLines,
      cellPlacements: cellPlacementsList.map((e) => CellPlacementInfoDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'assignmentId': assignmentId,
        'taskId': taskId,
        'taskNumber': taskNumber,
        'orderId': orderId,
        'status': _$OrderAssemblyAssignmentStatusEnumMap[status],
        'createdDate': createdDate?.toIso8601String(),
        'totalLines': totalLines,
        'cellPlacements': cellPlacements.map((e) => e.toJson()).toList(),
      };
}

const _$OrderAssemblyAssignmentStatusEnumMap = {
  OrderAssemblyAssignmentStatus.assigned: 0,
  OrderAssemblyAssignmentStatus.inProgress: 1,
  OrderAssemblyAssignmentStatus.completed: 2,
  OrderAssemblyAssignmentStatus.cancelled: 3,
};

// ---------------------------------------------------------------------------
// Requests
// ---------------------------------------------------------------------------

class ScanPickRequest {
  final int lineId;
  final String barcode;

  ScanPickRequest({required this.lineId, required this.barcode});

  Map<String, dynamic> toJson() => {
        'lineId': lineId,
        'barcode': barcode,
      };
}

class ScanPlaceBulkRequest {
  final int assignmentId;
  final String cellCode;

  ScanPlaceBulkRequest({required this.assignmentId, required this.cellCode});

  Map<String, dynamic> toJson() => {
        'assignmentId': assignmentId,
        'cellCode': cellCode,
      };
}

class ReportMissingRequest {
  final int lineId;
  final String reason;

  ReportMissingRequest({required this.lineId, required this.reason});

  Map<String, dynamic> toJson() => {
        'lineId': lineId,
        'reason': reason,
      };
}

// Helper for enum decoding
T $enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) return enumValues.keys.first;
  
  for (final entry in enumValues.entries) {
    if (entry.value == source) {
      return entry.key;
    }
  }
  
  return enumValues.keys.first;
}
