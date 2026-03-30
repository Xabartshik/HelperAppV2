// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_app_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileAppUserDtoImpl _$$MobileAppUserDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MobileAppUserDtoImpl(
  id: (json['id'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: json['role'] as String,
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
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
