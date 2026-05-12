// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_base_task_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MobileBaseTaskDtoImpl _$$MobileBaseTaskDtoImplFromJson(
  Map<String, dynamic> json,
) => _$MobileBaseTaskDtoImpl(
  taskId: (json['taskId'] as num?)?.toInt() ?? 0,
  branchId: (json['branchId'] as num?)?.toInt() ?? 0,
  taskType: json['taskType'] as String? ?? '',
  status: (json['status'] as num?)?.toInt() ?? 0,
  assignmentStatus: (json['assignmentStatus'] as num?)?.toInt() ?? 0,
  deadline: json['deadline'] == null
      ? null
      : DateTime.parse(json['deadline'] as String),
  title: json['title'] as String? ?? 'Без названия',
  description: json['description'] as String?,
  priority: (json['priorityLevel'] as num?)?.toInt() ?? 1,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  taskDetails:
      json['taskDetails'] as Map<String, dynamic>? ?? const <String, dynamic>{},
);

Map<String, dynamic> _$$MobileBaseTaskDtoImplToJson(
  _$MobileBaseTaskDtoImpl instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'branchId': instance.branchId,
  'taskType': instance.taskType,
  'status': instance.status,
  'assignmentStatus': instance.assignmentStatus,
  'deadline': instance.deadline?.toIso8601String(),
  'title': instance.title,
  'description': instance.description,
  'priorityLevel': instance.priority,
  'createdAt': instance.createdAt?.toIso8601String(),
  'taskDetails': instance.taskDetails,
};
