import 'package:freezed_annotation/freezed_annotation.dart';

enum WorkerRole {
  @JsonValue(1) storekeeper,
  @JsonValue(2) orderIssuer,
  @JsonValue(3) manager,
  @JsonValue(4) courier,
  @JsonValue(0) unknown,
}

extension WorkerRoleExtension on WorkerRole {
  String get displayName {
    switch (this) {
      case WorkerRole.storekeeper: return 'Сборщик заказов';
      case WorkerRole.orderIssuer: return 'Кассир (Выдача)';
      case WorkerRole.manager: return 'Начальник';
      case WorkerRole.courier: return 'Курьер';
      default: return 'Сотрудник';
    }
  }
}