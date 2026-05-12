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
          WorkerRole.storekeeper,
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
  WorkerRole.storekeeper: 1,
  WorkerRole.orderIssuer: 2,
  WorkerRole.manager: 3,
  WorkerRole.courier: 4,
  WorkerRole.unknown: 100,
};
