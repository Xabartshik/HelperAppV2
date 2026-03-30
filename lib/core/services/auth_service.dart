import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user/current_user.dart';
import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';
import '../network/api_client.dart';
import '../network/api_exceptions.dart';
import '../utils/logger.dart';

/// Провайдер текущего пользователя (для наблюдения за состоянием авторизации в UI)
final currentUserProvider = StateProvider<CurrentUser?>((ref) => null);

/// Провайдер AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient, ref);
});

class AuthService {
  final ApiClient _apiClient;
  final Ref _ref;
  
  static const String _tokenKey = 'access_token';
  static const String _employeeIdKey = 'last_employee_id';
  static const String _roleKey = 'last_role';
  static const String _firstNameKey = 'first_name';
  static const String _lastNameKey = 'last_name';
  static const String _userIdKey = 'user_id';

  AuthService(this._apiClient, this._ref);

  CurrentUser? getCurrentUser() => _ref.read(currentUserProvider.notifier).state;

  Future<CurrentUser?> loginAsync(String employeeId, String password) async {
    try {
      final request = LoginRequest(username: employeeId, password: password);
      
      final responseData = await _apiClient.postAsync(
        'v1/mobileappuser/login', // Исправленный эндпоинт, удалено /api так как оно в baseUrl
        data: request.toJson(),
      );

      if (responseData == null) {
        Logger.w('Пустой ответ от сервера при логине');
        return null;
      }

      final response = LoginResponse.fromJson(responseData);
      final token = response.accessToken;
      
      if (token.isEmpty) {
        Logger.w('Пустой токен от сервера');
        return null;
      }

      final jwtPayload = _parseJwt(token);
      final expiresAtSeconds = jwtPayload['exp'] as int? ?? 0;
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtSeconds * 1000);

      final user = CurrentUser(
        id: response.user.id,
        employeeId: response.user.employeeId,
        firstName: response.user.firstName,
        lastName: response.user.lastName,
        role: response.user.role,
        accessToken: token,
        tokenExpiresAt: expiresAt,
      );

      // Сохраняем в кэш
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setInt(_userIdKey, user.id);
      await prefs.setInt(_employeeIdKey, user.employeeId);
      await prefs.setString(_roleKey, user.role);
      await prefs.setString(_firstNameKey, user.firstName);
      await prefs.setString(_lastNameKey, user.lastName);

      _apiClient.setAuthorizationToken(token);
      
      // Обновляем состояние Riverpod
      _ref.read(currentUserProvider.notifier).state = user;

      Logger.i('Успешный логин: EmployeeId=${user.employeeId}, Role=${user.role}');
      return user;

    } on UnauthorizedException {
      Logger.w('Неверные учетные данные для пользователя: $employeeId');
      rethrow;
    } on NoNetworkException {
      Logger.e('Нет подключения к сети при логине');
      rethrow;
    } catch (e) {
      Logger.e('Ошибка при логине пользователя $employeeId', e);
      rethrow;
    }
  }

  Future<CurrentUser?> tryAutoLoginAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);

      if (token == null || token.isEmpty) {
        Logger.i('Токен не найден в SharedPreferences');
        return null;
      }

      try {
        final jwtPayload = _parseJwt(token);
        final expiresAtSeconds = jwtPayload['exp'] as int? ?? 0;
        final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtSeconds * 1000);

        if (expiresAt.isBefore(DateTime.now())) {
          Logger.i('Токен истёк');
          await logoutAsync();
          return null;
        }

        final employeeId = prefs.getInt(_employeeIdKey) ?? 0;
        final role = prefs.getString(_roleKey) ?? '';
        final firstName = prefs.getString(_firstNameKey) ?? '';
        final lastName = prefs.getString(_lastNameKey) ?? '';
        final userId = prefs.getInt(_userIdKey) ?? 0;

        if (employeeId == 0 || role.isEmpty) {
          Logger.w('Метаданные пользователя не найдены во внутреннем хранилище');
          await logoutAsync();
          return null;
        }

        final user = CurrentUser(
          id: userId,
          employeeId: employeeId,
          firstName: firstName,
          lastName: lastName,
          role: role,
          accessToken: token,
          tokenExpiresAt: expiresAt,
        );

        _apiClient.setAuthorizationToken(token);
        _ref.read(currentUserProvider.notifier).state = user;

        Logger.i('Успешный автологин: EmployeeId=$employeeId');
        return user;
      } catch (e) {
        Logger.e('Ошибка при проверке валидности токена', e);
        await logoutAsync();
        return null;
      }
    } catch (e) {
      Logger.e('Ошибка при попытке автологина', e);
      return null;
    }
  }

  Future<void> logoutAsync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_employeeIdKey);
      await prefs.remove(_roleKey);
      await prefs.remove(_firstNameKey);
      await prefs.remove(_lastNameKey);

      _apiClient.setAuthorizationToken(null);
      _ref.read(currentUserProvider.notifier).state = null;

      Logger.i('Успешный выход из приложения');
    } catch (e) {
      Logger.e('Ошибка при выходе из приложения', e);
    }
  }

  /// Утилита для парсинга JWT токена без сторонних библиотек
  Map<String, dynamic> _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Неверный формат токена');
    }
    
    String payload = parts[1];
    String normalized = base64Url.normalize(payload);
    String decoded = utf8.decode(base64Url.decode(normalized));
    
    return json.decode(decoded);
  }
}
