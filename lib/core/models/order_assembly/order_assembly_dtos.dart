import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_assembly_dtos.freezed.dart';
part 'order_assembly_dtos.g.dart';

@freezed
class ScanPickRequest with _$ScanPickRequest {
  const factory ScanPickRequest({
    required int lineId,
    required String barcode,
  }) = _ScanPickRequest;

  factory ScanPickRequest.fromJson(Map<String, dynamic> json) => _$ScanPickRequestFromJson(json);
}

@freezed
class ScanPlaceBulkRequest with _$ScanPlaceBulkRequest {
  const factory ScanPlaceBulkRequest({
    required int assignmentId,
    required String cellCode,
  }) = _ScanPlaceBulkRequest;

  factory ScanPlaceBulkRequest.fromJson(Map<String, dynamic> json) => _$ScanPlaceBulkRequestFromJson(json);
}

@freezed
class ReportMissingRequest with _$ReportMissingRequest {
  const factory ReportMissingRequest({
    required int lineId,
    required String reason,
  }) = _ReportMissingRequest;

  factory ReportMissingRequest.fromJson(Map<String, dynamic> json) => _$ReportMissingRequestFromJson(json);
}

enum OrderAssemblyAssignmentStatus {
  pending,
  inProgress,
  completed,
  cancelled
}

enum OrderAssemblyLineStatus {
  pending,
  picked,
  placed,
  discrepancy
}

@freezed
class PlacementLineDto with _$PlacementLineDto {
  const factory PlacementLineDto({
    required int lineId,
    required int itemPositionId,
    required int itemId,
    String? itemName,
    String? barcode,
    required int quantity,
    required int pickedQuantity,
    required OrderAssemblyLineStatus status,
  }) = _PlacementLineDto;

  factory PlacementLineDto.fromJson(Map<String, dynamic> json) => _$PlacementLineDtoFromJson(json);
}

@freezed
class CellPlacementInfoDto with _$CellPlacementInfoDto {
  const factory CellPlacementInfoDto({
    required int targetPositionId,
    String? cellCode,
    String? cellDisplayName,
    @Default([]) List<PlacementLineDto> items,
  }) = _CellPlacementInfoDto;

  factory CellPlacementInfoDto.fromJson(Map<String, dynamic> json) => _$CellPlacementInfoDtoFromJson(json);
}

@freezed
class WorkerAssemblyTaskDto with _$WorkerAssemblyTaskDto {
  const factory WorkerAssemblyTaskDto({
    required int assignmentId,
    required int taskId,
    String? taskNumber,
    required int orderId,
    required OrderAssemblyAssignmentStatus status,
    DateTime? createdDate,
    required int totalLines,
    @Default([]) List<CellPlacementInfoDto> cellPlacements,
  }) = _WorkerAssemblyTaskDto;

  factory WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) => _$WorkerAssemblyTaskDtoFromJson(json);
}

@freezed
class BulkPlaceResultDto with _$BulkPlaceResultDto {
  const factory BulkPlaceResultDto({
    required int placedCount,
    required int remainingCells,
  }) = _BulkPlaceResultDto;

  factory BulkPlaceResultDto.fromJson(Map<String, dynamic> json) => _$BulkPlaceResultDtoFromJson(json);
}