import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/services/order_service.dart';
import 'package:intl/intl.dart';

class AllOrdersScreen extends ConsumerStatefulWidget {
  final int customerId;
  const AllOrdersScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  ConsumerState<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends ConsumerState<AllOrdersScreen> {
  
  @override
  void initState() {
    super.initState();
    // Принудительное обновление при заходе на экран
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(customerOrdersProvider(widget.customerId));
    });
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'Created': return 'Создан';
      case 'Assembly': return 'Сборка';
      case 'Ready': return 'Готов к выдаче';
      case 'InTransit': return 'В пути';
      case 'Completed': return 'Завершен';
      case 'Canceled': return 'Отменен';
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

          return RefreshIndicator(
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFF1C1C1E),
            onRefresh: () async {
              return ref.refresh(customerOrdersProvider(widget.customerId).future);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
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