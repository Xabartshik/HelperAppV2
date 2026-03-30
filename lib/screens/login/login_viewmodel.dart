import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/auth_service.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/logger.dart';

class LoginState {
  final bool isBusy;
  final String errorMessage;
  final bool hasNetwork;

  const LoginState({
    this.isBusy = false,
    this.errorMessage = '',
    this.hasNetwork = true,
  });

  LoginState copyWith({
    bool? isBusy,
    String? errorMessage,
    bool? hasNetwork,
  }) {
    return LoginState(
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNetwork: hasNetwork ?? this.hasNetwork,
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

  Future<bool> login(String employeeId, String password) async {
    if (employeeId.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Заполните все поля');
      return false;
    }

    if (int.tryParse(employeeId.trim()) == null) {
      state = state.copyWith(errorMessage: 'EmployeeId должен быть числом');
      return false;
    }

    state = state.copyWith(isBusy: true, errorMessage: '', hasNetwork: true);

    try {
      final authService = ref.read(authServiceProvider);
      final currentUser = await authService.loginAsync(employeeId.trim(), password.trim());

      if (currentUser != null) {
        Logger.i('Переход на главную (выполняется роутером)');
        return true;
      }
      return false;
    } on UnauthorizedException {
      state = state.copyWith(errorMessage: 'Неверные учетные данные', isBusy: false);
      Logger.w('Неверные учетные данные для пользователя $employeeId');
      return false;
    } on NoNetworkException {
      state = state.copyWith(errorMessage: 'Нет подключения к сети', hasNetwork: false, isBusy: false);
      Logger.e('Нет подключения к сети при логине');
      return false;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Ошибка: $e', isBusy: false);
      Logger.e('Ошибка при логине', e);
      return false;
    }
  }
}
