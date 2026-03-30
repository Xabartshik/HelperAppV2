import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_app_user_dto.freezed.dart';
part 'mobile_app_user_dto.g.dart';

/// DTO пользователя из мобильного приложения
@freezed
class MobileAppUserDto with _$MobileAppUserDto {
  const factory MobileAppUserDto({
    required int id,
    required int employeeId,
    required String firstName,
    required String lastName,
    required String role,
    required bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MobileAppUserDto;

  factory MobileAppUserDto.fromJson(Map<String, dynamic> json) => 
      _$MobileAppUserDtoFromJson(json);
}

extension MobileAppUserDtoExtension on MobileAppUserDto {
  String get fullName => '$firstName $lastName';
}
