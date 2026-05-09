import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/services/auth_service.dart';
import '../../core/network/api_client.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import '../../core/utils/logger.dart';

class CourierRouteBuilderState {
  final bool isLoading;
  final String errorMessage;
  final List<AvailableEmployeeDto> couriers;
  final List<AvailableOrderDto> availableOrders;
  final Set<int> selectedOrderIds;
  final int? selectedCourierId;

  const CourierRouteBuilderState({
    this.isLoading = false,
    this.errorMessage = '',
    this.couriers = const [],
    this.availableOrders = const [],
    this.selectedOrderIds = const {},
    this.selectedCourierId,
  });

  CourierRouteBuilderState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<AvailableEmployeeDto>? couriers,
    List<AvailableOrderDto>? availableOrders,
    Set<int>? selectedOrderIds,
    int? selectedCourierId,
    bool clearCourier = false,
  }) {
    return CourierRouteBuilderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      couriers: couriers ?? this.couriers,
      availableOrders: availableOrders ?? this.availableOrders,
      selectedOrderIds: selectedOrderIds ?? this.selectedOrderIds,
      selectedCourierId: clearCourier ? null : (selectedCourierId ?? this.selectedCourierId),
    );
  }
}

final courierRouteBuilderViewModelProvider = AutoDisposeNotifierProvider<CourierRouteBuilderViewModel, CourierRouteBuilderState>(
  () => CourierRouteBuilderViewModel(),
);

class CourierRouteBuilderViewModel extends AutoDisposeNotifier<CourierRouteBuilderState> {
  @override
  CourierRouteBuilderState build() {
    Future.microtask(() => loadData());
    return const CourierRouteBuilderState();
  }

  // Получить объект выбранного курьера
  AvailableEmployeeDto? get selectedCourier {
    if (state.selectedCourierId == null) return null;
    return state.couriers.firstWhere((c) => c.employeeId == state.selectedCourierId);
  }

  // Посчитать общий вес всех выбранных заказов
  double get selectedTotalWeightKg {
    double total = 0;
    for (var orderId in state.selectedOrderIds) {
      final order = state.availableOrders.firstWhere((o) => o.orderId == orderId);
      for (var item in order.items) {
        total += (item.weightKg * item.quantity);
      }
    }
    return total;
  }

Future<void> loadData() async {
  state = state.copyWith(isLoading: true, errorMessage: '');
  try {
    final client = ref.read(apiClientProvider);
    
    final results = await Future.wait([
      client.getBossPanelAvailableCouriersAsync(),
      client.getBossPanelReadyOrdersAsync(),
    ]);

    // Получаем и сортируем курьеров
    final couriersList = results[0] as List<AvailableEmployeeDto>;
    couriersList.sort((a, b) {
      if (a.isOnRoute == b.isOnRoute) return 0;
      return a.isOnRoute ? 1 : -1; // Сначала те, кто на базе (false), потом те, кто в пути (true)
    });

    state = state.copyWith(
      isLoading: false,
      couriers: couriersList,
      availableOrders: results[1] as List<AvailableOrderDto>,
    );
  } catch (e) {
    Logger.e('Ошибка загрузки данных для формирования маршрута: $e');
    state = state.copyWith(isLoading: false, errorMessage: 'Ошибка сети: $e');
  }
}

  void toggleOrderSelection(int orderId, bool isSelected) {
    final newSet = Set<int>.from(state.selectedOrderIds);
    if (isSelected) {
      newSet.add(orderId);
    } else {
      newSet.remove(orderId);
    }
    state = state.copyWith(selectedOrderIds: newSet);
  }

  void selectCourier(int? courierId) {
    state = state.copyWith(selectedCourierId: courierId, clearCourier: courierId == null);
  }

  Future<(bool, String)> createRoute() async {
    if (state.selectedCourierId == null || state.selectedOrderIds.isEmpty) {
      return (false, "Выберите курьера и хотя бы один заказ");
    }

    // --- ПРОВЕРКА ВМЕСТИМОСТИ ---
    final courier = selectedCourier;
    if (courier?.maxWeightKg != null && courier!.maxWeightKg! > 0) {
      if (selectedTotalWeightKg > courier.maxWeightKg!) {
        return (false, "Ошибка: Превышена максимальная грузоподъемность курьера (${courier.maxWeightKg} кг)!");
      }
    }
    // ----------------------------

    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      final currentUser = ref.read(currentUserProvider);

      if (currentUser?.branchId == null) throw Exception('Филиал не определен');

      final taskId = await client.initCourierBatchHandoverAsync(
        state.selectedOrderIds.toList(),
        state.selectedCourierId!,
        currentUser!.branchId!,
      );

      if (taskId != null) {
        // Успех! Сбрасываем выбранные заказы и курьера, обновляем список
        state = state.copyWith(selectedOrderIds: {}, clearCourier: true);
        await loadData();
        return (true, 'Маршрут сформирован! Создана задача на отгрузку со склада.');
      }
      return (false, 'Бэкенд не вернул TaskId');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return (false, e.toString().replaceAll('ApiException: ', ''));
    }
  }
}