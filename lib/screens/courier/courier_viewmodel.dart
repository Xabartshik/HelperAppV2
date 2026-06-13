import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/attendance/check_io_employee_dto.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order/order_dto.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';

class CourierState {
  final bool isLoading;
  final String errorMessage;
  final List<OrderDto> readyOrders;
  final List<OrderDto> inTransitOrders;
  final CheckIOEmployeeDto? currentCheck; // ДОБАВЛЕНО: статус смены

  const CourierState({
    this.isLoading = false,
    this.errorMessage = '',
    this.readyOrders = const [],
    this.inTransitOrders = const [],
    this.currentCheck, // ДОБАВЛЕНО
  });

  CourierState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OrderDto>? readyOrders,
    List<OrderDto>? inTransitOrders,
    CheckIOEmployeeDto? currentCheck, // ДОБАВЛЕНО
  }) {
    return CourierState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      readyOrders: readyOrders ?? this.readyOrders,
      inTransitOrders: inTransitOrders ?? this.inTransitOrders,
      currentCheck: currentCheck ?? this.currentCheck, // ДОБАВЛЕНО
    );
  }

  // Удобный геттер для UI: если последний чек был 'In', значит смена идет
bool get isShiftActive => const ['in', 'dispatch', 'dock']
    .contains(currentCheck?.checkType.toLowerCase());
}

final courierViewModelProvider = AutoDisposeNotifierProvider<CourierViewModel, CourierState>(() {
  return CourierViewModel();
});

class CourierViewModel extends AutoDisposeNotifier<CourierState> {
  Timer? _refreshTimer;

  @override
  CourierState build() {
    Future.microtask(() => loadOrders());
    // Автообновление каждые 30 секунд, чтобы видеть, когда кладовщик выдал товар
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => loadOrders(isSilent: true));
    
    ref.onDispose(() => _refreshTimer?.cancel());
    return const CourierState();
  }

Future<void> loadOrders({bool isSilent = false}) async {
    if (!isSilent) state = state.copyWith(isLoading: true, errorMessage: '');
    
    try {
      final user = ref.read(currentUserProvider);
      if (user?.employeeId == null) return;

      final client = ref.read(apiClientProvider);
      
      // Выполняем запросы параллельно для скорости
      final responses = await Future.wait([
        client.getCourierOrdersAsync(user!.employeeId!),
        client.getLastCheckAsync(user.employeeId!), // Запрашиваем статус смены
      ]);

      final allOrders = responses[0] as List<OrderDto>;
      final check = responses[1] as CheckIOEmployeeDto?;

      final ready = allOrders.where((o) => o.status.toString().contains('Ready')).toList();
      final inTransit = allOrders.where((o) => o.status.toString().contains('InTransit')).toList();

      state = state.copyWith(
        isLoading: false,
        readyOrders: ready,
        inTransitOrders: inTransit,
        currentCheck: check, // Сохраняем статус
      );
    } catch (e) {
      Logger.e('Ошибка в загрузке маршрутного листа', e);
      if (!isSilent) state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Отправка QR-кода проходной на сервер
Future<bool> scanShiftQr(String payload, int branchId, String checkType) async {
    try {
      final client = ref.read(apiClientProvider);
      
      await client.scanQrCheckInAsync(payload, branchId, checkType);
      await loadOrders(isSilent: true); 
      
      return true; // <-- Возвращаем успех!
    } catch (e) {
      Logger.e('Ошибка при отметке на смене', e);
      state = state.copyWith(errorMessage: e.toString());
      return false; // <-- Возвращаем провал
    }
  }

  Future<bool> rejectOrder(int orderId) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      await client.rejectCourierOrderAsync(orderId);
      await loadOrders(isSilent: true); // Обновляем список, чтобы заказ исчез с экрана
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> setTransportStatus(String newCheckType) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      final user = ref.read(currentUserProvider);
      
      if (user == null) throw Exception('Пользователь не найден');

      // 1. Отправляем статус на сервер
      await client.updateCourierStatusAsync(user.branchId!, newCheckType);

      // 2. Обновляем локальное состояние, чтобы UI мгновенно перерисовался
      final newCheck = CheckIOEmployeeDto(
        id: 0, 
        employeeId: user.employeeId!,
        branchId: user.branchId!,
        checkType: newCheckType,
        checkTimeStamp: DateTime.now(),
      );
      state = state.copyWith(isLoading: false, currentCheck: newCheck);

      // 3. Если курьер вернулся на базу ('dock'), возможно у него забрали отказы.
      // На всякий случай обновляем списки в фоне.
      if (newCheckType == 'dock') {
        await loadOrders(isSilent: true);
      }

      return true;
    } catch (e) {
      Logger.e('Ошибка при смене транспортного статуса', e);
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deliverOrder(int orderId) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      await client.confirmDeliveryAsync(orderId);
      await loadOrders(isSilent: true); // Обновляем списки после успешной доставки
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> generatePickupQr() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user?.employeeId == null) return null;
      
      final client = ref.read(apiClientProvider);
      return await client.getCourierPickupQrAsync(user!.employeeId!);
    } catch (e) {
      Logger.e('Ошибка генерации QR', e);
      return null;
    }
  }
}