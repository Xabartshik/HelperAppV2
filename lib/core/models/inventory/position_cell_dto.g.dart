// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_cell_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositionCellDtoImpl _$$PositionCellDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PositionCellDtoImpl(
  positionId: (json['positionId'] as num?)?.toInt() ?? 0,
  branchId: (json['branchId'] as num).toInt(),
  status: json['status'] as String? ?? "Active",
  zoneCode: json['zoneCode'] as String,
  firstLevelStorageType: json['firstLevelStorageType'] as String,
  flsNumber: json['flsNumber'] as String,
  secondLevelStorage: json['secondLevelStorage'] as String?,
  thirdLevelStorage: json['thirdLevelStorage'] as String?,
  length: (json['length'] as num?)?.toDouble() ?? 0.0,
  width: (json['width'] as num?)?.toDouble() ?? 0.0,
  height: (json['height'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$PositionCellDtoImplToJson(
  _$PositionCellDtoImpl instance,
) => <String, dynamic>{
  'positionId': instance.positionId,
  'branchId': instance.branchId,
  'status': instance.status,
  'zoneCode': instance.zoneCode,
  'firstLevelStorageType': instance.firstLevelStorageType,
  'flsNumber': instance.flsNumber,
  'secondLevelStorage': instance.secondLevelStorage,
  'thirdLevelStorage': instance.thirdLevelStorage,
  'length': instance.length,
  'width': instance.width,
  'height': instance.height,
};
