// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_io_employee_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckIOEmployeeDtoImpl _$$CheckIOEmployeeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CheckIOEmployeeDtoImpl(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  branchId: (json['branchId'] as num).toInt(),
  checkType: json['checkType'] as String,
  checkTimeStamp: DateTime.parse(json['checkTimeStamp'] as String),
);

Map<String, dynamic> _$$CheckIOEmployeeDtoImplToJson(
  _$CheckIOEmployeeDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'branchId': instance.branchId,
  'checkType': instance.checkType,
  'checkTimeStamp': instance.checkTimeStamp.toIso8601String(),
};
