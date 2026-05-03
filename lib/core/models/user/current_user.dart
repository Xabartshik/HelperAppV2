import 'package:flutter/foundation.dart';
import 'package:helper_app/core/models/user/worker_role.dart';
import 'mobile_app_user_dto.dart';

/// Текущий пользователь системы (хранит данные сессии)
class CurrentUser {
  final int id;
  // Делаем employeeId nullable, так как у покупателей его нет
  final int? employeeId;
  // Добавляем опциональный customerId
  final int? customerId;
  // ДОБАВЛЕНО: branchId для привязки к филиалу
  final int? branchId; 

  final String firstName;
  final String lastName;
  
  // 1. ИЗМЕНЕНО: теперь используем Enum вместо String
  final MobileUserRole role; 
  final WorkerRole? workerRole;
  final String accessToken;
  final DateTime tokenExpiresAt;

  CurrentUser({
    required this.id,
    this.employeeId,
    this.customerId,
    this.branchId, // ДОБАВЛЕНО
    required this.firstName,
    required this.lastName,
    
    // Оставляем required
    required this.role, 
    this.workerRole,
    
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
      branchId: dto.branchId, // ДОБАВЛЕНО
      firstName: dto.firstName, 
      lastName: dto.lastName,
      
      // 2. ИЗМЕНЕНО: теперь типы совпадают (MobileUserRole в MobileUserRole)
      role: dto.role, 
      workerRole: dto.workerRole,

      accessToken: token,
      tokenExpiresAt: expiresAt ?? DateTime.now().add(const Duration(hours: 24)),
    );
  }
}