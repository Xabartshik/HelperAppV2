import 'package:freezed_annotation/freezed_annotation.dart';

part 'complaint_dto.freezed.dart';
part 'complaint_dto.g.dart';

/// DTO для отправки жалобы по заказу
@freezed
class ComplaintDto with _$ComplaintDto {
  const factory ComplaintDto({
    required int orderId,
    required String reason, // Выбранная причина (например: "Брак", "Недовоз")
    String? comment,        // Свободный комментарий пользователя
    @Default([]) List<int> problemItemIds, // ID товаров, к которым относится жалоба
    @Default([]) List<String> photoPaths,  // Локальные пути к прикрепленным фото (до загрузки на сервер)
  }) = _ComplaintDto;

  factory ComplaintDto.fromJson(Map<String, dynamic> json) => _$ComplaintDtoFromJson(json);
}