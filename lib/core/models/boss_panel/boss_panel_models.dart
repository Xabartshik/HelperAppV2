import 'package:freezed_annotation/freezed_annotation.dart';

part 'boss_panel_models.freezed.dart';
part 'boss_panel_models.g.dart';

@freezed
class BossPanelTaskCardDto with _$BossPanelTaskCardDto {
  const factory BossPanelTaskCardDto({
    required int id,
    @Default('') String title,
    @Default('') String taskType,
    required DateTime createdAt,
    DateTime? expectedCompletionDate,
    @Default(0) int overallProgressPercentage,
    @Default([]) List<TaskAssigneeProgressDto> assignees,
  }) = _BossPanelTaskCardDto;

  const BossPanelTaskCardDto._();
  double get progressValue => overallProgressPercentage / 100.0;

  factory BossPanelTaskCardDto.fromJson(Map<String, dynamic> json) => _$BossPanelTaskCardDtoFromJson(json);
}

@freezed
class TaskAssigneeProgressDto with _$TaskAssigneeProgressDto {
  const factory TaskAssigneeProgressDto({
    required int employeeId,
    @Default('') String fullName,
    @Default(0) int assignedVolume,
    @Default(0) int completedVolume,
    @Default('') String status,
  }) = _TaskAssigneeProgressDto;

  factory TaskAssigneeProgressDto.fromJson(Map<String, dynamic> json) => _$TaskAssigneeProgressDtoFromJson(json);
}

@freezed
class EmployeeWorkloadDto with _$EmployeeWorkloadDto {
  const factory EmployeeWorkloadDto({
    required int employeeId,
    @Default('') String fullName,
    @Default(false) bool isAtWork,
    @Default(0) int activeTasksCount,
    @Default([]) List<ActiveTaskBriefDto> activeTasks,
  }) = _EmployeeWorkloadDto;

  const EmployeeWorkloadDto._();
  bool get hasActiveTasks => activeTasksCount > 0;

  factory EmployeeWorkloadDto.fromJson(Map<String, dynamic> json) => _$EmployeeWorkloadDtoFromJson(json);
}

@freezed
class ActiveTaskBriefDto with _$ActiveTaskBriefDto {
  const factory ActiveTaskBriefDto({
    required int taskId,
    @Default('') String title,
    @Default('') String taskType,
    @Default('') String status,
  }) = _ActiveTaskBriefDto;

  factory ActiveTaskBriefDto.fromJson(Map<String, dynamic> json) => _$ActiveTaskBriefDtoFromJson(json);
}

@freezed
class AvailableEmployeeDto with _$AvailableEmployeeDto {
  const factory AvailableEmployeeDto({
    required int employeeId,
    @Default('') String fullName,
    @Default(false) bool isAtWork,
    @Default(0) int activeTasksCount,
    @Default(false) bool isRecommended,
  }) = _AvailableEmployeeDto;

  factory AvailableEmployeeDto.fromJson(Map<String, dynamic> json) => _$AvailableEmployeeDtoFromJson(json);
}

@freezed
class CreateInventoryByZoneDto with _$CreateInventoryByZoneDto {
  const factory CreateInventoryByZoneDto({
    @Default([]) List<String> zonePrefixes,
    @Default(3) int priority,
    @Default(1) int workerCount,
    List<int>? workerIds,
    String? description,
    DateTime? deadlineDate,
  }) = _CreateInventoryByZoneDto;

  factory CreateInventoryByZoneDto.fromJson(Map<String, dynamic> json) => _$CreateInventoryByZoneDtoFromJson(json);
}

@freezed
class PositionCellDto with _$PositionCellDto {
  const factory PositionCellDto({
    required int positionId,
    required int branchId,
    @Default("Active") String status,
    @Default('') String zoneCode,
    @Default('') String firstLevelStorageType,
    @Default('') String flsNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
  }) = _PositionCellDto;

  factory PositionCellDto.fromJson(Map<String, dynamic> json) => _$PositionCellDtoFromJson(json);
}
