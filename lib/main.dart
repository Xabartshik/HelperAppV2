import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/services/auth_service.dart';
//Сделано для диплома.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Создаем контейнер Riverpod глобально для возможности выполнить код до runApp
  final container = ProviderContainer();
  
  // Пытаемся восстановить сессию (автологин)
  final authService = container.read(authServiceProvider);
  await authService.tryAutoLoginAsync();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const HelperApp(),
    ),
  );
}

class HelperApp extends ConsumerWidget {
  const HelperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем роутер
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'HelperApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
