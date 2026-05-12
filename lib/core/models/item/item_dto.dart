import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_dto.freezed.dart';
part 'item_dto.g.dart';

@freezed
class ItemDto with _$ItemDto {
  const factory ItemDto({
    @Default(0) int itemId,
    required String name,
    required double weight,
    required double length,
    required double width,
    required double height,
    @Default(0.0) double price,
  }) = _ItemDto;

  factory ItemDto.fromJson(Map<String, dynamic> json) => _$ItemDtoFromJson(json);
}