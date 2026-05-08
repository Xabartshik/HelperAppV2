import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/network/api_client.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/models/order/order_dto.dart';
import '../../core/services/auth_service.dart';
import 'courier_viewmodel.dart';

class CourierHomePage extends ConsumerStatefulWidget {
  const CourierHomePage({super.key});

  @override
  ConsumerState<CourierHomePage> createState() => _CourierHomePageState();
}

class _CourierHomePageState extends ConsumerState<CourierHomePage> with SingleTickerProviderStateMixin {
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Widget _buildShiftBanner(BuildContext context, CourierState state, WidgetRef ref) {
    final isActive = state.isShiftActive;
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Используем зеленый для активной смены, фиолетовый для неактивной
        color: isActive ? Colors.green.shade800 : const Color(0xFF6D28D9), 
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Смена активна' : 'Смена не начата',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  isActive ? 'Вы на линии. Не забудьте отметиться в конце дня.' : 'Отсканируйте QR на проходной для старта.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
ElevatedButton(
            onPressed: () async {
              final String? rawPayload = await context.push<String>('/shift-scanner');
              
              if (rawPayload != null && rawPayload.isNotEmpty && context.mounted) {
                String token = rawPayload;
                int branchId = ref.read(currentUserProvider)?.branchId ?? 1;

                try {
                  final Map<String, dynamic> decoded = jsonDecode(rawPayload);
                  if (decoded.containsKey('p')) token = decoded['p'].toString();
                  if (decoded.containsKey('b')) branchId = int.tryParse(decoded['b'].toString()) ?? branchId;
                } catch (_) {}

                final checkType = isActive ? 'out' : 'in'; 
                
                // ЖДЕМ РЕЗУЛЬТАТ: true или false
                final success = await ref.read(courierViewModelProvider.notifier).scanShiftQr(token, branchId, checkType);
                
                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isActive ? 'Смена успешно завершена!' : 'Смена успешно начата!'), 
                        backgroundColor: Colors.green
                      )
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Не удалось поставить отметку'), 
                        backgroundColor: Colors.redAccent
                      )
                    );
                  }
                }
              } else {
                ref.read(courierViewModelProvider.notifier).loadOrders();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: isActive ? Colors.green.shade800 : const Color(0xFF6D28D9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(isActive ? 'Завершить' : 'Начать', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


Widget _buildTransportBanner(BuildContext context, CourierState state, WidgetRef ref) {
    final lastType = state.currentCheck?.checkType ?? 'out';
    
    // Если смена закрыта ('out') - не показываем этот баннер вообще
    if (lastType == 'out') return const SizedBox.shrink();

    final isDriving = lastType == 'dispatch';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDriving ? Colors.orange.shade800 : Colors.blue.shade800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(isDriving ? Icons.local_shipping : Icons.warehouse, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isDriving ? 'НА МАРШРУТЕ' : 'НА БАЗЕ (ПАНДУС)',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: isDriving ? Colors.orange.shade800 : Colors.blue.shade800,
              elevation: 0,
            ),
            onPressed: state.isLoading ? null : () async {
               // Переключаем статус: если ехал -> на базу, если был на базе -> в путь
               final newStatus = isDriving ? 'dock' : 'dispatch';
               await ref.read(courierViewModelProvider.notifier).setTransportStatus(newStatus);
            },
            child: state.isLoading 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(isDriving ? 'ВЕРНУЛСЯ' : 'В ПУТЬ!'),
          ),
        ],
      ),
    );
  }

void _showQrCodeDialog(BuildContext context, WidgetRef ref) async {
    // 1. Захватываем навигатор заранее, как в рабочем экране
    final navigator = Navigator.of(context, rootNavigator: true);
    final vm = ref.read(courierViewModelProvider.notifier);

    try {
      // 2. Показываем простой лоадер
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (c) => const Center(
          child: CircularProgressIndicator(color: _primaryColor)
        ),
      );

      // 3. Получаем данные
      final qrData = await vm.generatePickupQr();
      
      // 4. МГНОВЕННО закрываем лоадер
      navigator.pop();

      // 5. Ждем завершения анимации закрытия лоадера! (Секрет успеха)
      await Future.delayed(const Duration(milliseconds: 100));

      if (!context.mounted) return;

      final String? token = qrData?['token'] ?? qrData?['Token'];

      if (token == null) {
        throw 'Токен не найден в ответе сервера';
      }

      // 6. Показываем сам QR-код с оптимизированным рендерингом
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ваш пропуск', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          content: SizedBox(
            width: 250, // Фиксируем ширину для избежания пересчетов layout
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Покажите этот код кладовщику для приемки груза в машину.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: QrImageView(
                    data: token, 
                    version: QrVersions.auto, 
                    size: 250.0,
                    errorCorrectionLevel: QrErrorCorrectLevel.L, // ВАЖНО: защита от зависания при длинных токенах
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Код действителен 5 минут', style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ЗАКРЫТЬ', style: TextStyle(color: Colors.white54))),
          ],
        ),
      );
    } catch (e) {
      // Страховка: если что-то упало до закрытия лоадера
      if (navigator.canPop()) navigator.pop();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.redAccent)
        );
      }
    }
  }


@override
Widget build(BuildContext context) {
  final state = ref.watch(courierViewModelProvider);
  final user = ref.watch(currentUserProvider);

  return Scaffold(
    backgroundColor: _bgOffBlack,
    appBar: AppBar(
      backgroundColor: const Color(0xFF1C1C1E),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user?.fullName ?? 'Курьер',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Логистика / Служба доставки',
            style: TextStyle(fontSize: 12, color: Colors.white54),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code, color: Colors.white),
          tooltip: 'Мой QR',
          onPressed: () => _showQrCodeDialog(context, ref),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent),
          onPressed: () => ref.read(authServiceProvider).logoutAsync(),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: _primaryColor,
        labelColor: _primaryColor,
        unselectedLabelColor: Colors.white54,
        tabs: [
          Tab(text: 'К ПОГРУЗКЕ (${state.readyOrders.length})', icon: const Icon(Icons.warehouse)),
          Tab(text: 'В ПУТИ (${state.inTransitOrders.length})', icon: const Icon(Icons.local_shipping)),
        ],
      ),
    ),
    body: Column(
      children: [
        // Отображаем баннер смены, если данные загружены или уже есть информация о чеке (смене)
        if (!state.isLoading || state.currentCheck != null)
          _buildShiftBanner(context, state, ref),
          _buildTransportBanner(context, state, ref),

        const SizedBox(height: 8),

        // Занимаем оставшееся пространство списком заказов или индикатором загрузки
        Expanded(
          child: state.isLoading && state.readyOrders.isEmpty && state.inTransitOrders.isEmpty
              ? const Center(child: CircularProgressIndicator(color: _primaryColor))
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrderList(state.readyOrders, false, ref),
                    _buildOrderList(state.inTransitOrders, true, ref),
                  ],
                ),
        ),
      ],
    ),
  );
}

  Widget _buildOrderList(List<OrderDto> orders, bool isInTransit, WidgetRef ref) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          isInTransit ? 'Багажник пуст. Заберите заказы со склада.' : 'Нет заказов к погрузке на складе.',
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      color: _primaryColor,
      onRefresh: () async => ref.read(courierViewModelProvider.notifier).loadOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _bgGray900,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isInTransit ? _primaryColor.withOpacity(0.5) : Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Заказ #${order.orderId}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${order.totalPrice.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white54, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(order.destinationAddress ?? 'Адрес не указан', style: const TextStyle(color: Colors.white70, fontSize: 14))),
                  ],
                ),
if (isInTransit) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Кнопка "Отказ"
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () => _confirmRejection(context, ref, order.orderId),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.15),
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Icon(Icons.close, color: Colors.redAccent),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Кнопка "Доставлено"
                      Expanded(
                        flex: 4,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmDelivery(context, ref, order.orderId),
                          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                          label: const Text('ДОСТАВЛЕНО', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      )
                    ],
                  )
                ] else ...[
                   const SizedBox(height: 12),
                   const Text('Ожидает выдачи кладовщиком', style: TextStyle(color: Colors.orangeAccent, fontSize: 12, fontStyle: FontStyle.italic)),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmRejection(BuildContext context, WidgetRef ref, int orderId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Отказ клиента?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Клиент отказался от заказа или его нет на месте? Товары останутся в багажнике для возврата на склад.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('ОТМЕНА', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('ДА, ОТКАЗ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator(color: _primaryColor)),
      );

      final success = await ref.read(courierViewModelProvider.notifier).rejectOrder(orderId);
      
      if (context.mounted) {
        Navigator.pop(context); // Снимаем лоадер
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Отказ зафиксирован. Товар в багажнике.'), backgroundColor: Colors.orange)
          );
            } else {
          // Читаем реальную ошибку из ViewModel!
          final errorMsg = ref.read(courierViewModelProvider).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg.isNotEmpty ? errorMsg : 'Ошибка при фиксации отказа'), backgroundColor: Colors.redAccent)
          );
        }
      }
    }
  }

void _confirmDelivery(BuildContext context, WidgetRef ref, int orderId) async {
    final String? customerQrToken = await context.push<String>('/customer-qr-scanner');
    
    if (customerQrToken != null && customerQrToken.isNotEmpty && context.mounted) {
      final navigator = Navigator.of(context, rootNavigator: true);
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (c) => const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator(color: _primaryColor)),
        ),
      );

      try {
        final user = ref.read(currentUserProvider);
        final branchId = user?.branchId ?? 1;
        final workerId = user?.employeeId ?? 0;
        
        // ПЕРЕДАЕМ orderId ЧЕТВЕРТЫМ ПАРАМЕТРОМ!
        final taskId = await ref.read(apiClientProvider)
            .initCustomerHandoverAsync(customerQrToken, workerId, branchId, orderId);
        
        navigator.pop();
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (!context.mounted) return;

        if (taskId != null) {
          // Гарантированно правильный путь
          context.push('/order-handover/active', extra: {
            'assignmentId': 0, 
            'taskId': taskId,
          }).then((_) {
             ref.read(courierViewModelProvider.notifier).loadOrders();
          });
        } else {
          throw 'Сервер не вернул ID задачи выдачи';
        }
      } catch (e) {
        if (navigator.canPop()) navigator.pop();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.redAccent)
          );
        }
      }
    }
  }


}