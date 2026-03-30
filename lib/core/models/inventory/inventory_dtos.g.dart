// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositionCodeDtoImpl _$$PositionCodeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PositionCodeDtoImpl(
  branchId: (json['branchId'] as num).toInt(),
  zoneCode: json['zoneCode'] as String? ?? '',
  firstLevelStorageType: json['firstLevelStorageType'] as String? ?? '',
  fLSNumber: json['fLSNumber'] as String? ?? '',
  secondLevelStorage: json['secondLevelStorage'] as String?,
  thirdLevelStorage: json['thirdLevelStorage'] as String?,
);

Map<String, dynamic> _$$PositionCodeDtoImplToJson(
  _$PositionCodeDtoImpl instance,
) => <String, dynamic>{
  'branchId': instance.branchId,
  'zoneCode': instance.zoneCode,
  'firstLevelStorageType': instance.firstLevelStorageType,
  'fLSNumber': instance.fLSNumber,
  'secondLevelStorage': instance.secondLevelStorage,
  'thirdLevelStorage': instance.thirdLevelStorage,
};

_$InventoryAssignmentLineWithItemDtoImpl
_$$InventoryAssignmentLineWithItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$InventoryAssignmentLineWithItemDtoImpl(
      id: (json['id'] as num).toInt(),
      itemPositionId: (json['itemPositionId'] as num).toInt(),
      positionId: (json['positionId'] as num).toInt(),
      expectedQuantity: (json['expectedQuantity'] as num).toInt(),
      actualQuantity: (json['actualQuantity'] as num?)?.toInt(),
      itemId: (json['itemId'] as num).toInt(),
      itemName: json['itemName'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      positionCode: PositionCodeDto.fromJson(
        json['positionCode'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$InventoryAssignmentLineWithItemDtoImplToJson(
  _$InventoryAssignmentLineWithItemDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'itemPositionId': instance.itemPositionId,
  'positionId': instance.positionId,
  'expectedQuantity': instance.expectedQuantity,
  'actualQuantity': instance.actualQuantity,
  'itemId': instance.itemId,
  'itemName': instance.itemName,
  'displayName': instance.displayName,
  'positionCode': instance.positionCode,
};

_$InventoryAssignmentDetailedWithItemDtoImpl
_$$InventoryAssignmentDetailedWithItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryAssignmentDetailedWithItemDtoImpl(
  id: (json['id'] as num).toInt(),
  taskNumber: json['taskNumber'] as String? ?? '',
  description: json['description'] as String? ?? '',
  createdDate: json['createdDate'] as String?,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) => InventoryAssignmentLineWithItemDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$InventoryAssignmentDetailedWithItemDtoImplToJson(
  _$InventoryAssignmentDetailedWithItemDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'taskNumber': instance.taskNumber,
  'description': instance.description,
  'createdDate': instance.createdDate,
  'lines': instance.lines,
};

_$TaskCheckResponseImpl _$$TaskCheckResponseImplFromJson(
  Map<String, dynamic> json,
) => _$TaskCheckResponseImpl(
  hasNewTasks: json['hasNewTasks'] as bool,
  newTaskCount: (json['newTaskCount'] as num).toInt(),
  latestTaskTime: json['latestTaskTime'] == null
      ? null
      : DateTime.parse(json['latestTaskTime'] as String),
  lastChecked: DateTime.parse(json['lastChecked'] as String),
);

Map<String, dynamic> _$$TaskCheckResponseImplToJson(
  _$TaskCheckResponseImpl instance,
) => <String, dynamic>{
  'hasNewTasks': instance.hasNewTasks,
  'newTaskCount': instance.newTaskCount,
  'latestTaskTime': instance.latestTaskTime?.toIso8601String(),
  'lastChecked': instance.lastChecked.toIso8601String(),
};

_$InventoryItemDtoImpl _$$InventoryItemDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryItemDtoImpl(
  itemId: (json['itemId'] as num).toInt(),
  lineId: (json['lineId'] as num?)?.toInt(),
  itemName: json['itemName'] as String? ?? '',
  positionCode: json['positionCode'] as String? ?? '',
  positionId: (json['positionId'] as num).toInt(),
  expectedQuantity: (json['expectedQuantity'] as num).toInt(),
  weight: (json['weight'] as num?)?.toDouble() ?? 0,
  length: (json['length'] as num?)?.toDouble() ?? 0,
  width: (json['width'] as num?)?.toDouble() ?? 0,
  height: (json['height'] as num?)?.toDouble() ?? 0,
  status: json['status'] as String? ?? 'Available',
);

Map<String, dynamic> _$$InventoryItemDtoImplToJson(
  _$InventoryItemDtoImpl instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'lineId': instance.lineId,
  'itemName': instance.itemName,
  'positionCode': instance.positionCode,
  'positionId': instance.positionId,
  'expectedQuantity': instance.expectedQuantity,
  'weight': instance.weight,
  'length': instance.length,
  'width': instance.width,
  'height': instance.height,
  'status': instance.status,
};

_$InventoryTaskDetailsDtoImpl _$$InventoryTaskDetailsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryTaskDetailsDtoImpl(
  taskId: (json['taskId'] as num).toInt(),
  zoneCode: json['zoneCode'] as String? ?? '',
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => InventoryItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalExpectedCount: (json['totalExpectedCount'] as num).toInt(),
  initiatedAt: DateTime.parse(json['initiatedAt'] as String),
);

Map<String, dynamic> _$$InventoryTaskDetailsDtoImplToJson(
  _$InventoryTaskDetailsDtoImpl instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'zoneCode': instance.zoneCode,
  'items': instance.items,
  'totalExpectedCount': instance.totalExpectedCount,
  'initiatedAt': instance.initiatedAt.toIso8601String(),
};

_$CompleteAssignmentLineDtoImpl _$$CompleteAssignmentLineDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CompleteAssignmentLineDtoImpl(
  lineId: (json['lineId'] as num?)?.toInt(),
  itemId: (json['itemId'] as num).toInt(),
  positionCode: json['positionCode'] as String? ?? '',
  actualQuantity: (json['actualQuantity'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CompleteAssignmentLineDtoImplToJson(
  _$CompleteAssignmentLineDtoImpl instance,
) => <String, dynamic>{
  'lineId': instance.lineId,
  'itemId': instance.itemId,
  'positionCode': instance.positionCode,
  'actualQuantity': instance.actualQuantity,
};

_$CompleteAssignmentDtoImpl _$$CompleteAssignmentDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CompleteAssignmentDtoImpl(
  assignmentId: (json['assignmentId'] as num).toInt(),
  workerId: (json['workerId'] as num).toInt(),
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map(
            (e) =>
                CompleteAssignmentLineDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$CompleteAssignmentDtoImplToJson(
  _$CompleteAssignmentDtoImpl instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'workerId': instance.workerId,
  'lines': instance.lines,
};

_$InventoryStatisticsDtoImpl _$$InventoryStatisticsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$InventoryStatisticsDtoImpl(
  id: (json['id'] as num?)?.toInt() ?? 0,
  inventoryAssignmentId: (json['inventoryAssignmentId'] as num?)?.toInt() ?? 0,
  totalPositions: (json['totalPositions'] as num?)?.toInt() ?? 0,
  countedPositions: (json['countedPositions'] as num?)?.toInt() ?? 0,
  completionPercentage:
      (json['completionPercentage'] as num?)?.toDouble() ?? 0.0,
  discrepancyCount: (json['discrepancyCount'] as num?)?.toInt() ?? 0,
  surplusCount: (json['surplusCount'] as num?)?.toInt() ?? 0,
  shortageCount: (json['shortageCount'] as num?)?.toInt() ?? 0,
  totalSurplusQuantity: (json['totalSurplusQuantity'] as num?)?.toInt() ?? 0,
  totalShortageQuantity: (json['totalShortageQuantity'] as num?)?.toInt() ?? 0,
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$InventoryStatisticsDtoImplToJson(
  _$InventoryStatisticsDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'inventoryAssignmentId': instance.inventoryAssignmentId,
  'totalPositions': instance.totalPositions,
  'countedPositions': instance.countedPositions,
  'completionPercentage': instance.completionPercentage,
  'discrepancyCount': instance.discrepancyCount,
  'surplusCount': instance.surplusCount,
  'shortageCount': instance.shortageCount,
  'totalSurplusQuantity': instance.totalSurplusQuantity,
  'totalShortageQuantity': instance.totalShortageQuantity,
  'startedAt': instance.startedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
};

_$CompleteAssignmentResultDtoImpl _$$CompleteAssignmentResultDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CompleteAssignmentResultDtoImpl(
  assignmentId: (json['assignmentId'] as num?)?.toInt() ?? 0,
  message: json['message'] as String? ?? '',
  statistics: json['statistics'] == null
      ? null
      : InventoryStatisticsDto.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$$CompleteAssignmentResultDtoImplToJson(
  _$CompleteAssignmentResultDtoImpl instance,
) => <String, dynamic>{
  'assignmentId': instance.assignmentId,
  'message': instance.message,
  'statistics': instance.statistics,
  'completedAt': instance.completedAt?.toIso8601String(),
};

_$ItemInfoDtoImpl _$$ItemInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$ItemInfoDtoImpl(
      itemId: (json['itemId'] as num).toInt(),
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$ItemInfoDtoImplToJson(_$ItemInfoDtoImpl instance) =>
    <String, dynamic>{'itemId': instance.itemId, 'name': instance.name};
