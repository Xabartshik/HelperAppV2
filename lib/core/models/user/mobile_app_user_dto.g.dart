// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileAppUserDtoImpl _$$MobileAppUserDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MobileAppUserDtoImpl(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num?)?.toInt(),
  customerId: (json['customerId'] as num?)?.toInt(),
  branchId: (json['branchId'] as num?)?.toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: $enumDecode(
    _$MobileUserRoleEnumMap,
    json['role'],
    unknownValue: MobileUserRole.unknown,
  ),
  workerRole: $enumDecodeNullable(
    _$WorkerRoleEnumMap,
    json['workerRole'],
    unknownValue: WorkerRole.unknown,
  ),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$MobileAppUserDtoImplToJson(
  _$MobileAppUserDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'employeeId': instance.employeeId,
  'customerId': instance.customerId,
  'branchId': instance.branchId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': _$MobileUserRoleEnumMap[instance.role]!,
  'workerRole': _$WorkerRoleEnumMap[instance.workerRole],
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$MobileUserRoleEnumMap = {
  MobileUserRole.worker: 1,
  MobileUserRole.supervisor: 2,
  MobileUserRole.admin: 3,
  MobileUserRole.customer: 4,
  MobileUserRole.courier: 5,
  MobileUserRole.unknown: 0,
};

const _$WorkerRoleEnumMap = {
  WorkerRole.storekeeper: 1,
  WorkerRole.orderIssuer: 2,
  WorkerRole.manager: 3,
  WorkerRole.courier: 4,
  WorkerRole.unknown: 0,
};
