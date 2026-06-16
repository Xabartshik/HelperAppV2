import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/services/order_service.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import 'package:intl/intl.dart';

enum OrderSortOption {
  newest('Сначала новые'),
  oldest('Сначала старые'),
  highestPrice('Сначала дорогие'),
  lowestPrice('Сначала дешевые');

  const OrderSortOption(this.label);
  final String label;
}

class AllOrdersScreen extends ConsumerStatefulWidget {
  final int customerId;
  const AllOrdersScreen({super.key, required this.customerId});

  @override
  ConsumerState<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends ConsumerState<AllOrdersScreen> {
  OrderSortOption _currentSort = OrderSortOption.newest;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Принудительное обновление при заходе на экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(customerOrdersProvider(widget.customerId));
    });

    // Запуск таймера автоматического обновления каждые 30 секунд
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        ref.invalidate(customerOrdersProvider(widget.customerId));
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'Created': return 'Создан';
      case 'Assembly': return 'Сборка';
      case 'Ready': return 'Готов к выдаче';
      case 'InTransit': return 'В пути';
      case 'Completed': return 'Завершен';
      case 'Cancelled': return 'Отменен';
      default: return status;
    }
  }

  String _translateDeliveryType(String type) {
    switch (type) {
      case 'Pickup': return 'Самовывоз';
      case 'Delivery': return 'Курьер';
      case 'Postamat': return 'Постамат';
      case 'Express': return 'Экспресс';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(customerOrdersProvider(widget.customerId));

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Мои заказы', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Обновить',
            onPressed: () {
              ref.invalidate(customerOrdersProvider(widget.customerId));
            },
          ),
          PopupMenuButton<OrderSortOption>(
            icon: const Icon(Icons.sort, color: Colors.white),
            tooltip: 'Сортировка',
            onSelected: (OrderSortOption option) {
              setState(() {
                _currentSort = option;
              });
            },
            itemBuilder: (BuildContext context) {
              return OrderSortOption.values.map((option) {
                return PopupMenuItem<OrderSortOption>(
                  value: option,
                  child: Row(
                    children: [
                      if (_currentSort == option)
                        const Icon(Icons.check, color: Color(0xFF7C3AED), size: 18)
                      else
                        const SizedBox(width: 18),
                      const SizedBox(width: 8),
                      Text(option.label, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList();
            },
            color: const Color(0xFF1C1C1E),
          ),
        ],
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
        error: (err, stack) {
          if (err.toString().contains('Ресурс не найден')) {
            return _buildEmptyState();
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ошибка: $err', style: const TextStyle(color: Colors.redAccent)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(customerOrdersProvider(widget.customerId)),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Повторить', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
              ],
            ),
          );
        },
        data: (orders) {
          if (orders.isEmpty) {
            return _buildEmptyState();
          }

          final sortedOrders = List<OrderDto>.from(orders);
          switch (_currentSort) {
            case OrderSortOption.newest:
              sortedOrders.sort((a, b) {
                final dateCompare = (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                    .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
                if (dateCompare != 0) return dateCompare;
                return b.orderId.compareTo(a.orderId);
              });
              break;
            case OrderSortOption.oldest:
              sortedOrders.sort((a, b) {
                final dateCompare = (a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
                    .compareTo(b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
                if (dateCompare != 0) return dateCompare;
                return a.orderId.compareTo(b.orderId);
              });
              break;
            case OrderSortOption.highestPrice:
              sortedOrders.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
              break;
            case OrderSortOption.lowestPrice:
              sortedOrders.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
              break;
          }

          return RefreshIndicator(
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFF1C1C1E),
            onRefresh: () async {
              return ref.refresh(customerOrdersProvider(widget.customerId).future);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                final localTime = order.deliveryDate?.toLocal();
                final formattedTime = localTime != null ? DateFormat('dd.MM.yyyy HH:mm').format(localTime) : '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    title: Text(
                      'Заказ #${order.orderId}', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${_translateStatus(order.status)} • ${_translateDeliveryType(order.deliveryType)}\n$formattedTime', 
                        style: const TextStyle(color: Colors.white70, height: 1.4)
                      ),
                    ),
                    trailing: Text(
                      '${order.totalPrice.toStringAsFixed(0)} ₽', 
                      style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    isThreeLine: true,
                    onTap: () {
                      context.push('/customer/orders/details/${order.orderId}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inventory_2_outlined, color: Colors.white24, size: 64),
          SizedBox(height: 16),
          Text('История пуста', style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }
}