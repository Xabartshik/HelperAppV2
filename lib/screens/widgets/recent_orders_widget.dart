import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/services/order_service.dart';
import 'package:intl/intl.dart';

class RecentOrdersWidget extends ConsumerStatefulWidget {
  final int customerId;
  
  const RecentOrdersWidget({Key? key, required this.customerId}) : super(key: key);

  @override
  ConsumerState<RecentOrdersWidget> createState() => _RecentOrdersWidgetState();
}

class _RecentOrdersWidgetState extends ConsumerState<RecentOrdersWidget> {

  @override
  void initState() {
    super.initState();
    // Принудительное обновление при загрузке виджета
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

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(customerOrdersProvider(widget.customerId));

    return ordersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
      error: (err, stack) {
        if (err.toString().contains('Ресурс не найден')) {
          return _buildEmptyState();
        }
        return Center(
          child: Column(
            children: [
              const Text('Ошибка загрузки', style: TextStyle(color: Colors.redAccent)),
              TextButton.icon(
                onPressed: () => ref.invalidate(customerOrdersProvider(widget.customerId)),
                icon: const Icon(Icons.refresh, color: Color(0xFF7C3AED), size: 18),
                label: const Text('Повторить', style: TextStyle(color: Color(0xFF7C3AED))),
              )
            ],
          )
        );
      },
      data: (orders) {
        if (orders.isEmpty) {
          return _buildEmptyState();
        }

        final recentOrders = orders.take(3).toList();

        return Column(
          children: recentOrders.map((order) {
            final localTime = order.deliveryDate?.toLocal();
            final formattedTime = localTime != null ? DateFormat('dd.MM HH:mm').format(localTime) : '--:--';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  'Заказ #${order.orderId}', 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        _translateStatus(order.status), 
                        style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w500)
                      ),
                      const Text(' • ', style: TextStyle(color: Colors.white38)),
                      Text(
                        formattedTime, 
                        style: const TextStyle(color: Colors.white70)
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                onTap: () => context.push('/customer/orders/details/${order.orderId}'),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: const [
          Icon(Icons.inventory_2_outlined, color: Color(0xFFA1A1AA), size: 48),
          SizedBox(height: 12),
          Text('У вас пока нет активных заказов', style: TextStyle(color: Color(0xFFA1A1AA))),
        ],
      ),
    );
  }
}