/// Текущий пользователь системы (хранит данные сессии)
class CurrentUser {
  final int id;
  final int employeeId;
  final String firstName;
  final String lastName;
  final String role;
  final String accessToken;
  final DateTime tokenExpiresAt;

  CurrentUser({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.accessToken,
    required this.tokenExpiresAt,
  });

  String get fullName => '$lastName $firstName'; 
}
