import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/user/mobile_app_user_dto.dart';
import 'package:helper_app/screens/home/all_orders_screen.dart';
import 'package:helper_app/screens/home/customer_home_page.dart';
import 'package:helper_app/screens/home/order_details_screen.dart';
import 'package:helper_app/screens/home/shift_scanner_page.dart';
import 'package:helper_app/screens/login/register_page.dart';
import 'package:helper_app/screens/create_order/create_order_page.dart';
import 'package:flutter/foundation.dart';
import 'package:helper_app/core/models/user/current_user.dart';
import 'package:helper_app/screens/order_assembly/customer_qr_scanner_page.dart';
import 'package:helper_app/screens/order_handover/active_handover_screen.dart';
import 'package:helper_app/screens/order_handover/handover_barcode_scanner_page.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

// Импорты существующих экранов
import '../../screens/login/login_page.dart';
import '../../screens/home/main_page.dart';
import '../../screens/boss_panel/boss_panel_page.dart';
import '../../screens/inventory/inventory_details_page.dart';
import '../../screens/inventory/barcode_scanner_page.dart';
import '../../screens/order_assembly/active_assembly_screen.dart';
import '../../screens/order_assembly/assembly_barcode_scanner_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  final router = GoRouter(
    initialLocation: _homeLocationFor(ref.read(currentUserProvider)),
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    
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
      GoRoute(
        path: '/shift-scanner',
        name: 'shiftScanner',
        builder: (context, state) => const ShiftScannerPage(),
      ),
      // --- НОВОЕ: Главная для покупателя ---
      GoRoute(
        path: '/customer-home',
        name: 'customer_home',
        builder: (context, state) => const CustomerHomePage(),
      ),
      GoRoute(
        path: '/customer/orders/create',
        name: 'customer_orders_create',
        builder: (context, state) => const CreateOrderPage(),
      ),
            GoRoute(
        path: '/customer/orders/list',
        name: 'customer_orders_list',
        builder: (context, state) {
          // Retrieve the current user's ID to pass to the screen
          final currentUser = ref.read(currentUserProvider);
          return AllOrdersScreen(customerId: currentUser?.customerId ?? 0);
        },
      ),
      GoRoute(
        path: '/order-handover/active',
        name: 'order_handover_active',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return ActiveHandoverScreen(
            assignmentId: args['assignmentId'] as int? ?? 0,
            taskId: args['taskId'] as int? ?? 0,
            taskStatusIndex: args['taskStatusIndex'] as int?,
            assignmentStatusIndex: args['taskStatusIndex'] as int?,
          );
        },
      ),
      GoRoute(
        path: '/customer-qr-scanner',
        name: 'customer_qr_scanner',
        builder: (context, state) => const CustomerQrScannerPage(),
      ),
      GoRoute(
        path: '/order-handover/scanner',
        name: 'order_handover_scanner',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return HandoverBarcodeScannerPage(
            taskId: args['taskId'] as int? ?? 0,
            workerId: args['workerId'] as int? ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/customer/orders/details/:id',
        name: 'customer_order_details',
        builder: (context, state) {
          final orderIdString = state.pathParameters['id'];
          final orderId = int.tryParse(orderIdString ?? '0') ?? 0;
          return OrderDetailsScreen(orderId: orderId);
        },
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
        redirect: (context, state) => '/home',
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
            assignmentStatusIndex: args['taskStatusIndex'] as int?,
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
      final user = ref.read(currentUserProvider);
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';
      Logger.i(
        'Router redirect check: path=${state.uri.path}, '
        'role=${user?.role.name ?? 'guest'}, '
        'loggedIn=${user != null}',
      );

      // 1. Если пользователь не авторизован
      if (user == null) {
        // Если он и так идет логиниться или регистрироваться — не мешаем
        return isLoggingIn ? null : '/login';
      }

      // 2. Если пользователь авторизован и пытается зайти на Login/Register
      if (isLoggingIn) {
        return _homeLocationFor(user);
      }

      // 3. Защита маршрутов: покупателю разрешаем только customer-маршруты.
      if (user.role == MobileUserRole.customer && !_isCustomerRoute(state.uri.path)) {
        Logger.w('Router redirect: customer blocked from ${state.uri.path}, redirecting to /customer-home');
        return '/customer-home';
      }

      // 4. Защита маршрутов: не пускать сотрудника в интерфейс покупателя.
      if (user.role != MobileUserRole.customer && _isCustomerRoute(state.uri.path)) {
        Logger.w('Router redirect: employee blocked from ${state.uri.path}, redirecting to /home');
        return '/home';
      }

      return null;
    },
  );

  ref.onDispose(router.dispose);
  return router;
});

String _homeLocationFor(CurrentUser? user) {
  if (user == null) return '/login';
  return user.role == MobileUserRole.customer ? '/customer-home' : '/home';
}

bool _isCustomerRoute(String path) {
  return path == '/customer-home' || path.startsWith('/customer/');
}

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _subscription = _ref.listen<CurrentUser?>(
      currentUserProvider,
      (previous, next) {
        Logger.i(
          'Router refresh: user changed '
          'from=${previous?.role.name ?? 'guest'} '
          'to=${next?.role.name ?? 'guest'}',
        );
        notifyListeners();
      },
      fireImmediately: false,
    );
  }

  final Ref _ref;
  late final ProviderSubscription<CurrentUser?> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
