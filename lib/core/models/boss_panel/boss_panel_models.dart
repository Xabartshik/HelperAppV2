import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:helper_app/core/models/inventory/position_cell_dto.dart';

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
    @Default(0.0) double totalComplexity,
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
    double? maxWeightKg,
    String? vehicleName,
    @Default(false) bool isOnRoute,
  }) = _AvailableEmployeeDto;

  factory AvailableEmployeeDto.fromJson(Map<String, dynamic> json) => _$AvailableEmployeeDtoFromJson(json);
}

@freezed
class CreateInventoryByZoneDto with _$CreateInventoryByZoneDto {
  const factory CreateInventoryByZoneDto({
    @Default([]) List<String> zonePrefixes,
    @Default(3) int priorityLevel,
    @Default(1) int workerCount,
    List<int>? workerIds,
    String? description,
    DateTime? deadlineDate,
  }) = _CreateInventoryByZoneDto;

  factory CreateInventoryByZoneDto.fromJson(Map<String, dynamic> json) => _$CreateInventoryByZoneDtoFromJson(json);
}

// ДОБАВЬ НОВУЮ МОДЕЛЬ ДЛЯ ТОВАРОВ
@freezed
class OrderItemDetailDto with _$OrderItemDetailDto {
  const factory OrderItemDetailDto({
    required int itemId,
    @Default('') String name,
    @Default(0) int quantity,
    @Default(0.0) double weightKg,
  }) = _OrderItemDetailDto;

  factory OrderItemDetailDto.fromJson(Map<String, dynamic> json) => _$OrderItemDetailDtoFromJson(json);
}

// ОБНОВИ ЭТУ МОДЕЛЬ
@freezed
class AvailableOrderDto with _$AvailableOrderDto {
  const factory AvailableOrderDto({
    required int orderId,
    @Default('') String orderNumber,
    DateTime? createdAt,
    @Default('') String status,
    @Default('') String deliveryType,
    @Default('') String paymentType,
    DateTime? deliveryDate,
    String? destinationAddress,
    String? postamatAddress,
    String? postamatCellNumber,
    String? postamatCellSize,
    @Default([]) List<OrderItemDetailDto> items, // Теперь тут живет список товаров
  }) = _AvailableOrderDto;

  factory AvailableOrderDto.fromJson(Map<String, dynamic> json) => _$AvailableOrderDtoFromJson(json);
}

@freezed
class CreateOrderAssemblyTaskDto with _$CreateOrderAssemblyTaskDto {
  const factory CreateOrderAssemblyTaskDto({
    required int orderId,
    required int assignedUserId,
    @Default(7) int priority,
    String? description,
  }) = _CreateOrderAssemblyTaskDto;

  factory CreateOrderAssemblyTaskDto.fromJson(Map<String, dynamic> json) => _$CreateOrderAssemblyTaskDtoFromJson(json);
}
