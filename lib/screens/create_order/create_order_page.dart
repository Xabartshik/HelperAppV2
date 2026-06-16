import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/services/auth_service.dart';
import '../../core/models/branch/cart_check_dto.dart';
import '../../core/models/branch/branch_dto.dart';
import '../../core/models/branch/branch_stock_dto.dart';

import '../../core/network/api_client.dart';
import 'create_order_viewmodel.dart';

final createOrderViewModelProvider = ChangeNotifierProvider.autoDispose<CreateOrderViewModel>((ref) {
  final user = ref.read(currentUserProvider);
  final customerId = user?.customerId ?? 0;
  final vm = CreateOrderViewModel(ref.read(apiClientProvider), customerId);
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
          if (vm.totalSplitsCount > 0)
            Container(
              color: Colors.orangeAccent.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: double.infinity,
              child: Text(
                'Оформление разделенного заказа: часть ${vm.currentSplitIndex} из ${vm.totalSplitsCount}',
                style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
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
    final titles = ['Витрина', 'Локация', 'Логистика', 'Проверка'];
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
      case 0: return _buildStep2Catalog(vm);
      case 1: return _buildStep1Location(vm);
      case 2: return _buildStep3Logistics(vm);
      case 3: return _buildStep4Summary(vm);
      default: return const SizedBox();
    }
  }

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
        if (vm.availableBranches.isEmpty && !vm.isLoading)
          _buildCartConflictBanner(vm),
        Expanded(
          child: vm.filteredBranches.isEmpty && !vm.isLoading
              ? _buildEmptyState(Icons.location_city, 'Филиалы по данному запросу не найдены.')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: vm.filteredBranches.length,
                  itemBuilder: (context, index) {
                    final b = vm.filteredBranches[index];
                    
                    final isAvailable = vm.availableBranches.any((ab) => ab.branchId == b.branchId);
                    final isSelected = vm.selectedBranch?.branchId == b.branchId;
                    
                    final partInfo = vm.partiallyAvailableBranches.firstWhere(
                      (pb) => pb.branch.branchId == b.branchId,
                      orElse: () => BranchAvailabilityDto(
                        branch: BranchDto(branchId: b.branchId),
                        missingItems: [],
                      ),
                    );

                    return GestureDetector(
                      onTap: isAvailable ? () => vm.selectBranch(b) : null,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? _accent.withOpacity(0.1) 
                            : (isAvailable ? _bgGray900 : _bgGray900.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                              ? _accent 
                              : (isAvailable ? Colors.transparent : Colors.white10)
                          ),
                        ),
                        child: Opacity(
                          opacity: isAvailable ? 1.0 : 0.5,
                          child: Row(
                            children: [
                              Icon(
                                Icons.business, 
                                color: isSelected 
                                  ? _accent 
                                  : (isAvailable ? _textGray : Colors.grey)
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.branchName, 
                                      style: const TextStyle(
                                        color: Colors.white, 
                                        fontSize: 16, 
                                        fontWeight: FontWeight.w500
                                      )
                                    ),
                                    if (b.address != null && b.address!.isNotEmpty) 
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          b.address!, 
                                          style: const TextStyle(color: _textGray, fontSize: 12)
                                        ),
                                      ),
                                    if (!isAvailable && partInfo.missingItems.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Не хватает ${partInfo.missingItems.length} товаров из корзины',
                                          style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected) const Icon(Icons.check_circle, color: _accent),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCartConflictBanner(CreateOrderViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Конфликт корзины',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Товары из вашей корзины находятся в разных магазинах. Ни одна точка не может выдать весь заказ целиком.',
            style: TextStyle(color: _textGray, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.splitscreen, color: Colors.white, size: 18),
            label: const Text('Разделить заказ автоматически', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            onPressed: () async {
              final splits = await vm.splitCartAutomatically();
              if (mounted) {
                _showSplitOrdersDialog(context, vm, splits);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showSplitOrdersDialog(BuildContext context, CreateOrderViewModel vm, List<Map<int, int>> splits) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _bgGray950,
          title: const Text('Разделение заказа', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: splits.length,
              itemBuilder: (context, splitIndex) {
                final split = splits[splitIndex];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _bgGray900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Заказ ${splitIndex + 1}',
                        style: const TextStyle(color: _accent, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...split.entries.map((e) {
                        final item = vm.globalItems.firstWhere((i) => i.itemId == e.key);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            '- ${item.name} (${e.value} шт)',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена', style: TextStyle(color: _textGray)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context); // Закрываем диалог разделения заказов
                vm.startIndividualSplitCheckout(splits);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Корзина разделена на ${splits.length} частей. Начните оформление части 1.'),
                    backgroundColor: Colors.orangeAccent,
                    behavior: SnackBarBehavior.floating,
                  )
                );
              },
              child: const Text('Оформить по частям', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// Отображает распределение остатков товара по филиалам.
  void _showBranchStockDistributionBottomSheet(BuildContext context, CreateOrderViewModel vm, AvailableItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _bgGray950,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FutureBuilder<List<BranchStockDto>>(
          future: vm.fetchItemStockDistribution(item.itemId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator(color: _accent)),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text('Ошибка загрузки данных: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent)),
                ),
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Товар отсутствует на складах филиалов', style: TextStyle(color: _textGray)),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Наличие в филиалах',
                    style: TextStyle(color: _textGray, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const Divider(color: Colors.white12),
                      itemBuilder: (context, index) {
                        final stock = list[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stock.branchName,
                                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      stock.address,
                                      style: const TextStyle(color: _textGray, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _accent.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${stock.availableQuantity} шт.',
                                  style: const TextStyle(color: _accent, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
                  ? _buildEmptyState(Icons.inventory_2_outlined, 'Товары не найдены.')
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

  Future<bool?> _showConflictConfirmationDialog(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: _bgGray950,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Внимание: другой магазин',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Этот товар находится в другом филиале. Добавление его в корзину сделает невозможным получение всего заказа в одном месте.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _textGray, fontSize: 14),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Отмена', style: TextStyle(color: _textGray)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _accent),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Добавить', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
              InkWell(
                onTap: item.branchCount == 0 ? null : () => _showBranchStockDistributionBottomSheet(context, vm, item),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory, color: _textGray, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        item.branchCount == 0 
                          ? 'Отсутствует в продаже' 
                          : 'В наличии в ${item.branchCount} филиалах (${item.availableQuantity} шт.)', 
                        style: TextStyle(
                          color: item.branchCount == 0 ? Colors.redAccent : _textGray, 
                          fontSize: 13,
                          decoration: item.branchCount == 0 ? null : TextDecoration.underline,
                        )
                      ),
                    ],
                  ),
                ),
              ),
              qty == 0
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.branchCount == 0 ? _bgGray950 : _accent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        minimumSize: const Size(100, 36),
                      ),
                      onPressed: item.branchCount == 0 ? null : () async {
                        final causesConflict = await vm.wouldAddingItemCauseConflict(item.itemId);
                        if (causesConflict && context.mounted) {
                          final confirm = await _showConflictConfirmationDialog(context);
                          if (confirm != true) return;
                        }
                        final success = vm.updateCartQuantity(item.itemId, 1, item.availableQuantity);
                        if (!success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Недостаточно товара на складе (доступно: ${item.availableQuantity})'),
                              backgroundColor: Colors.redAccent,
                            )
                          );
                        }
                      },
                      child: Text('Добавить', style: TextStyle(color: item.branchCount == 0 ? _textGray : Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
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
                            onPressed: () {
                              final success = vm.updateCartQuantity(item.itemId, -1, item.availableQuantity);
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Недостаточно товара на складе (доступно: ${item.availableQuantity})'),
                                    backgroundColor: Colors.redAccent,
                                  )
                                );
                              }
                            },
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
                                final success = vm.setManualQuantity(item.itemId, int.tryParse(val) ?? 0, item.availableQuantity);
                                if (!success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Недостаточно товара на складе. Установлено максимальное доступное количество: ${item.availableQuantity}'),
                                      backgroundColor: Colors.orangeAccent,
                                    )
                                  );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.white, size: 18),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(8),
                            onPressed: () async {
                              final causesConflict = await vm.wouldAddingItemCauseConflict(item.itemId);
                              if (causesConflict && context.mounted) {
                                final confirm = await _showConflictConfirmationDialog(context);
                                if (confirm != true) return;
                              }
                              final success = vm.updateCartQuantity(item.itemId, 1, item.availableQuantity);
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Недостаточно товара на складе (доступно: ${item.availableQuantity})'),
                                    backgroundColor: Colors.redAccent,
                                  )
                                );
                              }
                            },
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
              // Исключаем постамат из списка и переименовываем Экспресс
              items: DeliveryType.values
                  .where((t) => t != DeliveryType.postamat)
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t == DeliveryType.express ? 'Выдача в зал' : t.label),
                      ))
                  .toList(),
              onChanged: (val) => vm.setDeliveryType(val!),
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Блок адреса
        if (vm.selectedDeliveryType == DeliveryType.courier) ...[
          const Text('Адрес доставки', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Укажите город, улицу, дом, кв.'),
            onChanged: (val) => vm.setDestinationAddress(val),
          )
        ] else ...[
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

        // Выбор времени: только для Самовывоза и Курьера
        if (vm.selectedDeliveryType == DeliveryType.pickup) ...[
          const Text('Дата и время самовывоза', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          _buildPickupDateTimePicker(vm),
        ] else if (vm.selectedDeliveryType == DeliveryType.courier) ...[
           const Text('Дата доставки', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
           const SizedBox(height: 8),
           _buildCourierDatePicker(vm),
           if (vm.deliveryDate != null) ...[
              const SizedBox(height: 16),
              const Text('Окно доставки', style: TextStyle(color: _textGray, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildSlotPicker(vm),
           ]
        ] else if (vm.selectedDeliveryType == DeliveryType.express) ...[
           // Инфо-баннер для "Выдачи в зал" вместо выбора даты
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: _accent.withOpacity(0.1), 
               borderRadius: BorderRadius.circular(12),
               border: Border.all(color: _accent.withOpacity(0.3))
             ),
             child: const Row(
               children: [
                 Icon(Icons.flash_on, color: _accent, size: 24),
                 SizedBox(width: 16),
                 Expanded(
                   child: Text(
                     'Заказ будет подготовлен и выдан в торговом зале сразу после подтверждения оплаты.', 
                     style: TextStyle(color: Colors.white, fontSize: 13, height: 1.4)
                   )
                 ),
               ],
             ),
           ),
        ],

        const SizedBox(height: 32),

        // Блок оплаты
        _buildPaymentSummary(vm),
      ],
    );
  }

  // Вспомогательные методы для чистоты кода основного блока
  Widget _buildPickupDateTimePicker(CreateOrderViewModel vm) {
    final minAllowed = vm.minPickupTime;
    return GestureDetector(
      onTap: () => _selectDateTime(vm, minAllowed),
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
    );
  }

  Widget _buildCourierDatePicker(CreateOrderViewModel vm) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: vm.deliveryDate ?? vm.firstAvailableDeliveryDate,
          firstDate: vm.firstAvailableDeliveryDate,
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
    );
  }

  Widget _buildSlotPicker(CreateOrderViewModel vm) {
    return Container(
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
    );
  }

  Widget _buildPaymentSummary(CreateOrderViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: _bgGray900, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Итого к оплате', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text('${vm.cartTotalPrice.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: Colors.white12, height: 1)),
          
          /* ВРЕМЕННО СКРЫВАЕМ ВЫБОР ОПЛАТЫ
          const Text('Способ оплаты', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Column(
            children: PaymentType.values.map((type) {
              return RadioListTile<PaymentType>(
                title: Text(type.label, style: const TextStyle(color: Colors.white)),
                value: type,
                groupValue: vm.selectedPaymentType,
                activeColor: _accent,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  if (val != null) vm.setPaymentType(val);
                },
              );
            }).toList(),
          ),
          */
        ],
      ),
    );
  }

  Future<void> _selectDateTime(CreateOrderViewModel vm, DateTime minAllowed) async {
    final firstAllowedDate = DateTime(minAllowed.year, minAllowed.month, minAllowed.day);
    final date = await showDatePicker(
      context: context,
      initialDate: (vm.deliveryDate ?? minAllowed).isBefore(firstAllowedDate) ? firstAllowedDate : (vm.deliveryDate ?? minAllowed),
      firstDate: firstAllowedDate, 
      lastDate: firstAllowedDate.add(const Duration(days: 14)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.fromDateTime((vm.deliveryDate ?? minAllowed).isBefore(minAllowed) ? minAllowed : (vm.deliveryDate ?? minAllowed)),
      );
      if (time != null) {
        final selected = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        vm.setDeliveryDate(selected);
      }
    }
  }

  Widget _buildStep4Summary(CreateOrderViewModel vm) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (vm.outOfStockItemIds.isNotEmpty)
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
                 const Expanded(
                   child: Text(
                     'Оформление заказа невозможно: некоторые товары закончились на складе. Пожалуйста, вернитесь на шаг назад и отредактируйте корзину.', 
                     style: TextStyle(color: Colors.redAccent, height: 1.4)
                   )
                 ),
               ],
             ),
           ),

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
              // Статус оплаты жестко зафиксирован для отображения
              _buildSummaryRow('Статус оплаты', 'Предоплата онлайн'),
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
                final isOutOfStock = vm.outOfStockItemIds.contains(item.itemId);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: isOutOfStock ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                  decoration: isOutOfStock 
                    ? BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      )
                    : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOutOfStock ? Colors.redAccent.withOpacity(0.2) : _bgGray950, 
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${e.value} шт', 
                          style: TextStyle(
                            color: isOutOfStock ? Colors.redAccent : _textGray, 
                            fontSize: 12, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name, 
                              style: TextStyle(
                                color: isOutOfStock ? Colors.redAccent : Colors.white, 
                                fontSize: 14,
                              ),
                            ),
                            if (isOutOfStock) ...[
                              const SizedBox(height: 4),
                              const Text(
                                'Товар закончился на складе', 
                                style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '${(item.price * e.value).toStringAsFixed(0)} ₽', 
                        style: TextStyle(
                          color: isOutOfStock ? Colors.redAccent : Colors.white, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        final orderId = await vm.checkCapacityAndSubmit();
                        if (vm.postamatCapacityOk == false) return; 
                        
                        if (orderId != null) {
                          // Постоплата отключена, поэтому всегда вызываем мок-шлюз оплаты (предоплата)
                          _showPaymentDialog(context, ref, orderId, vm);
                        } else if (vm.errorMessage != null) {
                           if (!mounted) return;
                           ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(vm.errorMessage!), backgroundColor: Colors.red)
                           );
                        }
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

  void _showPaymentDialog(BuildContext context, WidgetRef ref, int orderId, CreateOrderViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (ctx) {
        bool isProcessing = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: _bgGray950,
              title: const Text('Оплата заказа', style: TextStyle(color: Colors.white)),
              content: isProcessing
                  ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: _accent)))
                  : const Text('Вы перенаправлены на платежный шлюз. Нажмите "Оплатить" для симуляции успешной транзакции. У вас есть 15 минут до отмены.',
                      style: TextStyle(color: Colors.white70)),
              actions: isProcessing
                  ? []
                  : [
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(this.context).pop(); 
                        },
                        child: const Text('Отмена', style: TextStyle(color: Colors.redAccent)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _accent),
                        onPressed: () async {
                          setState(() => isProcessing = true);
                          
                          await Future.delayed(const Duration(seconds: 2));
                          
                          try {
                            // Вызываем эндпоинт ConfirmPayment
                            final bool success = await ref.read(apiClientProvider).confirmPaymentAsync(orderId);

                            if (success) {
                                // Оплата прошла, бэкенд перевел статус в Created и запустил задачи
                                if (ctx.mounted) Navigator.of(ctx).pop(); // Закрываем диалог оплаты
                                if (this.context.mounted) {
                                    final hasNext = vm.moveToNextSplit();
                                    if (hasNext) {
                                        ScaffoldMessenger.of(this.context).showSnackBar(
                                            SnackBar(
                                                content: Text('Часть ${vm.currentSplitIndex - 1} успешно оплачена! Переходим к оформлению части ${vm.currentSplitIndex} из ${vm.totalSplitsCount}.'), 
                                                backgroundColor: Colors.green,
                                                behavior: SnackBarBehavior.floating,
                                            )
                                        );
                                    } else {
                                        ScaffoldMessenger.of(this.context).showSnackBar(
                                            const SnackBar(
                                                content: Text('Оплата успешна! Заказ передан в сборку.'), 
                                                backgroundColor: Colors.green,
                                                behavior: SnackBarBehavior.floating,
                                            )
                                        );
                                        Navigator.of(this.context).pop(); // Уходим с экрана создания заказа
                                    }
                                }
                            } else {
                                // Ошибка (например, 404 если метод не найден или 400 если заказ нельзя оплатить)
                                setState(() => isProcessing = false);
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                        content: Text('Не удалось подтвердить оплату. Проверьте соединение.'), 
                                        backgroundColor: Colors.red
                                    )
                                );
}
                          } catch (e) {
                             setState(() => isProcessing = false);
                             if (ctx.mounted) {
                               ScaffoldMessenger.of(ctx).showSnackBar(
                                 SnackBar(content: Text('Ошибка сети: $e'), backgroundColor: Colors.red)
                               );
                             }
                          }
                        },
                        child: const Text('Оплатить', style: TextStyle(color: Colors.white)),
                      )
                    ],
            );
          }
        );
      }
    );
  }
}