import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/services/order_service.dart';
import 'package:intl/intl.dart';
// Импорт виджета для подачи жалобы
import 'package:helper_app/screens/widgets/complaint_bottom_sheet.dart'; 

class OrderDetailsScreen extends ConsumerStatefulWidget {
  final int orderId;
  
  const OrderDetailsScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  
  @override
  void initState() {
    super.initState();
    // Принудительное обновление данных при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(orderDetailsProvider(widget.orderId));
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
      case 'Delivery': return 'Курьерская доставка';
      case 'Postamat': return 'Доставка в постамат';
      case 'Express': return 'Экспресс-доставка';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(orderDetailsProvider(widget.orderId));

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: Text(
          'Заказ #${widget.orderId}', 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Обновить',
            onPressed: () {
              ref.invalidate(orderDetailsProvider(widget.orderId));
            },
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED))
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ошибка: $err', style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(orderDetailsProvider(widget.orderId)),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Повторить', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            ],
          ),
        ),
        data: (order) {
          final localTime = order.deliveryDate?.toLocal();
          final formattedTime = localTime != null 
              ? DateFormat('dd.MM.yyyy HH:mm').format(localTime) 
              : 'Не назначено';

          return RefreshIndicator(
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFF1C1C1E),
            onRefresh: () async {
              return ref.refresh(orderDetailsProvider(widget.orderId).future);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                _buildInfoCard(
                  context,
                  title: 'Информация о доставке',
                  children: [
                    _buildDetailRow('Статус', _translateStatus(order.status), isHighlight: true),
                    _buildDetailRow('Тип', _translateDeliveryType(order.deliveryType)),
                    _buildDetailRow('Время', formattedTime),
                    if (order.destinationAddress != null && order.destinationAddress!.isNotEmpty)
                      _buildDetailRow('Адрес', order.destinationAddress!),
                  ],
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  context,
                  title: 'Состав заказа',
                  children: [
                    if (order.positions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('Позиции не найдены', style: TextStyle(color: Colors.white70)),
                      )
                    else
                      ...order.positions.map((pos) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                pos.itemName ?? 'Неизвестный товар',
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${pos.quantity} шт.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white54, fontSize: 14),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${pos.price.toStringAsFixed(0)} ₽',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Colors.white12, height: 24),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого', 
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        Text(
                          '${order.totalPrice.toStringAsFixed(0)} ₽', 
                          style: const TextStyle(
                            color: Color(0xFF7C3AED), 
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Кнопка жалобы (только для завершенных заказов)
                if (order.status == 'Completed')
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, 
                          backgroundColor: Colors.transparent,
                          builder: (context) => ComplaintBottomSheet(order: order),
                        );
                      },
                      icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
                      label: const Text(
                        'Сообщить о проблеме с заказом', 
                        style: TextStyle(color: Colors.redAccent, fontSize: 16)
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.redAccent.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isHighlight ? const Color(0xFF7C3AED) : Colors.white,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}