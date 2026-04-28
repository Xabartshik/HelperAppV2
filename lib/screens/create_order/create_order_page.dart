import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/logger.dart';
import 'create_order_viewmodel.dart';

final createOrderViewModelProvider = ChangeNotifierProvider.autoDispose<CreateOrderViewModel>((ref) {
  final vm = CreateOrderViewModel(ref.read(apiClientProvider));
  // Оборачиваем вызов в Future.microtask, чтобы дождаться окончания отрисовки виджета
  Future.microtask(() => vm.initialize());
  return vm;
});

class CreateOrderPage extends ConsumerStatefulWidget {
  const CreateOrderPage({super.key});

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  late final PageController _pageController;
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final Map<int, TextEditingController> _qtyControllers = {};

  static const Color _bg = Color(0xFF36393F);
  static const Color _card = Color(0xFF2F3136);
  static const Color _accent = Color(0xFF5865F2);
  static const Color _subtitle = Color(0xFFB9BBBE);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Logger.i('CreateOrderPage: initState');
  }

  @override
  void dispose() {
    Logger.i('CreateOrderPage: dispose');
    _pageController.dispose();
    _cityController.dispose();
    _searchController.dispose();
    for (final c in _qtyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(createOrderViewModelProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && _pageController.page?.round() != vm.currentStep) {
        _pageController.animateToPage(
          vm.currentStep,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: const Text('Симулятор клиента: Оформление заказа'),
      ),
      body: Column(
        children: [
          _buildHeaderStepper(vm),
          if (vm.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.redAccent)),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _stepLocation(vm),
                _stepShowcase(vm),
                _stepLogistics(vm),
                _stepReview(vm),
              ],
            ),
          ),
          _buildBottomActions(vm),
        ],
      ),
    );
  }

  Widget _buildHeaderStepper(CreateOrderViewModel vm) {
    const titles = ['Локация', 'Витрина', 'Логистика', 'Проверка'];
    return Container(
      color: _card,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: List.generate(titles.length, (index) {
          final active = index == vm.currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: active ? _accent : _bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${index + 1}. ${titles[index]}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _stepLocation(CreateOrderViewModel vm) {
    final cities = vm.availableCities;
    final selectedCity = vm.selectedBranch?.address;
    final branches = selectedCity == null ? <Branch>[] : vm.branchesByCity(selectedCity);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Выберите локацию и филиал', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 12),
          Autocomplete<String>(
            optionsBuilder: (value) {
              final q = value.text.trim().toLowerCase();
              if (q.isEmpty) return cities;
              return cities.where((city) => city.toLowerCase().contains(q));
            },
            onSelected: (city) {
              _cityController.text = city;
              final cityBranches = vm.branchesByCity(city);
              vm.selectBranch(cityBranches.isNotEmpty ? cityBranches.first : null);
            },
            fieldViewBuilder: (context, textEditingController, focusNode, onSubmit) {
              if (_cityController.text.isNotEmpty && textEditingController.text.isEmpty) {
                textEditingController.text = _cityController.text;
              }
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Поиск адреса/города'),
                onSubmitted: (_) => onSubmit(),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final b = branches[index];
                final selected = vm.selectedBranch?.branchId == b.branchId;
                return Card(
                  color: _card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: selected ? _accent : Colors.transparent),
                  ),
                  child: RadioListTile<int>(
                    value: b.branchId,
                    groupValue: vm.selectedBranch?.branchId,
                    activeColor: _accent,
                    onChanged: (_) => vm.selectBranch(b),
                    title: Text(b.branchName, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(b.address ?? '', style: const TextStyle(color: _subtitle)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepShowcase(CreateOrderViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Поиск товара').copyWith(
              prefixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white70),
                onPressed: () => vm.applyItemSearch(_searchController.text),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () {
                  _searchController.clear();
                  vm.clearItemSearch();
                },
              ),
            ),
            onSubmitted: vm.applyItemSearch,
          ),
          const SizedBox(height: 12),
          if (vm.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: vm.availableItems.length,
                itemBuilder: (context, index) => _itemCard(vm, vm.availableItems[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _itemCard(CreateOrderViewModel vm, AvailableItem item) {
    final qty = vm.quantityFor(item.itemId);
    final controller = _qtyControllers.putIfAbsent(
      item.itemId,
      () => TextEditingController(text: qty.toString()),
    );
    if (controller.text != qty.toString()) {
      controller.text = qty.toString();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('${item.price.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.white70)),
          Text('Доступно: ${item.availableQuantity}', style: const TextStyle(color: _subtitle)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: qty == 0
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: _accent),
                    onPressed: item.availableQuantity > 0 ? () => vm.addToCart(item.itemId) : null,
                    child: const Text('В корзину', style: TextStyle(color: Colors.white)),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => vm.decreaseQuantity(item),
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: controller,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration('').copyWith(contentPadding: const EdgeInsets.all(8)),
                          onSubmitted: (value) {
                            final error = vm.setQuantityFromInput(item, value);
                            if (error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                              controller.text = vm.quantityFor(item.itemId).toString();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () => vm.increaseQuantity(item),
                        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _stepLogistics(CreateOrderViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Логистика', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        DropdownButtonFormField<DeliveryType>(
          initialValue: vm.selectedDeliveryType,
          dropdownColor: _card,
          style: const TextStyle(color: Colors.white),
          decoration: _inputDecoration('Тип доставки'),
          items: DeliveryType.values
              .map((d) => DropdownMenuItem(value: d, child: Text(d.label, style: const TextStyle(color: Colors.white))))
              .toList(),
          onChanged: (value) {
            if (value != null) vm.setDeliveryType(value);
          },
        ),
        const SizedBox(height: 12),
        if (vm.selectedDeliveryType == DeliveryType.postamat)
          DropdownButtonFormField<Postamat>(
            initialValue: vm.selectedPostamat,
            dropdownColor: _card,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Адрес постамата'),
            items: vm.postamats
                .map((p) => DropdownMenuItem(value: p, child: Text(p.address, style: const TextStyle(color: Colors.white))))
                .toList(),
            onChanged: vm.setSelectedPostamat,
          ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Оплата', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Итого: ${vm.totalAmount.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.white70)),
              SwitchListTile(
                activeTrackColor: _accent,
                title: const Text('Оплатить сейчас (Предоплата)', style: TextStyle(color: Colors.white)),
                value: vm.prepayNow,
                onChanged: vm.setPrepayNow,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepReview(CreateOrderViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Проверка перед подтверждением', style: TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 12),
        _summaryTile('Филиал', vm.selectedBranch?.branchName ?? 'Не выбран'),
        _summaryTile('Доставка', vm.selectedDeliveryType.label),
        if (vm.selectedDeliveryType == DeliveryType.postamat)
          _summaryTile('Постамат', vm.selectedPostamat?.address ?? 'Не выбран'),
        _summaryTile('Товаров в корзине', vm.cart.length.toString()),
        _summaryTile('Сумма', '${vm.totalAmount.toStringAsFixed(0)} ₽'),
        if (vm.isCheckingPostamatCapacity)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text('Проверка габаритов...', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        if (vm.postamatCapacityError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(vm.postamatCapacityError!, style: const TextStyle(color: Colors.redAccent)),
          ),
      ],
    );
  }

  Widget _summaryTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: _subtitle))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _buildBottomActions(CreateOrderViewModel vm) {
    final isLast = vm.currentStep == 3;
    return Container(
      color: _card,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          if (vm.currentStep > 0)
            TextButton(
              onPressed: vm.previousStep,
              child: const Text('Назад', style: TextStyle(color: Colors.white70)),
            ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _accent),
            onPressed: vm.isLoading
                ? null
                : () async {
                    if (!isLast) {
                      await vm.nextStep();
                      return;
                    }
                    final ok = await vm.createOrder();
                    if (!mounted) return;
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Заказ успешно создан')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
            child: isLast
                ? (vm.isCheckingPostamatCapacity
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        vm.canSubmitOrder ? 'Оформить' : 'Проверка габаритов...',
                        style: const TextStyle(color: Colors.white),
                      ))
                : const Text('Далее', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label.isEmpty ? null : label,
      labelStyle: const TextStyle(color: _subtitle),
      filled: true,
      fillColor: _card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _accent),
      ),
    );
  }
}