import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'courier_route_builder_viewmodel.dart';

class CourierRouteBuilderScreen extends ConsumerWidget {
  const CourierRouteBuilderScreen({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _cardBg = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(courierRouteBuilderViewModelProvider);
    final vm = ref.read(courierRouteBuilderViewModelProvider.notifier);

    if (state.isLoading && state.couriers.isEmpty && state.availableOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor));
    }

    // Получаем данные о весе и курьере из ViewModel
    final courier = vm.selectedCourier;
    final totalWeight = vm.selectedTotalWeightKg;
    final maxWeight = courier?.maxWeightKg ?? 0;
    final bool isOverweight = maxWeight > 0 && totalWeight > maxWeight;

    return Column(
      children: [
        // 1. ВЫБОР КУРЬЕРА И ИНФО О ТРАНСПОРТЕ
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF1C1C1E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                value: state.selectedCourierId,
                decoration: InputDecoration(
                  labelText: 'Назначить курьера',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: _cardBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                dropdownColor: _cardBg,
                style: const TextStyle(color: Colors.white),
                items: state.couriers.map((c) => DropdownMenuItem(value: c.employeeId, child: Text(c.fullName))).toList(),
                onChanged: (val) => vm.selectCourier(val),
              ),
              
              if (courier != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_shipping, color: _primaryColor, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(courier.vehicleName ?? 'Транспорт не указан', 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Макс. вес: ${maxWeight > 0 ? '$maxWeight кг' : 'Не ограничен'}', 
                                style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        // 2. СПИСОК ЗАКАЗОВ
// 2. СПИСОК ЗАКАЗОВ
        Expanded(
          child: state.availableOrders.isEmpty
              ? const Center(child: Text('Нет доступных заказов', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.availableOrders.length,
                  itemBuilder: (context, index) {
                    final order = state.availableOrders[index];
                    final isSelected = state.selectedOrderIds.contains(order.orderId);
                    
                    // Расчет веса конкретного заказа
                    final orderWeight = order.items.fold<double>(0.0, (sum, item) => sum + (item.weightKg * item.quantity));
                    
                    // Форматируем время доставки (если оно есть)
                    String deliveryTimeString = '';
                    if (order.deliveryDate != null) {
                       final dt = order.deliveryDate!.toLocal();
                       // Формат: День.Месяц до Часы:Минуты
                       deliveryTimeString = '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')} до ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                    }

                    return Card(
                      color: _cardBg,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isSelected ? _primaryColor : Colors.transparent, width: 2),
                      ),
                      child: CheckboxListTile(
                        value: isSelected,
                        activeColor: _primaryColor,
                        checkColor: Colors.white,
                        onChanged: (checked) => vm.toggleOrderSelection(order.orderId, checked == true),
                        title: Text('Заказ #${order.orderId}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white54, size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      order.destinationAddress ?? 'Без адреса', 
                                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (deliveryTimeString.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, color: Colors.orangeAccent, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      deliveryTimeString, 
                                      style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text('Вес: ${orderWeight.toStringAsFixed(1)} кг', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                            ],
                          ),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
        ),
        // 3. ПОДВАЛ С ИНДИКАТОРОМ ВЕСА И КНОПКОЙ
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF1C1C1E),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (maxWeight > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Загрузка: ${totalWeight.toStringAsFixed(1)} / $maxWeight кг', 
                        style: TextStyle(color: isOverweight ? Colors.redAccent : Colors.white54, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        '${((totalWeight / maxWeight) * 100).toStringAsFixed(0)}%', 
                        style: TextStyle(color: isOverweight ? Colors.redAccent : _primaryColor, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: maxWeight > 0 ? (totalWeight / maxWeight).clamp(0.0, 1.0) : 0,
                    backgroundColor: Colors.white10,
                    color: isOverweight ? Colors.redAccent : _primaryColor,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 16),
                ],
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // Кнопка блокируется при перегрузе или отсутствии выбора
                    onPressed: (state.selectedCourierId != null && state.selectedOrderIds.isNotEmpty && !state.isLoading && !isOverweight)
                        ? () async {
                            final scaffoldMessenger = ScaffoldMessenger.of(context);
                            final (success, message) = await vm.createRoute();
                            scaffoldMessenger.showSnackBar(
                              SnackBar(content: Text(message), backgroundColor: success ? Colors.green : Colors.red)
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOverweight ? Colors.redAccent : _primaryColor,
                      disabledBackgroundColor: _cardBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: state.isLoading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            isOverweight ? 'ПЕРЕГРУЗ' : 'Сформировать маршрут', 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}