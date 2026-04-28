import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:helper_app/core/models/user/worker_role.dart';

part 'mobile_app_user_dto.freezed.dart';
part 'mobile_app_user_dto.g.dart';

/// Зеркальное отражение C# Enum: TaskControl.TaskModule.Domain.MobileUserRole
enum MobileUserRole {
  @JsonValue(1) worker,
  @JsonValue(2) supervisor,
  @JsonValue(3) admin,
  @JsonValue(4) customer,
  @JsonValue(0) unknown // Фолбэк для безопасности (если бэкенд пришлет неожиданное число)
}

/// DTO пользователя из мобильного приложения
@freezed
class MobileAppUserDto with _$MobileAppUserDto {
  const factory MobileAppUserDto({
    required int id,
    int? employeeId,
    int? customerId,
    int? branchId,
    required String firstName,
    required String lastName,
    
    // Используем Enum с указанием фолбэк-значения
    @JsonKey(unknownEnumValue: MobileUserRole.unknown)
    required MobileUserRole role,
    @JsonKey(unknownEnumValue: WorkerRole.unknown)
    WorkerRole? workerRole,
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