// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_assembly_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanPickRequestImpl _$$ScanPickRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ScanPickRequestImpl(
  lineId: (json['lineId'] as num).toInt(),
  barcode: json['barcode'] as String,
);

Map<String, dynamic> _$$ScanPickRequestImplToJson(
  _$ScanPickRequestImpl instance,
) => <String, dynamic>{'lineId': instance.lineId, 'barcode': instance.barcode};

_$ScanPlaceBulkRequestImpl _$$ScanPlaceBulkRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ScanPlaceBulkRequestImpl(
  assignmentId: (json['assignmentId'] as num).toInt(),
  cellCode: json['cellCode'] as String,
);

Map<String, dynamic> _$$ScanPlaceBulkRequestImplToJson(
  _$ScanPlaceBulkRequestImpl instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'cellCode': instance.cellCode,
};

_$ReportMissingRequestImpl _$$ReportMissingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ReportMissingRequestImpl(
  lineId: (json['lineId'] as num).toInt(),
  reason: json['reason'] as String,
);

Map<String, dynamic> _$$ReportMissingRequestImplToJson(
  _$ReportMissingRequestImpl instance,
) => <String, dynamic>{'lineId': instance.lineId, 'reason': instance.reason};

_$PlacementLineDtoImpl _$$PlacementLineDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PlacementLineDtoImpl(
  lineId: (json['lineId'] as num).toInt(),
  itemPositionId: (json['itemPositionId'] as num).toInt(),
  itemId: (json['itemId'] as num).toInt(),
  itemName: json['itemName'] as String?,
  barcode: json['barcode'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  pickedQuantity: (json['pickedQuantity'] as num).toInt(),
  status: $enumDecode(_$OrderAssemblyLineStatusEnumMap, json['status']),
);

Map<String, dynamic> _$$PlacementLineDtoImplToJson(
  _$PlacementLineDtoImpl instance,
) => <String, dynamic>{
  'lineId': instance.lineId,
  'itemPositionId': instance.itemPositionId,
  'itemId': instance.itemId,
  'itemName': instance.itemName,
  'barcode': instance.barcode,
  'quantity': instance.quantity,
  'pickedQuantity': instance.pickedQuantity,
  'status': _$OrderAssemblyLineStatusEnumMap[instance.status]!,
};

const _$OrderAssemblyLineStatusEnumMap = {
  OrderAssemblyLineStatus.pending: 0,
  OrderAssemblyLineStatus.picked: 1,
  OrderAssemblyLineStatus.placed: 2,
  OrderAssemblyLineStatus.discrepancy: 3,
};

_$CellPlacementInfoDtoImpl _$$CellPlacementInfoDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CellPlacementInfoDtoImpl(
  targetPositionId: (json['targetPositionId'] as num).toInt(),
  cellCode: json['cellCode'] as String?,
  cellDisplayName: json['cellDisplayName'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PlacementLineDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CellPlacementInfoDtoImplToJson(
  _$CellPlacementInfoDtoImpl instance,
) => <String, dynamic>{
  'targetPositionId': instance.targetPositionId,
  'cellCode': instance.cellCode,
  'cellDisplayName': instance.cellDisplayName,
  'items': instance.items,
};

_$WorkerAssemblyTaskDtoImpl _$$WorkerAssemblyTaskDtoImplFromJson(
  Map<String, dynamic> json,
) => _$WorkerAssemblyTaskDtoImpl(
  assignmentId: (json['assignmentId'] as num).toInt(),
  taskId: (json['taskId'] as num).toInt(),
  taskNumber: json['taskNumber'] as String?,
  orderId: (json['orderId'] as num).toInt(),
  status: $enumDecode(_$OrderAssemblyAssignmentStatusEnumMap, json['status']),
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
  totalLines: (json['totalLines'] as num).toInt(),
  cellPlacements:
      (json['cellPlacements'] as List<dynamic>?)
          ?.map((e) => CellPlacementInfoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WorkerAssemblyTaskDtoImplToJson(
  _$WorkerAssemblyTaskDtoImpl instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'taskId': instance.taskId,
  'taskNumber': instance.taskNumber,
  'orderId': instance.orderId,
  'status': _$OrderAssemblyAssignmentStatusEnumMap[instance.status]!,
  'createdDate': instance.createdDate?.toIso8601String(),
  'totalLines': instance.totalLines,
  'cellPlacements': instance.cellPlacements,
};

const _$OrderAssemblyAssignmentStatusEnumMap = {
  OrderAssemblyAssignmentStatus.pending: 0,
  OrderAssemblyAssignmentStatus.inProgress: 1,
  OrderAssemblyAssignmentStatus.completed: 2,
  OrderAssemblyAssignmentStatus.cancelled: 3,
};
