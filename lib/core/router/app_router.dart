import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/screens/home/customer_home_page.dart';
import 'package:helper_app/screens/login/register_page.dart';
import '../services/auth_service.dart';

// Импорты существующих экранов
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
  final user = ref.watch(currentUserProvider);

  return GoRouter(
    // Начальная точка зависит от роли
    initialLocation: user == null 
        ? '/login' 
        : (user.role.toString().toLowerCase() == 'customer' ? '/customer-home' : '/'),
    
    debugLogDiagnostics: true,
    
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // --- НОВОЕ: Маршрут регистрации ---
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      // --- НОВОЕ: Главная для покупателя ---
      GoRoute(
        path: '/customer-home',
        name: 'customer_home',
        builder: (context, state) => const CustomerHomePage(),
      ),
      
      // Маршруты сотрудников
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
            taskId: args['taskId'] as int? ?? 0,
            taskStatusIndex: args['taskStatusIndex'] as int?,
            assignmentStatusIndex: args['assignmentStatus'] as int?,
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
            taskId: args['taskId'] as int? ?? 0,
            taskStatusIndex: args['taskStatusIndex'] as int?,
            assignmentStatusIndex: args['assignmentStatus'] as int?,
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
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';

      // 1. Если пользователь не авторизован
      if (user == null) {
        // Если он и так идет логиниться или регистрироваться — не мешаем
        return isLoggingIn ? null : '/login';
      }

      // 2. Если пользователь авторизован и пытается зайти на Login/Register
      if (isLoggingIn) {
        // Редиректим на соответствующую главную в зависимости от роли
        return (user.role == 'Customer') ? '/customer-home' : '/home';
      }

      // 3. Защита маршрутов: не пускать покупателя в складскую часть
      // Если это покупатель и путь НЕ начинается с /customer
      if (user.role == 'Customer' && !state.uri.path.startsWith('/customer')) {
        return '/customer-home';
      }

      // 4. Защита маршрутов: не пускать сотрудника в интерфейс покупателя (опционально)
      if (user.role != 'Customer' && state.uri.path.startsWith('/customer')) {
        return '/home';
      }

      return null;
    },
  );
});