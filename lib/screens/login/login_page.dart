import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'login_viewmodel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Переименовали контроллер для универсальности (ID или Логин)
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  final _backgroundColor = const Color(0xFF141414);
  final _titleColor = Colors.white;
  final _labelColor = const Color(0xFFA1A1AA);
  final _primaryColor = const Color(0xFF7C3AED);
  final _inputBgColor = const Color(0xFF1C1C1E);
  final _textColor = Colors.white;
  final _errorColor = const Color(0xFFFF6B6B);
  final _warningColor = const Color(0xFFFFD93D);

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    
    final success = await ref.read(loginViewModelProvider.notifier).login(
      _identifierController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'HelperApp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _titleColor,
                  ),
                ),
                const SizedBox(height: 40),

                // --- НОВОЕ: Переключатель режимов ---
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false, 
                      label: Text('Сотрудник'), 
                      icon: Icon(Icons.badge, size: 18),
                    ),
                    ButtonSegment(
                      value: true, 
                      label: Text('Покупатель'), 
                      icon: Icon(Icons.person, size: 18),
                    ),
                  ],
                  selected: {state.isCustomerMode},
                  onSelectionChanged: (Set<bool> newSelection) {
                    ref.read(loginViewModelProvider.notifier).toggleMode(newSelection.first);
                  },
                  style: SegmentedButton.styleFrom(
                    backgroundColor: _inputBgColor,
                    selectedBackgroundColor: _primaryColor,
                    selectedForegroundColor: Colors.white,
                    foregroundColor: _labelColor,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 30),

                // Логин / ID Input
                Text(
                  state.isCustomerMode ? 'Логин' : 'ID сотрудника',
                  style: TextStyle(color: _labelColor, fontSize: 14),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _identifierController,
                  // Меняем тип клавиатуры: для сотрудников — цифры, для клиентов — текст/email
                  keyboardType: state.isCustomerMode 
                      ? TextInputType.emailAddress 
                      : TextInputType.number,
                  style: TextStyle(color: _textColor, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _inputBgColor,
                    hintText: state.isCustomerMode 
                        ? 'Введите Email или Телефон' 
                        : 'Введите ваш ID',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4), 
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Input
                Text(
                  'Пароль',
                  style: TextStyle(color: _labelColor, fontSize: 14),
                ),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: _textColor, fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _inputBgColor,
                    hintText: 'Введите пароль',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4), 
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                ),
                
                const SizedBox(height: 10),

                // Error & Warning Messages
                if (state.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(color: _errorColor, fontSize: 14),
                    ),
                  ),

                if (!state.hasNetwork)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '⚠️ Нет подключения к сети',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _warningColor, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 30),

                // Кнопка входа
                if (state.isBusy)
                  Center(child: CircularProgressIndicator(color: _primaryColor))
                else
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: _textColor,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Войти',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                // --- НОВОЕ: Ссылка на регистрацию ---
                if (state.isCustomerMode) ...[
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: Text(
                      'Нет аккаунта? Зарегистрироваться',
                      style: TextStyle(color: _primaryColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}