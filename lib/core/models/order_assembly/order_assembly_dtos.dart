import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_assembly_dtos.freezed.dart';
part 'order_assembly_dtos.g.dart';

// ---------------------------------------------------------------------------
// Статус отдельной строки сборки
// ---------------------------------------------------------------------------

/// Статус позиции в задаче сборки
enum AssemblyStatus {
  /// Ожидает сбора
  @JsonValue('Pending')
  pending,

  /// Собран в тележку
  @JsonValue('Picked')
  picked,

  /// Размещён в ячейку выдачи
  @JsonValue('Placed')
  placed,

  /// Отмечен как отсутствующий
  @JsonValue('Missing')
  missing,
}

// ---------------------------------------------------------------------------
// DTO: конкретный товар внутри ячейки
// ---------------------------------------------------------------------------

/// Описывает один товар внутри ячейки сборки
@freezed
class AssemblyItemDto with _$AssemblyItemDto {
  const factory AssemblyItemDto({
    /// Идентификатор строки задания
    required String lineId,

    /// Идентификатор товара
    required int itemId,

    /// Наименование товара
    @Default('') String itemName,

    /// Штрихкод товара
    @Default('') String barcode,

    /// Требуемое количество
    required int quantity,

    /// Фактически собранное количество
    @Default(0) int collectedQuantity,

    /// Текущий статус позиции
    @Default(AssemblyStatus.pending) AssemblyStatus status,
  }) = _AssemblyItemDto;

  factory AssemblyItemDto.fromJson(Map<String, dynamic> json) =>
      _$AssemblyItemDtoFromJson(json);
}

// ---------------------------------------------------------------------------
// DTO: ячейка назначения (PICKUP) с привязанными товарами
// ---------------------------------------------------------------------------

/// Описывает ячейку выдачи и список товаров, которые в неё нужно разместить
@freezed
class CellPlacement with _$CellPlacement {
  const factory CellPlacement({
    /// Идентификатор назначения (assembly assignment ID)
    required String assignmentId,

    /// Код ячейки (штрихкод, который сканирует работник в режиме Размещения)
    required String cellCode,

    /// Отображаемое название ячейки
    @Default('') String cellDisplayName,

    /// Список товаров, относящихся к этой ячейке
    @Default([]) List<AssemblyItemDto> items,
  }) = _CellPlacement;

  factory CellPlacement.fromJson(Map<String, dynamic> json) =>
      _$CellPlacementFromJson(json);
}

// ---------------------------------------------------------------------------
// DTO: основная задача сборки для сотрудника
// ---------------------------------------------------------------------------

/// Общая задача сборки, назначенная сотруднику
@freezed
class WorkerAssemblyTaskDto with _$WorkerAssemblyTaskDto {
  const factory WorkerAssemblyTaskDto({
    /// Уникальный ID назначения
    required String assignmentId,

    /// Номер задачи (отображается в списке)
    @Default('') String taskNumber,

    /// Дата создания задачи
    String? createdDate,

    /// Список ячеек выдачи с привязанными товарами
    @Default([]) List<CellPlacement> cellPlacements,
  }) = _WorkerAssemblyTaskDto;

  factory WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) =>
      _$WorkerAssemblyTaskDtoFromJson(json);
}

// ---------------------------------------------------------------------------
// Request DTOs
// ---------------------------------------------------------------------------

/// Запрос для сканирования товара (режим Сбора)
@freezed
class ScanPickRequest with _$ScanPickRequest {
  const factory ScanPickRequest({
    /// ID строки задания
    required String lineId,

    /// Отсканированный штрихкод товара
    required String barcode,
  }) = _ScanPickRequest;

  factory ScanPickRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanPickRequestFromJson(json);
}

/// Запрос для массового размещения товаров ячейки (режим Размещения)
@freezed
class ScanPlaceBulkRequest with _$ScanPlaceBulkRequest {
  const factory ScanPlaceBulkRequest({
    /// ID назначения (все товары этого назначения переводятся в «Размещено»)
    required String assignmentId,

    /// Код ячейки выдачи (результат сканирования)
    required String cellCode,
  }) = _ScanPlaceBulkRequest;

  factory ScanPlaceBulkRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanPlaceBulkRequestFromJson(json);
}

/// Запрос для сообщения об отсутствующем товаре
@freezed
class ReportMissingRequest with _$ReportMissingRequest {
  const factory ReportMissingRequest({
    /// ID строки задания с отсутствующим товаром
    required String lineId,

    /// Причина отсутствия
    required String reason,
  }) = _ReportMissingRequest;

  factory ReportMissingRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportMissingRequestFromJson(json);
}
