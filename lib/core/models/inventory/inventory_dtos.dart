import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_dtos.freezed.dart';
part 'inventory_dtos.g.dart';

@freezed
class PositionCodeDto with _$PositionCodeDto {
  const factory PositionCodeDto({
    required int branchId,
    @Default('') String zoneCode,
    @Default('') String firstLevelStorageType,
    @Default('') String fLSNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
  }) = _PositionCodeDto;

  factory PositionCodeDto.fromJson(Map<String, dynamic> json) => 
      _$PositionCodeDtoFromJson(json);
}

@freezed
class InventoryAssignmentLineWithItemDto with _$InventoryAssignmentLineWithItemDto {
  const factory InventoryAssignmentLineWithItemDto({
    required int id,
    required int itemPositionId,
    required int positionId,
    required int expectedQuantity,
    int? actualQuantity,
    required int itemId,
    @Default('') String itemName,
    @Default('') String displayName,
    required PositionCodeDto positionCode,
  }) = _InventoryAssignmentLineWithItemDto;

  factory InventoryAssignmentLineWithItemDto.fromJson(Map<String, dynamic> json) => 
      _$InventoryAssignmentLineWithItemDtoFromJson(json);
}

@freezed
class InventoryAssignmentDetailedWithItemDto with _$InventoryAssignmentDetailedWithItemDto {
  const factory InventoryAssignmentDetailedWithItemDto({
    required int id,
    @Default('') String taskNumber,
    @Default('') String description,
    String? createdDate,
    @Default([]) List<InventoryAssignmentLineWithItemDto> lines,
  }) = _InventoryAssignmentDetailedWithItemDto;

  factory InventoryAssignmentDetailedWithItemDto.fromJson(Map<String, dynamic> json) => 
      _$InventoryAssignmentDetailedWithItemDtoFromJson(json);
}

@freezed
class TaskCheckResponse with _$TaskCheckResponse {
  const factory TaskCheckResponse({
    required bool hasNewTasks,
    required int newTaskCount,
    DateTime? latestTaskTime,
    required DateTime lastChecked,
  }) = _TaskCheckResponse;

  factory TaskCheckResponse.fromJson(Map<String, dynamic> json) => 
      _$TaskCheckResponseFromJson(json);
}

@freezed
class InventoryItemDto with _$InventoryItemDto {
  const factory InventoryItemDto({
    required int itemId,
    int? lineId,
    @Default('') String itemName,
    @Default('') String positionCode,
    required int positionId,
    required int expectedQuantity,
    @Default(0) double weight,
    @Default(0) double length,
    @Default(0) double width,
    @Default(0) double height,
    @Default('Available') String status,
  }) = _InventoryItemDto;

  factory InventoryItemDto.fromJson(Map<String, dynamic> json) => 
      _$InventoryItemDtoFromJson(json);
}

@freezed
class InventoryTaskDetailsDto with _$InventoryTaskDetailsDto {
  const factory InventoryTaskDetailsDto({
    required int taskId,
    @Default('') String zoneCode,
    @Default([]) List<InventoryItemDto> items,
    required int totalExpectedCount,
    required DateTime initiatedAt,
  }) = _InventoryTaskDetailsDto;

  factory InventoryTaskDetailsDto.fromJson(Map<String, dynamic> json) => 
      _$InventoryTaskDetailsDtoFromJson(json);
}

@freezed
class CompleteAssignmentLineDto with _$CompleteAssignmentLineDto {
  const factory CompleteAssignmentLineDto({
    int? lineId,
    required int itemId,
    @Default('') String positionCode,
    int? actualQuantity,
  }) = _CompleteAssignmentLineDto;

  factory CompleteAssignmentLineDto.fromJson(Map<String, dynamic> json) => 
      _$CompleteAssignmentLineDtoFromJson(json);
}

@freezed
class CompleteAssignmentDto with _$CompleteAssignmentDto {
  const factory CompleteAssignmentDto({
    required int assignmentId,
    required int workerId,
    @Default([]) List<CompleteAssignmentLineDto> lines,
  }) = _CompleteAssignmentDto;

  factory CompleteAssignmentDto.fromJson(Map<String, dynamic> json) => 
      _$CompleteAssignmentDtoFromJson(json);
}

@freezed
class InventoryStatisticsDto with _$InventoryStatisticsDto {
  const factory InventoryStatisticsDto({
    @Default(0) int id,
    @Default(0) int inventoryAssignmentId,
    @Default(0) int totalPositions,
    @Default(0) int countedPositions,
    @Default(0.0) double completionPercentage,
    @Default(0) int discrepancyCount,
    @Default(0) int surplusCount,
    @Default(0) int shortageCount,
    @Default(0) int totalSurplusQuantity,
    @Default(0) int totalShortageQuantity,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _InventoryStatisticsDto;

  factory InventoryStatisticsDto.fromJson(Map<String, dynamic> json) => 
      _$InventoryStatisticsDtoFromJson(json);
}

@freezed
class CompleteAssignmentResultDto with _$CompleteAssignmentResultDto {
  const factory CompleteAssignmentResultDto({
    @Default(0) int assignmentId,
    @Default('') String message,
    InventoryStatisticsDto? statistics,
    DateTime? completedAt,
  }) = _CompleteAssignmentResultDto;

  factory CompleteAssignmentResultDto.fromJson(Map<String, dynamic> json) => 
      _$CompleteAssignmentResultDtoFromJson(json);
}

@freezed
class ItemInfoDto with _$ItemInfoDto {
  const factory ItemInfoDto({
    required int itemId,
    @Default('') String name,
  }) = _ItemInfoDto;

  factory ItemInfoDto.fromJson(Map<String, dynamic> json) => 
      _$ItemInfoDtoFromJson(json);
}
