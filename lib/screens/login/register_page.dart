import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'login_viewmodel.dart';
import '../../core/models/auth/register_request.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _loginController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _backgroundColor = const Color(0xFF141414);
  final _titleColor = Colors.white;
  final _labelColor = const Color(0xFFA1A1AA);
  final _primaryColor = const Color(0xFF7C3AED);
  final _inputBgColor = const Color(0xFF1C1C1E);
  final _textColor = Colors.white;
  final _errorColor = const Color(0xFFFF6B6B);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _loginController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final login = _loginController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // 1. Проверка обязательных полей (логика как в C# сервисе)
    if (login.isEmpty || password.isEmpty) {
      _showError('Логин и пароль обязательны для заполнения.');
      return;
    }
    if (firstName.isEmpty || lastName.isEmpty) {
      _showError('Имя и Фамилия обязательны для заполнения.');
      return;
    }

    // 2. Проверка: хотя бы телефон или Email
    if (phone.isEmpty && email.isEmpty) {
      _showError('Укажите хотя бы номер телефона или Email.');
      return;
    }

    // 3. Валидация Email (RegExp из MobileAppUserService.cs)
    if (email.isNotEmpty) {
      final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegExp.hasMatch(email)) {
        _showError('Введите корректный Email адрес.');
        return;
      }
    }

    // 4. Валидация Телефона (RegExp из MobileAppUserService.cs)
    if (phone.isNotEmpty) {
      final phoneRegExp = RegExp(r'^\+?[\d\s\-\(\)]{10,20}$');
      if (!phoneRegExp.hasMatch(phone)) {
        _showError('Введите корректный номер телефона (10-20 цифр).');
        return;
      }
    }

    final request = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      login: login,
      phone: phone.isEmpty ? null : phone,
      email: email.isEmpty ? null : email,
      password: password,
    );

    final success = await ref.read(loginViewModelProvider.notifier).register(request);

    if (success && mounted) {
      // Состояние currentUser обновится, роутер перекинет на главную
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Регистрация',
                  style: TextStyle(
                    color: _titleColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Создайте аккаунт покупателя',
                  style: TextStyle(color: _labelColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                _buildTextField(
                  controller: _firstNameController,
                  label: 'Имя',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Фамилия',
                  icon: Icons.people_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _loginController,
                  label: 'Придумайте логин',
                  icon: Icons.alternate_email,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Телефон',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Пароль',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 24),

                if (state.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      state.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _errorColor, fontSize: 14),
                    ),
                  ),

                if (state.isBusy)
                  const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                else
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: _textColor,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Зарегистрироваться',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Уже есть аккаунт? Войти',
                    style: TextStyle(color: _labelColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: TextStyle(color: _textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: _labelColor),
        prefixIcon: Icon(icon, color: _labelColor),
        filled: true,
        fillColor: _inputBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 1),
        ),
      ),
    );
  }
}