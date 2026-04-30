import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import 'create_order_viewmodel.dart';

final createOrderViewModelProvider = ChangeNotifierProvider.autoDispose<CreateOrderViewModel>((ref) {
  final vm = CreateOrderViewModel(ref.read(apiClientProvider));
  Future.microtask(() => vm.initialize());
  return vm;
});

class CreateOrderPage extends ConsumerStatefulWidget {
  const CreateOrderPage({super.key});

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  final TextEditingController _branchSearchController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final Map<int, TextEditingController> _qtyControllers = {};

  // Строгая цветовая палитра из TaskSelectionScreen
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _accent = Color(0xFF5865F2);
  static const Color _textGray = Color(0xFF8E8E93);

  @override
  void dispose() {
    _searchController.dispose();
    for (var c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(createOrderViewModelProvider);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        backgroundColor: _bgGray950,
        title: const Text('Новый заказ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepIndicators(vm.currentStep),
          Expanded(
            child: vm.isLoading && vm.currentStep == 0
                ? const Center(child: CircularProgressIndicator(color: _accent))
                : _buildCurrentStepView(vm),
          ),
          _buildBottomBar(vm),
        ],
      ),
    );
  }

  Widget _buildStepIndicators(int currentStep) {
    final titles = ['Локация', 'Витрина', 'Логистика', 'Проверка'];
    return Container(
      color: _bgGray950,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          final isActive = index == currentStep;
          final isPassed = index < currentStep;
          Color color = _textGray;
          if (isActive) color = _accent;
          if (isPassed) color = Colors.green;

          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withOpacity(isActive || isPassed ? 0.2 : 0.1),
                  child: isPassed 
                    ? const Icon(Icons.check, size: 16, color: Colors.green)
                    : Text('${index + 1}', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 6),
                Text(titles[index], style: TextStyle(color: color, fontSize: 11, fontWeight: isActive ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStepView(CreateOrderViewModel vm) {
    switch (vm.currentStep) {
      case 0: return _buildStep1Location(vm);
      case 1: return _buildStep2Catalog(vm);
      case 2: return _buildStep3Logistics(vm);
      case 3: return _buildStep4Summary(vm);
      default: return const SizedBox();
    }
  }

  // --- ЗАГЛУШКА ПУСТОГО СОСТОЯНИЯ ---
  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _textGray, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // --- ШАГ 1: ЛОКАЦИЯ ---
Widget _buildStep1Location(CreateOrderViewModel vm) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _branchSearchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Поиск по городу или адресу...',
              hintStyle: const TextStyle(color: _textGray),
              filled: true,
              fillColor: _bgGray900,
              prefixIcon: const Icon(Icons.search, color: _textGray),
              suffixIcon: _branchSearchController.text.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, color: _textGray),
                    onPressed: () {
                      _branchSearchController.clear();
                      vm.filterBranches('');
                      setState(() {});
                    },
                  )
                : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (val) {
              vm.filterBranches(val);
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: vm.filteredBranches.isEmpty && !vm.isLoading
              ? _buildEmptyState(Icons.location_city, 'Филиалы по данному запросу не найдены.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vm.filteredBranches.length,
                  itemBuilder: (context, index) {
                    final b = vm.filteredBranches[index];
                    final isSelected = vm.selectedBranch?.branchId == b.branchId;
                    
                    return GestureDetector(
                      onTap: () => vm.selectBranch(b),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? _accent.withOpacity(0.1) : _bgGray900,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? _accent : Colors.transparent),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.business, color: isSelected ? _accent : _textGray),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(b.branchName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                                  if (b.address != null && b.address!.isNotEmpty) 
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(b.address!, style: const TextStyle(color: _textGray, fontSize: 12)),
                                    ),
                                ],
                              ),
                            ),
                            if (isSelected) const Icon(Icons.check_circle, color: _accent),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  // --- ШАГ 2: ВИТРИНА ---
  Widget _buildStep2Catalog(CreateOrderViewModel vm) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Поиск товаров...',
              hintStyle: const TextStyle(color: _textGray),
              filled: true,
              fillColor: _bgGray900,
              prefixIcon: const Icon(Icons.search, color: _textGray),
              suffixIcon: _searchController.text.isNotEmpty 
                ? IconButton(
                    icon: const Icon(Icons.clear, color: _textGray),
                    onPressed: () {
                      _searchController.clear();
                      vm.searchItems('');
                    },
                  )
                : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) => setState(() {}),
            onSubmitted: (value) => vm.searchItems(value),
          ),
        ),
        Expanded(
          child: vm.isLoading
              ? const Center(child: CircularProgressIndicator(color: _accent))
              : vm.availableItems.isEmpty
                  ? _buildEmptyState(Icons.inventory_2_outlined, 'В выбранном филиале нет товаров в наличии.')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vm.availableItems.length,
                      itemBuilder: (context, index) {
                        final item = vm.availableItems[index];
                        final qty = vm.cart[item.itemId] ?? 0;
                        return _buildItemCard(item, qty, vm);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildItemCard(AvailableItem item, int qty, CreateOrderViewModel vm) {
    if (!_qtyControllers.containsKey(item.itemId)) {
      _qtyControllers[item.itemId] = TextEditingController(text: qty.toString());
    } else if (int.tryParse(_qtyControllers[item.itemId]!.text) != qty) {
      _qtyControllers[item.itemId]!.text = qty.toString();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: qty > 0 ? _accent.withOpacity(0.3) : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500))),
              Text('${item.price.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory, color: _textGray, size: 14),
                  const SizedBox(width: 4),
                  Text('В наличии: ${item.availableQuantity} шт', style: const TextStyle(color: _textGray, fontSize: 13)),
                ],
              ),
              qty == 0
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(100, 36),
                      ),
                      onPressed: () => vm.updateCartQuantity(item.itemId, 1, item.availableQuantity),
                      child: const Text('Добавить', style: TextStyle(color: Colors.white, fontSize: 13)),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: _bgGray950,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _accent.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                            onPressed: () => vm.updateCartQuantity(item.itemId, -1, item.availableQuantity),
                          ),
                          SizedBox(
                            width: 36,
                            child: TextField(
                              controller: _qtyControllers[item.itemId],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                              onSubmitted: (val) {
                                vm.setManualQuantity(item.itemId, int.tryParse(val) ?? 0, item.availableQuantity);
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                            onPressed: () => vm.updateCartQuantity(item.itemId, 1, item.availableQuantity),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  // --- ШАГ 3: ЛОГИСТИКА ---
  Widget _buildStep3Logistics(CreateOrderViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Способ получения', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<DeliveryType>(
              value: vm.selectedDeliveryType,
              dropdownColor: _bgGray950,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: _textGray),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: DeliveryType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
              onChanged: (val) => vm.setDeliveryType(val!),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // --- АДРЕС ИЛИ ПОСТАМАТ ---
        if (vm.selectedDeliveryType == DeliveryType.postamat) ...[
          const Text('Выберите терминал', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          // ... (Код Dropdown постаматов остается прежним) ...
        ] else if (vm.selectedDeliveryType == DeliveryType.courier) ...[
          const Text('Адрес доставки', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Укажите город, улицу, дом, кв.'),
            onChanged: (val) => vm.setDestinationAddress(val),
          )
        ] else if (vm.selectedDeliveryType == DeliveryType.pickup || vm.selectedDeliveryType == DeliveryType.express) ...[
           // Адрес берется из филиала
           const Text('Адрес выдачи (Филиал)', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
           const SizedBox(height: 8),
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
             child: Row(
               children: [
                 const Icon(Icons.location_on, color: _accent, size: 20),
                 const SizedBox(width: 12),
                 Expanded(child: Text(vm.selectedBranch?.address ?? 'Адрес не указан', style: const TextStyle(color: Colors.white, fontSize: 15))),
               ],
             ),
           ),
        ],

        const SizedBox(height: 24),

        // --- ДАТА И ВРЕМЯ ---
        if (vm.selectedDeliveryType == DeliveryType.pickup) ...[
           const Text('Ожидаемое время самовывоза', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
           const SizedBox(height: 8),
           GestureDetector(
             onTap: () async {
                final minMinutes = ((vm.appConfig?.pickupWindowLimitHours ?? 0.5) * 60).toInt();
                final minTime = DateTime.now().add(Duration(minutes: minMinutes));
                final date = await showDatePicker(
                  context: context,
                  initialDate: minTime,
                  firstDate: minTime,
                  lastDate: DateTime.now().add(const Duration(days: 14)),
                  // ... theme builder ...
                );
                if (date != null && context.mounted) {
                  final time = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.fromDateTime(date.day == minTime.day ? minTime : date),
                    // ... theme builder ...
                  );
                  if (time != null) {
                    var selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                    // Жесткая проверка: нельзя выбрать время раньше чем через 30 минут
                    if (selected.isBefore(minTime)) {
                      selected = minTime;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Минимальное время на сборку - 30 минут.')));
                    }
                    vm.setDeliveryDate(selected);
                  }
                }
             },
             child: Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
               child: Row(
                 children: [
                   const Icon(Icons.access_time, color: _accent, size: 20),
                   const SizedBox(width: 12),
                   Text(
                     vm.deliveryDate == null 
                      ? 'Выберите дату и время' 
                      : '${vm.deliveryDate!.day.toString().padLeft(2, '0')}.${vm.deliveryDate!.month.toString().padLeft(2, '0')} в ${vm.deliveryDate!.hour.toString().padLeft(2, '0')}:${vm.deliveryDate!.minute.toString().padLeft(2, '0')}', 
                     style: TextStyle(color: vm.deliveryDate == null ? _textGray : Colors.white, fontSize: 16)
                   ),
                 ],
               ),
             ),
           ),
        ] else if (vm.selectedDeliveryType == DeliveryType.courier) ...[
           // Оставляем выбор даты и времени ТОЛЬКО для курьера
           const Text('Дата доставки', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
           const SizedBox(height: 8),
           GestureDetector(
             onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 14)),
                );
                if (date != null) vm.setDeliveryDate(date);
             },
             child: Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
               child: Row(
                 children: [
                   const Icon(Icons.calendar_month, color: _accent, size: 20),
                   const SizedBox(width: 12),
                   Text(
                     vm.deliveryDate == null ? 'Выберите дату' : '${vm.deliveryDate!.day.toString().padLeft(2, '0')}.${vm.deliveryDate!.month.toString().padLeft(2, '0')}.${vm.deliveryDate!.year}', 
                     style: TextStyle(color: vm.deliveryDate == null ? _textGray : Colors.white, fontSize: 16)
                   ),
                 ],
               ),
             ),
           ),
           
           if (vm.deliveryDate != null) ...[
              const SizedBox(height: 16),
              const Text('Окно доставки (Минимум 1 час на сборку)', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              if (vm.availableSlots.isEmpty)
                const Text('На выбранную дату нет доступных окон доставки', style: TextStyle(color: Colors.redAccent))
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DeliverySlot>(
                      value: vm.selectedSlot,
                      hint: const Text('Выберите время', style: TextStyle(color: _textGray)),
                      dropdownColor: _bgGray950,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      items: vm.availableSlots.map((s) => DropdownMenuItem(value: s, child: Text(s.name))).toList(),
                      onChanged: (val) => vm.setDeliverySlot(val!),
                    ),
                  ),
                ),
           ]
        ] else if (vm.selectedDeliveryType == DeliveryType.postamat) ...[
           // Для постамата выводим информационное сообщение вместо выбора времени
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: _accent.withOpacity(0.1), 
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: _accent.withOpacity(0.3))
             ),
             child: const Row(
               children: [
                 Icon(Icons.local_shipping_outlined, color: _accent, size: 24),
                 SizedBox(width: 16),
                 Expanded(
                   child: Text(
                     'Доставка в постамат осуществляется в течение 1-4 дней. Мы пришлем уведомление, когда заказ будет готов к выдаче.', 
                     style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4)
                   )
                 ),
               ],
             ),
           ),
        ],

        const SizedBox(height: 32),

        // Оплата
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _bgGray900, 
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Итого к оплате', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('${vm.cartTotalPrice.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(color: Colors.white12, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.credit_card, color: _textGray, size: 20),
                      SizedBox(width: 8),
                      Text('Оплатить сейчас', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  Switch(
                    value: vm.prepayNow,
                    activeColor: _accent,
                    onChanged: (val) => vm.togglePrepay(val),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // --- ШАГ 4: ПРОВЕРКА И ИТОГ ---
  Widget _buildStep4Summary(CreateOrderViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (vm.postamatCapacityError != null)
           Container(
             padding: const EdgeInsets.all(16),
             margin: const EdgeInsets.only(bottom: 24),
             decoration: BoxDecoration(
               color: Colors.redAccent.withOpacity(0.1), 
               borderRadius: BorderRadius.circular(12), 
               border: Border.all(color: Colors.redAccent.withOpacity(0.5))
             ),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                 const SizedBox(width: 12),
                 Expanded(child: Text(vm.postamatCapacityError!, style: const TextStyle(color: Colors.redAccent, height: 1.4))),
               ],
             ),
           ),

        const Text('Информация о заказе', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildSummaryRow('Склад отгрузки', vm.selectedBranch?.branchName ?? ''),
              const SizedBox(height: 12),
              _buildSummaryRow('Способ доставки', vm.selectedDeliveryType.label),
              
              if (vm.selectedDeliveryType == DeliveryType.postamat) ...[
                const SizedBox(height: 12),
                _buildSummaryRow('Адрес постамата', vm.selectedPostamat?.address ?? ''),
              ],
              if (vm.selectedDeliveryType == DeliveryType.express || vm.selectedDeliveryType == DeliveryType.courier) ...[
                const SizedBox(height: 12),
                _buildSummaryRow('Адрес доставки', vm.destinationAddress),
              ],
              const SizedBox(height: 12),
              _buildSummaryRow('Статус оплаты', vm.prepayNow ? 'Оплачено (Карта)' : 'При получении'),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Состав заказа', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${vm.totalItemsCount} товаров', style: const TextStyle(color: _textGray, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              ...vm.cart.entries.map((e) {
                final item = vm.availableItems.firstWhere((i) => i.itemId == e.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: _bgGray950, borderRadius: BorderRadius.circular(6)),
                        child: Text('${e.value} шт', style: const TextStyle(color: _textGray, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 14))),
                      Text('${(item.price * e.value).toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Colors.white12, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Итого к оплате:', style: TextStyle(color: _textGray, fontSize: 14)),
                  Text('${vm.cartTotalPrice.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 130, child: Text(label, style: const TextStyle(color: _textGray, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
      ],
    );
  }

  // --- НИЖНЯЯ ПАНЕЛЬ НАВИГАЦИИ ---
  Widget _buildBottomBar(CreateOrderViewModel vm) {
    final isLast = vm.currentStep == 3;
    final canProceed = vm.canProceedToNextStep();

    return Container(
      padding: const EdgeInsets.all(16),
      color: _bgGray950,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (vm.currentStep > 0)
              TextButton(
                onPressed: vm.isCheckingPostamatCapacity || vm.isLoading ? null : vm.previousStep,
                child: const Text('Назад', style: TextStyle(color: _textGray, fontSize: 16)),
              )
            else
              const SizedBox(),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: canProceed ? Colors.green : Colors.white12,
                disabledBackgroundColor: Colors.white10,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: !canProceed || vm.isLoading || vm.isCheckingPostamatCapacity
                  ? null 
                  : () async {
                      if (!isLast) {
                        vm.nextStep();
                      } else {
                        await vm.checkCapacityAndSubmit();
                        // Если проверка габаритов провалилась, ошибка отрисуется в UI
                        if (vm.postamatCapacityOk == false) return; 
                        
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green, 
                            content: Text('Заказ успешно создан!'),
                            behavior: SnackBarBehavior.floating,
                          )
                        );
                        Navigator.of(context).pop();
                      }
                    },
              child: isLast
                  ? (vm.isCheckingPostamatCapacity || vm.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Оформить заказ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)))
                  : const Text('Продолжить', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGray, fontSize: 14),
      filled: true,
      fillColor: _bgGray900,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accent),
      ),
    );
  }
}