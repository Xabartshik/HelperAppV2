import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import 'package:helper_app/core/network/api_client.dart';
import 'package:helper_app/core/services/order_service.dart';
import '../../core/services/auth_service.dart';

class CustomerHomeState {
  final bool isLoading;
  final String? errorMessage;
  // Здесь в будущем можно хранить список последних заказов
  // final List<OrderDto> recentOrders;

  const CustomerHomeState({
    this.isLoading = false,
    this.errorMessage,
  });

  CustomerHomeState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return CustomerHomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final customerHomeViewModelProvider =
    StateNotifierProvider<CustomerHomeViewModel, CustomerHomeState>((ref) {
  return CustomerHomeViewModel(ref);
});

class CustomerHomeViewModel extends StateNotifier<CustomerHomeState> {
  final Ref _ref;

  CustomerHomeViewModel(this._ref) : super(const CustomerHomeState());

  String get userName => _ref.read(currentUserProvider)?.firstName ?? 'Покупатель';

  Future<void> logout() async {
    await _ref.read(authServiceProvider).logoutAsync();
  }

  // Методы для обновления данных (будут реализованы при создании модулей заказов)
  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true);
    // Имитация загрузки
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
  }
}