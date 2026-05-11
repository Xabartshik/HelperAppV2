import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';

enum OrderSortType { date, type, status }

class BranchOrdersState {
  final bool isLoading;
  final List<OrderDto> allOrders;
  final List<OrderDto> filteredOrders;
  final OrderSortType sortType;
  final DateTimeRange? dateRange;

  BranchOrdersState({
    this.isLoading = false,
    this.allOrders = const [],
    this.filteredOrders = const [],
    this.sortType = OrderSortType.date,
    this.dateRange,
  });

  BranchOrdersState copyWith({
    bool? isLoading,
    List<OrderDto>? allOrders,
    List<OrderDto>? filteredOrders,
    OrderSortType? sortType,
    DateTimeRange? dateRange,
  }) {
    return BranchOrdersState(
      isLoading: isLoading ?? this.isLoading,
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      sortType: sortType ?? this.sortType,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

final branchOrdersViewModelProvider = AutoDisposeNotifierProvider<BranchOrdersViewModel, BranchOrdersState>(
  () => BranchOrdersViewModel(),
);

class BranchOrdersViewModel extends AutoDisposeNotifier<BranchOrdersState> {
  @override
  BranchOrdersState build() {
    Future.microtask(() => loadData());
    return BranchOrdersState();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    final user = ref.read(currentUserProvider);
    if (user?.branchId == null) return;

    try {
      final client = ref.read(apiClientProvider);
      // Вызываем эндпоинт, созданный в предыдущем шаге
      final List<dynamic> response = await client.getAsync('v1/Orders/branch/${user!.branchId}');
      final orders = response.map((json) => OrderDto.fromJson(json)).toList();
      
      state = state.copyWith(allOrders: orders, isLoading: false);
      _applyFilters();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateSort(OrderSortType type) {
    state = state.copyWith(sortType: type);
    _applyFilters();
  }

  void updateDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
    _applyFilters();
  }

  void _applyFilters() {
    var list = List<OrderDto>.from(state.allOrders);

    // 1. Фильтрация по дате создания
    if (state.dateRange != null) {
      list = list.where((o) {
        if (o.createdAt == null) return false;
        return o.createdAt!.isAfter(state.dateRange!.start) &&
               o.createdAt!.isBefore(state.dateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // 2. Сортировка
    switch (state.sortType) {
      case OrderSortType.date:
        list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
        break;
      case OrderSortType.type:
        list.sort((a, b) => a.deliveryType.compareTo(b.deliveryType));
        break;
      case OrderSortType.status:
        list.sort((a, b) => a.status.compareTo(b.status));
        break;
    }

    state = state.copyWith(filteredOrders: list);
  }
}