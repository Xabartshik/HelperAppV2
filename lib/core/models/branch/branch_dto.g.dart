// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BranchDtoImpl _$$BranchDtoImplFromJson(Map<String, dynamic> json) =>
    _$BranchDtoImpl(
      branchId: (json['branchId'] as num?)?.toInt() ?? 0,
      branchName: json['branchName'] as String? ?? '',
      branchType: json['branchType'] as String? ?? '',
      address: json['address'] as String? ?? '',
    );

Map<String, dynamic> _$$BranchDtoImplToJson(_$BranchDtoImpl instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'branchType': instance.branchType,
      'address': instance.address,
    };
