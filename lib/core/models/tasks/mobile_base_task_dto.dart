import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_base_task_dto.freezed.dart';
part 'mobile_base_task_dto.g.dart';

@freezed
class MobileBaseTaskDto with _$MobileBaseTaskDto {
  const factory MobileBaseTaskDto({
    @Default(0) int taskId,
    @Default(0) int branchId,
    @Default('') String taskType,
    @Default(0) int status,
    @Default(0) int assignmentStatus,
    DateTime? deadline,
    @Default('Без названия') String title,
    String? description,
    @JsonKey(name: 'priorityLevel') @Default(1) int priority,
    DateTime? createdAt,
    @Default(<String, dynamic>{}) Map<String, dynamic> taskDetails,
  }) = _MobileBaseTaskDto;

  factory MobileBaseTaskDto.fromJson(Map<String, dynamic> json) =>
      _$MobileBaseTaskDtoFromJson(json);
}
