import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/auth/register_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user/current_user.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../network/api_client.dart';
import '../network/api_exceptions.dart';
import '../utils/logger.dart';

final currentUserProvider = StateProvider<CurrentUser?>((ref) => null);

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient, ref);
});

class AuthService {
  final ApiClient _apiClient;
  final Ref _ref;
  
  static const String _tokenKey = 'access_token';
  static const String _employeeIdKey = 'last_employee_id';
  static const String _customerIdKey = 'last_customer_id'; // Добавлено
  static const String _roleKey = 'last_role';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _userIdKey = 'user_id';

  AuthService(this._apiClient, this._ref);

  CurrentUser? getCurrentUser() => _ref.read(currentUserProvider.notifier).state;

Future<CurrentUser?> _handleAuthResponse(Map<String, dynamic>? responseData) async {
    if (responseData == null) return null;

    final response = LoginResponse.fromJson(responseData);
    final token = response.accessToken;
    
    if (token.isEmpty) return null;

    final jwtPayload = _parseJwt(token);
    final expiresAtSeconds = jwtPayload['exp'] as int? ?? 0;
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtSeconds * 1000);

    // Создаем объект пользователя
    final user = CurrentUser(
      id: response.user.id,
      employeeId: response.user.employeeId,
      customerId: response.user.customerId,
      firstName: response.user.firstName,
      lastName: response.user.lastName,
      role: response.user.role,
      accessToken: token,
      tokenExpiresAt: expiresAt,
    );

    // Сохраняем в SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_userIdKey, user.id);
    await prefs.setString(_roleKey, user.role);
    await prefs.setString(_firstNameKey, user.firstName);
    await prefs.setString(_lastNameKey, user.lastName);
    
    if (user.employeeId != null) {
      await prefs.setInt(_employeeIdKey, user.employeeId!);
    }
    
    // Сохраняем ID клиента, если он есть
    if (user.customerId != null) {
      await prefs.setInt(_customerIdKey, user.customerId!); 
    }

    _apiClient.setAuthorizationToken(token);
    _ref.read(currentUserProvider.notifier).state = user;

    return user;
  }

  /// ЛОГИН
  Future<CurrentUser?> loginAsync(String identifier, String password) async {
    try {
      final responseData = await _apiClient.postAsync(
        ApiEndpoints.login,
        data: {'username': identifier, 'password': password},
      );

      final user = await _handleAuthResponse(responseData);
      if (user != null) {
        Logger.i('Успешный логин: ID=${user.id}, Role=${user.role}');
      }
      return user;
    } on UnauthorizedException {
      Logger.w('Неверные учетные данные: $identifier');
      rethrow;
    } catch (e) {
      Logger.e('Ошибка при логине $identifier', e);
      rethrow;
    }
  }
  /// РЕГИСТРАЦИЯ КЛИЕНТА
  Future<CurrentUser?> registerCustomerAsync(RegisterRequest request) async {
    try {
      final responseData = await _apiClient.postAsync(
        '/api/v1/MobileAppUser/register',
        data: request.toJson(),
      );

      final user = await _handleAuthResponse(responseData);
      if (user != null) {
        Logger.i('Успешная регистрация клиента: ID=${user.id}');
      }
      return user;
    } catch (e) {
      Logger.e('Ошибка при регистрации', e);
      rethrow;
    }
  }

  /// АВТОЛОГИН
  Future<CurrentUser?> tryAutoLoginAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) return null;

      final jwtPayload = _parseJwt(token);
      final expiresAtSeconds = jwtPayload['exp'] as int? ?? 0;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtSeconds * 1000);

      if (expiresAt.isBefore(DateTime.now())) {
        await logoutAsync();
        return null;
      }

      final user = CurrentUser(
        id: prefs.getInt(_userIdKey) ?? 0,
        employeeId: prefs.getInt(_employeeIdKey),
        customerId: prefs.getInt(_customerIdKey), // Загружаем customerId
        firstName: prefs.getString(_firstNameKey) ?? '',
        lastName: prefs.getString(_lastNameKey) ?? '',
        role: prefs.getString(_roleKey) ?? '',
        accessToken: token,
        tokenExpiresAt: expiresAt,
      );

      _apiClient.setAuthorizationToken(token);
      _ref.read(currentUserProvider.notifier).state = user;

      return user;
    } catch (e) {
      Logger.e('Ошибка при автологине', e);
      return null;
    }
  }

  /// ВЫХОД
  Future<void> logoutAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = [
        _tokenKey, _userIdKey, _employeeIdKey, 
        _customerIdKey, _roleKey, _firstNameKey, _lastNameKey
      ];
      
      for (var key in keys) {
        await prefs.remove(key);
      }

      _apiClient.setAuthorizationToken(null);
      _ref.read(currentUserProvider.notifier).state = null;

      Logger.i('Успешный выход');
    } catch (e) {
      Logger.e('Ошибка при выходе', e);
    }
  }

  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');
    String payload = parts[1];
    String normalized = base64Url.normalize(payload);
    return json.decode(utf8.decode(base64Url.decode(normalized)));
  }
}