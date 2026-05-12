// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeDtoImpl _$$EmployeeDtoImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeDtoImpl(
      employeesId: (json['employeesId'] as num?)?.toInt() ?? 0,
      surname: json['surname'] as String,
      name: json['name'] as String,
      middleName: json['middleName'] as String?,
      role:
          $enumDecodeNullable(_$WorkerRoleEnumMap, json['role']) ??
          WorkerRole.warehouseWorker,
    );

Map<String, dynamic> _$$EmployeeDtoImplToJson(_$EmployeeDtoImpl instance) =>
    <String, dynamic>{
      'employeesId': instance.employeesId,
      'surname': instance.surname,
      'name': instance.name,
      'middleName': instance.middleName,
      'role': _$WorkerRoleEnumMap[instance.role]!,
    };

const _$WorkerRoleEnumMap = {
  WorkerRole.warehouseWorker: 0,
  WorkerRole.courier: 1,
  WorkerRole.supervisor: 2,
  WorkerRole.admin: 3,
  WorkerRole.unknown: 100,
};
