import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Импорты экранов
import '../../screens/login/login_page.dart';
import '../../screens/home/main_page.dart';
import '../../screens/boss_panel/boss_panel_page.dart';
import '../../screens/inventory/inventory_details_page.dart';
import '../../screens/inventory/barcode_scanner_page.dart';
import '../../screens/order_assembly/task_selection_screen.dart';
import '../../screens/order_assembly/active_assembly_screen.dart';
import '../../screens/order_assembly/assembly_barcode_scanner_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Следим за состоянием текущего пользователя
  final currentUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: currentUser != null ? '/home' : '/login',
    // Включаем логирование маршрутов
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/boss-panel',
        name: 'boss_panel',
        builder: (context, state) => const BossPanelPage(),
      ),
      GoRoute(
        path: '/inventory-details',
        name: 'inventory_details',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return InventoryDetailsPage(
            workerId: args['workerId'] as int? ?? 0, 
            assignmentId: args['assignmentId'] as int? ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/barcode-scanner',
        name: 'barcode_scanner',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return BarcodeScannerPage(args: args);
        },
      ),
      GoRoute(
        path: '/order-assembly',
        name: 'order_assembly',
        builder: (context, state) => const TaskSelectionScreen(),
      ),
      GoRoute(
        path: '/order-assembly/active',
        name: 'order_assembly_active',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return ActiveAssemblyScreen(
            assignmentId: args['assignmentId'] as int? ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/order-assembly/scanner',
        name: 'order_assembly_scanner',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return AssemblyBarcodeScannerPage(
            assignmentId: args['assignmentId'] as int? ?? 0,
            userId: args['userId'] as int? ?? 0,
          );
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = currentUser != null;
      final isLoggingIn = state.uri.path == '/login';

      // Если не залогинен и не на странице логина - на логин
      if (!isLoggedIn && !isLoggingIn) return '/login';
      
      // Если залогинен и пытается открыть логин - на главную
      if (isLoggedIn && isLoggingIn) return '/home';

      return null; // Ничего не делаем
    },
  );
});
