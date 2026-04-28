import 'package:flutter/foundation.dart';
import 'mobile_app_user_dto.dart';

/// Текущий пользователь системы (хранит данные сессии)
class CurrentUser {
  final int id;
  // Делаем employeeId nullable, так как у покупателей его нет
  final int? employeeId;
  // Добавляем опциональный customerId
  final int? customerId;
  final String firstName;
  final String lastName;
  final String role;
  final String accessToken;
  final DateTime tokenExpiresAt;

  CurrentUser({
    required this.id,
    this.employeeId,
    this.customerId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.accessToken,
    required this.tokenExpiresAt,
  });

  String get fullName => '$lastName $firstName'.trim();

  // Метод для удобного создания CurrentUser из DTO, возвращаемого API
  factory CurrentUser.fromDto(MobileAppUserDto dto, {String token = '', DateTime? expiresAt}) {
    return CurrentUser(
      id: dto.id,
      employeeId: dto.employeeId,
      customerId: dto.customerId,
      firstName: dto.firstName, 
      lastName: dto.lastName,
      role: dto.role,
      accessToken: token,
      tokenExpiresAt: expiresAt ?? DateTime.now().add(const Duration(hours: 24)),
    );
  }
}