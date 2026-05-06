// lib/screens/home/order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/services/order_service.dart';
import 'package:helper_app/core/network/api_client.dart'; 
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; 
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.invalidate(orderDetailsProvider(widget.orderId));
      }
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

  /// Метод получения QR-кода с защитой от блокировки потока
  Future<void> _showPickupQrCode(BuildContext context, int orderId) async {
    // Используем локальный навигатор, чтобы избежать проблем с контекстом
    final navigator = Navigator.of(context, rootNavigator: true);

    try {
      // 1. Показываем лоадер
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
        ),
      );

      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.getAsync('Orders/$orderId/pickup-qr');
      
      // 2. Закрываем лоадер сразу после получения ответа
      navigator.pop();

      if (response != null && response['qrToken'] != null) {
        final String qrToken = response['qrToken'];
        
        // 3. Небольшая задержка перед открытием нового диалога для стабильности UI
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (mounted) {
          _showQrDialog(context, qrToken);
        }
      } else {
        throw 'Токен не найден в ответе сервера';
      }
    } catch (e) {
      // Пытаемся закрыть лоадер, если он всё еще висит
      if (navigator.canPop()) navigator.pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  void _showQrDialog(BuildContext context, String qrToken) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Код получения',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          // Фиксируем ширину, чтобы избежать пересчетов layout
          width: 250, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Покажите этот код сотруднику',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: 250.0, // Слегка увеличим размер (было 200)
                  errorCorrectionLevel: QrErrorCorrectLevel.L, // ВАЖНО: Низкий уровень коррекции
                  backgroundColor: Colors.white, // Гарантируем контрастный фон
                  padding: const EdgeInsets.all(12), // Гарантируем "тихую зону" вокруг кода
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Код действителен до конца дня',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть', style: TextStyle(color: Color(0xFF7C3AED))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(orderDetailsProvider(widget.orderId));

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: Text('Заказ #${widget.orderId}', 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(orderDetailsProvider(widget.orderId)),
          ),
        ],
      ),
      body: detailsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ошибка: $err', style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(orderDetailsProvider(widget.orderId)),
                child: const Text('Повторить'),
              )
            ],
          ),
        ),
        data: (order) {
          final formattedTime = order.deliveryDate != null 
              ? DateFormat('dd.MM.yyyy HH:mm').format(order.deliveryDate!.toLocal()) 
              : 'Не назначено';

          final bool canShowQrCode = order.status == 'Ready' || 
                                    (order.status == 'InTransit' && order.deliveryType == 'Delivery') ||
                                    (order.status == 'Assembly' && order.deliveryType == 'Express');

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(orderDetailsProvider(widget.orderId).future),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInfoCard(
                  title: 'Информация о доставке',
                  children: [
                    _buildDetailRow('Статус', _translateStatus(order.status), isHighlight: true),
                    _buildDetailRow('Тип', _translateDeliveryType(order.deliveryType)),
                    _buildDetailRow('Время', formattedTime),
                    if (order.destinationAddress?.isNotEmpty ?? false)
                      _buildDetailRow('Адрес', order.destinationAddress!),
                  ],
                ),
                
                if (canShowQrCode) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showPickupQrCode(context, order.orderId),
                      icon: const Icon(Icons.qr_code, color: Colors.white),
                      label: const Text('Показать код получения', 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                _buildInfoCard(
                  title: 'Состав заказа',
                  children: [
                    if (order.positions.isEmpty)
                      const Text('Позиции не найдены', style: TextStyle(color: Colors.white70))
                    else
                      ...order.positions.map((pos) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text(pos.itemName ?? 'Товар', style: const TextStyle(color: Colors.white))),
                            Expanded(flex: 1, child: Text('${pos.quantity} шт.', style: const TextStyle(color: Colors.white54))),
                            Expanded(flex: 2, child: Text('${pos.price.toStringAsFixed(0)} ₽', textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      )),
                    const Divider(color: Colors.white12, height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Итого', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('${order.totalPrice.toStringAsFixed(0)} ₽', style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                if (order.status == 'Completed')
                  OutlinedButton.icon(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => ComplaintBottomSheet(order: order),
                    ),
                    icon: const Icon(Icons.report_problem_outlined, color: Colors.redAccent),
                    label: const Text('Сообщить о проблеме', style: TextStyle(color: Colors.redAccent)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.white54))),
          Expanded(child: Text(value, style: TextStyle(color: isHighlight ? const Color(0xFF7C3AED) : Colors.white, fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal))),
        ],
      ),
    );
  }
}