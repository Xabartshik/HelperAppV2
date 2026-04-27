import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
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
  @JsonValue(0) pending,
  @JsonValue(1) inProgress,
  @JsonValue(2) completed,
  @JsonValue(3) cancelled
}

enum OrderAssemblyLineStatus {
  @JsonValue(0) pending,
  @JsonValue(1) picked,
  @JsonValue(2) placed,
  @JsonValue(3) discrepancy
}

@freezed
class PlacementLineDto with _$PlacementLineDto {
  const factory PlacementLineDto({
    required int lineId,
    required int itemPositionId,
    required int itemId,
    String? itemName,
    String? barcode,
    String? sourceCellCode,
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
    required AssignmentStatus status,
    DateTime? createdDate,
    required int totalLines,
    @Default([]) List<CellPlacementInfoDto> cellPlacements,
  }) = _WorkerAssemblyTaskDto;

  factory WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) => _$WorkerAssemblyTaskDtoFromJson(json);
}
