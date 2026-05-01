// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'break_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakStatusDtoImpl _$$BreakStatusDtoImplFromJson(Map<String, dynamic> json) =>
    _$BreakStatusDtoImpl(
      isOnBreak: json['isOnBreak'] as bool? ?? false,
      accumulatedMinutes: (json['accumulatedMinutes'] as num?)?.toInt() ?? 0,
      canStartBreak: json['canStartBreak'] as bool? ?? false,
      isLimitReached: json['isLimitReached'] as bool? ?? false,
      hasActiveTasks: json['hasActiveTasks'] as bool? ?? false,
    );

Map<String, dynamic> _$$BreakStatusDtoImplToJson(
  _$BreakStatusDtoImpl instance,
) => <String, dynamic>{
  'isOnBreak': instance.isOnBreak,
  'accumulatedMinutes': instance.accumulatedMinutes,
  'canStartBreak': instance.canStartBreak,
  'isLimitReached': instance.isLimitReached,
  'hasActiveTasks': instance.hasActiveTasks,
};
