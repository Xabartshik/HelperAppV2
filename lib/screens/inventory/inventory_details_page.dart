import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'inventory_viewmodel.dart';

class InventoryDetailsPage extends ConsumerStatefulWidget {
  final int workerId;
  final int assignmentId;

  const InventoryDetailsPage({
    super.key,
    required this.workerId,
    required this.assignmentId,
  });

  @override
  ConsumerState<InventoryDetailsPage> createState() => _InventoryDetailsPageState();
}

class _InventoryDetailsPageState extends ConsumerState<InventoryDetailsPage> {
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _bgGray950 = const Color(0xFF1C1C1E);
  final Color _bgGray900 = const Color(0xFF2C2C2E);
  final Color _primaryColor = const Color(0xFF7C3AED);
  final Color _textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final provider = inventoryViewModelProvider((workerId: widget.workerId, assignmentId: widget.assignmentId));
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: const Text('Детали инвентаризации'),
        backgroundColor: _bgGray950,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading && state.groupedItems.isEmpty
          ? Center(child: CircularProgressIndicator(color: _primaryColor))
          : RefreshIndicator(
              onRefresh: () async => vm.loadDetailsAsync(),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader(state, vm)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Text(
                        'Позиции для инвентаризации',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (state.groupedItems.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Text('Позиции не найдены', style: TextStyle(color: Colors.white54)),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final group = state.groupedItems[index];
                          return _buildGroupMenu(group, vm);
                        },
                        childCount: state.groupedItems.length,
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(InventoryState state, InventoryViewModel vm) {
    return Container(
      color: _bgGray950,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, size: 16, color: Colors.white),
                  label: const Text('Назад', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _handleComplete(vm),
                  icon: const Icon(Icons.check, size: 16, color: Colors.white),
                  label: const Text('Завершить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(state.zoneCode, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Дата назначения', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    Text(
                      state.initiatedAt != null
                          ? '${state.initiatedAt!.day.toString().padLeft(2, '0')}.${state.initiatedAt!.month.toString().padLeft(2, '0')}.${state.initiatedAt!.year} ${state.initiatedAt!.hour.toString().padLeft(2, '0')}:${state.initiatedAt!.minute.toString().padLeft(2, '0')}'
                          : '-',
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Статус', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    Text(state.status, style: TextStyle(color: _primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Проверено позиций', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    Text('${state.scannedItemsCount} / ${state.totalItems}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Расхождения', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    if (state.hasVariances)
                      Text('${state.varianceCount}', style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold))
                    else
                      Text('0', style: TextStyle(color: _primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupMenu(InventoryGroupVm group, InventoryViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        children: [
          InkWell(
            onTap: () => vm.toggleGroupExpansion(group),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: _bgGray900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Код: ${group.positionCode} (${group.itemCount} шт.)', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Проверено: ${group.scannedCount} из ${group.itemCount}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      ],
                    ),
                  ),
                  Icon(group.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: _primaryColor),
                ],
              ),
            ),
          ),
          if (group.isExpanded) ...[
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => context.push('/barcode-scanner', extra: {'positionCode': group.positionCode, 'assignmentId': widget.assignmentId, 'workerId': widget.workerId}),
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              label: const Text('Сканировать', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 8),
            ...group.items.map((item) => _buildItemCard(item, vm)),
          ],
        ],
      ),
    );
  }

  Widget _buildItemCard(InventoryItemVm item, InventoryViewModel vm) {
    final statusColor = item.statusText.contains('Совпадение') 
        ? _primaryColor 
        : (item.statusText.contains('Не проверено') ? Colors.white54 : Colors.redAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(item.itemName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ожидаемое', style: TextStyle(color: Colors.white54, fontSize: 10)),
                    Text(item.expectedQuantity?.toString() ?? '—', style: TextStyle(color: _primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Фактическое', style: TextStyle(color: Colors.white54, fontSize: 10)),
                    Text(item.actualQuantity?.toString() ?? '—', style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          if (!item.isCompleted) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => vm.markAsAbsent(item),
                    icon: const Icon(Icons.close, size: 14, color: Colors.white),
                    label: const Text('Отсутствует', style: TextStyle(color: Colors.white, fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showManualEntryDialog(item, vm),
                    icon: const Icon(Icons.edit, size: 14, color: Colors.white),
                    label: const Text('Ввести', style: TextStyle(color: Colors.white, fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (item.isCompleted) ...[
            const SizedBox(height: 8),
            Text(item.statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }

  void _showManualEntryDialog(InventoryItemVm item, InventoryViewModel vm) {
    final controller = TextEditingController(text: item.actualQuantity?.toString() ?? '0');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _bgGray950,
        title: const Text('Ввод количества', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Товар: ${item.itemName}', style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFF141414),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text);
              if (quantity != null && quantity >= 0) {
                vm.setManualQuantity(item, quantity);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите корректное число')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
            child: const Text('Сохранить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleComplete(InventoryViewModel vm) async {
    final provider = inventoryViewModelProvider((workerId: widget.workerId, assignmentId: widget.assignmentId));
    final state = ref.read(provider);

    final allItems = state.groupedItems.expand((g) => g.items).toList();
    final unscannedCount = allItems.where((i) => !i.isCompleted).length;

    if (unscannedCount > 0) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _bgGray950,
          title: const Text('Неотсканированные позиции', style: TextStyle(color: Colors.white)),
          content: Text('Осталось $unscannedCount непроверенных позиций.\nОни будут учтены как отсутствующие (0 шт.).\nПродолжить?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена', style: TextStyle(color: Colors.white54))),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), child: const Text('Завершить', style: TextStyle(color: Colors.white))),
          ],
        ),
      );
      if (confirm != true) return;
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _bgGray950,
          title: const Text('Завершение инвентаризации', style: TextStyle(color: Colors.white)),
          content: Text('Проверено: ${state.scannedItemsCount} из ${state.totalItems}\nРасхождений: ${state.varianceCount}\nЗавершить?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена', style: TextStyle(color: Colors.white54))),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: _primaryColor), child: const Text('Завершить', style: TextStyle(color: Colors.white))),
          ],
        ),
      );
      if (confirm != true) return;
    }

    final result = await vm.completeInventoryAsync();
    
    if (result != null && mounted) {
      var report = "✅ Инвентаризация завершена\n\n"
          "Всего позиций: ${result.statistics?.totalPositions ?? 0}\n"
          "Проверено: ${result.statistics?.countedPositions ?? 0}\n"
          "Прогресс: ${result.statistics?.completionPercentage.toStringAsFixed(1) ?? '0'}%\n\n"
          "Расхождений: ${result.statistics?.discrepancyCount ?? 0}\n";

      if ((result.statistics?.discrepancyCount ?? 0) > 0) {
        report += "  ├ Излишков: ${result.statistics?.surplusCount} (+${result.statistics?.totalSurplusQuantity} шт.)\n"
                  "  └ Недостач: ${result.statistics?.shortageCount} (-${result.statistics?.totalShortageQuantity} шт.)\n\n";
      }
      report += result.message;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _bgGray950,
          title: const Text('Отчёт', style: TextStyle(color: Colors.white)),
          content: Text(report, style: const TextStyle(color: Colors.white70)),
          actions: [
            ElevatedButton(onPressed: () {
              Navigator.pop(context); // закрываем диалог
              context.go('/home'); // на главную
            }, style: ElevatedButton.styleFrom(backgroundColor: _primaryColor), child: const Text('OK', style: TextStyle(color: Colors.white))),
          ],
        ),
      );
    }
  }
}
