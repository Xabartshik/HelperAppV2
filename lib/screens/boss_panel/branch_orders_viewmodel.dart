import 'dart:async';
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
    
    // Таймер для автоматического обновления данных раз в тридцать секунд
    final timer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadData(isSilent: true);
    });

    ref.onDispose(() {
      timer.cancel();
    });

    return BranchOrdersState();
  }

  Future<void> loadData({bool isSilent = false}) async {
    // Устанавливаем состояние загрузки
    if (!isSilent) {
      state = state.copyWith(isLoading: true);
    }
    
    // Получаем текущего пользователя для определения филиала
    final user = ref.read(currentUserProvider);
    
    if (user?.branchId == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      final client = ref.read(apiClientProvider); //

      // Используем специализированный метод API клиента
      // Он уже возвращает List<OrderDto>, поэтому ручной маппинг через .map() больше не нужен
      final List<OrderDto> orders = await client.getBranchOrdersAsync(user!.branchId!);
      
      state = state.copyWith(
        allOrders: orders, 
        isLoading: false,
      );
      
      // Применяем текущие фильтры и сортировку к полученным данным
      _applyFilters(); 
    } catch (e) {
      // В случае ошибки сбрасываем индикатор загрузки
      state = state.copyWith(isLoading: false);
      // Здесь можно добавить вызов Logger.e для отладки
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