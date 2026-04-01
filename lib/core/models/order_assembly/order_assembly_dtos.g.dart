// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_assembly_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssemblyItemDtoImpl _$$AssemblyItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AssemblyItemDtoImpl(
  lineId: json['lineId'] as String,
  itemId: (json['itemId'] as num).toInt(),
  itemName: json['itemName'] as String? ?? '',
  barcode: json['barcode'] as String? ?? '',
  quantity: (json['quantity'] as num).toInt(),
  collectedQuantity: (json['collectedQuantity'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$AssemblyStatusEnumMap, json['status']) ??
      AssemblyStatus.pending,
);

Map<String, dynamic> _$$AssemblyItemDtoImplToJson(
  _$AssemblyItemDtoImpl instance,
) => <String, dynamic>{
  'lineId': instance.lineId,
  'itemId': instance.itemId,
  'itemName': instance.itemName,
  'barcode': instance.barcode,
  'quantity': instance.quantity,
  'collectedQuantity': instance.collectedQuantity,
  'status': _$AssemblyStatusEnumMap[instance.status]!,
};

const _$AssemblyStatusEnumMap = {
  AssemblyStatus.pending: 'Pending',
  AssemblyStatus.picked: 'Picked',
  AssemblyStatus.placed: 'Placed',
  AssemblyStatus.missing: 'Missing',
};

_$CellPlacementImpl _$$CellPlacementImplFromJson(Map<String, dynamic> json) =>
    _$CellPlacementImpl(
      assignmentId: json['assignmentId'] as String,
      cellCode: json['cellCode'] as String,
      cellDisplayName: json['cellDisplayName'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => AssemblyItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CellPlacementImplToJson(_$CellPlacementImpl instance) =>
    <String, dynamic>{
      'assignmentId': instance.assignmentId,
      'cellCode': instance.cellCode,
      'cellDisplayName': instance.cellDisplayName,
      'items': instance.items,
    };

_$WorkerAssemblyTaskDtoImpl _$$WorkerAssemblyTaskDtoImplFromJson(
  Map<String, dynamic> json,
) => _$WorkerAssemblyTaskDtoImpl(
  assignmentId: json['assignmentId'] as String,
  taskNumber: json['taskNumber'] as String? ?? '',
  createdDate: json['createdDate'] as String?,
  cellPlacements:
      (json['cellPlacements'] as List<dynamic>?)
          ?.map((e) => CellPlacement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WorkerAssemblyTaskDtoImplToJson(
  _$WorkerAssemblyTaskDtoImpl instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'taskNumber': instance.taskNumber,
  'createdDate': instance.createdDate,
  'cellPlacements': instance.cellPlacements,
};

_$ScanPickRequestImpl _$$ScanPickRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ScanPickRequestImpl(
  lineId: json['lineId'] as String,
  barcode: json['barcode'] as String,
);

Map<String, dynamic> _$$ScanPickRequestImplToJson(
  _$ScanPickRequestImpl instance,
) => <String, dynamic>{'lineId': instance.lineId, 'barcode': instance.barcode};

_$ScanPlaceBulkRequestImpl _$$ScanPlaceBulkRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ScanPlaceBulkRequestImpl(
  assignmentId: json['assignmentId'] as String,
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
  lineId: json['lineId'] as String,
  reason: json['reason'] as String,
);

Map<String, dynamic> _$$ReportMissingRequestImplToJson(
  _$ReportMissingRequestImpl instance,
) => <String, dynamic>{'lineId': instance.lineId, 'reason': instance.reason};
