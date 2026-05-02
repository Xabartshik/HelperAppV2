// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComplaintDtoImpl _$$ComplaintDtoImplFromJson(Map<String, dynamic> json) =>
    _$ComplaintDtoImpl(
      orderId: (json['orderId'] as num).toInt(),
      reason: json['reason'] as String,
      comment: json['comment'] as String?,
      problemItemIds:
          (json['problemItemIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      photoPaths:
          (json['photoPaths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ComplaintDtoImplToJson(_$ComplaintDtoImpl instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'reason': instance.reason,
      'comment': instance.comment,
      'problemItemIds': instance.problemItemIds,
      'photoPaths': instance.photoPaths,
    };
