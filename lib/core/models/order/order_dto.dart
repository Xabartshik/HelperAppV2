import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_dto.freezed.dart';
part 'order_dto.g.dart';

@freezed
class OrderDto with _$OrderDto {
  const factory OrderDto({
    required int orderId,
    required int customerId,
    required int branchId,
    required String deliveryType,
    required String paymentType, // Добавлено
    required String status,
    required double totalPrice,
    DateTime? deliveryDate,
    int? deliverySlotId,       // Добавлено
    String? destinationAddress, // Добавлено
    int? postamatId,           // Добавлено
    int? postamatCellId,       // Добавлено
    @Default([]) List<OrderPositionDto> positions,
  }) = _OrderDto;

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);
}

@freezed
class OrderPositionDto with _$OrderPositionDto {
  const factory OrderPositionDto({
    required int uniqueId,
    required int itemId,
    String? itemName,
    required int quantity,
    required double price,
  }) = _OrderPositionDto;

  factory OrderPositionDto.fromJson(Map<String, dynamic> json) => _$OrderPositionDtoFromJson(json);
}