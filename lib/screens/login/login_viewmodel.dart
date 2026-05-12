import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/logger.dart';
import '../../core/models/auth/register_request.dart';

class LoginState {
  final bool isBusy;
  final String errorMessage;
  final bool hasNetwork;
  final bool isCustomerMode; // Режим покупателя

  const LoginState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
    this.isCustomerMode = false, // По умолчанию — сотрудник
  });

  LoginState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool? hasNetwork,
    bool? isCustomerMode,
  }) {
    return LoginState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNetwork: hasNetwork ?? this.hasNetwork,
      isCustomerMode: isCustomerMode ?? this.isCustomerMode,
    );
  }
}

final loginViewModelProvider = AutoDisposeNotifierProvider<LoginViewModel, LoginState>(() {
  return LoginViewModel();
});

class LoginViewModel extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  /// Переключение между режимом сотрудника и покупателя
  void toggleMode(bool isCustomer) {
    state = state.copyWith(
      isCustomerMode: isCustomer, 
      errorMessage: '',
      hasNetwork: true,
    );
  }

  /// Вход в систему
  Future<bool> login(String identifier, String password) async {
    final cleanId = identifier.trim();
    final cleanPass = password.trim();

    if (cleanId.isEmpty || cleanPass.isEmpty) {
      state = state.copyWith(errorMessage: 'Заполните все поля');
      return false;
    }

    // Валидация только для режима сотрудника (проверка на число)
    // if (!state.isCustomerMode && int.tryParse(cleanId) == null) {
    //   state = state.copyWith(errorMessage: 'EmployeeId должен быть числом');
    //   return false;
    // }

    state = state.copyWith(isBusy: true, errorMessage: '', hasNetwork: true);

    try {
      final authService = ref.read(authServiceProvider);
      // Используем метод из AuthService (теперь он принимает String как универсальный ID)
      final currentUser = await authService.loginAsync(cleanId, cleanPass);

      if (currentUser != null) {
        Logger.i('Успешный вход в систему');
        return true;
      }
      return false;
    } on UnauthorizedException {
      state = state.copyWith(errorMessage: 'Неверные учетные данные', isBusy: false);
      return false;
    } on NoNetworkException {
      state = state.copyWith(errorMessage: 'Нет подключения к сети', hasNetwork: false, isBusy: false);
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка: $e', isBusy: false);
      Logger.e('Ошибка при логине', e);
      return false;
    }
  }

  /// Регистрация покупателя
Future<bool> register(RegisterRequest data) async {
    state = state.copyWith(isBusy: true, errorMessage: '', hasNetwork: true);
    
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.registerCustomerAsync(data);
      
      if (user != null) {
        Logger.i('Регистрация прошла успешно');
        return true;
      }
      return false;
    } on ConflictException catch (e) {
      // --- НОВОЕ: Показываем красивую ошибку, если телефон/логин занят ---
      state = state.copyWith(errorMessage: e.message, isBusy: false);
      Logger.w('Конфликт при регистрации: ${e.message}');
      return false;
    } on NoNetworkException {
      state = state.copyWith(errorMessage: 'Нет подключения к сети', hasNetwork: false, isBusy: false);
      return false;
    } catch (e) {
      // Можно также выводить текст ошибки с бэкенда для ApiException
      final msg = e is ApiException ? e.toString() : 'Ошибка регистрации';
      state = state.copyWith(errorMessage: msg, isBusy: false);
      Logger.e('Ошибка при регистрации', e);
      return false;
    }
  }
}