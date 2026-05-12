import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/item/item_dto.dart';
import 'package:helper_app/screens/admin_panel/tabs/branches/admin_branches_viewmodel.dart';
import 'admin_placement_viewmodel.dart';
import '../../../../core/models/inventory/position_cell_dto.dart';

class AdminPlacementTab extends ConsumerWidget {
  const AdminPlacementTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPlacementProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildTopPanel(context, ref, state),

          if (state.itemToPlace != null)
            _buildActivePlacementBanner(ref, state),

          Expanded(
            child: state.isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _buildGroupedPositions(context, ref, state),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPanel(BuildContext context, WidgetRef ref, AdminPlacementState state) {
    final branchesState = ref.watch(adminBranchesProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1C1C1E),
      child: Column(
        children: [
          Row(
            children: [
              // Выбор филиала
              SizedBox(
                width: 200,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: state.selectedBranchId,
                    hint: const Text("Все филиалы", style: TextStyle(color: Colors.white70)),
                    dropdownColor: const Color(0xFF2C2C2E),
                    style: const TextStyle(color: Colors.white),
                    items: [
                      const DropdownMenuItem(value: null, child: Text("Все филиалы")),
                      ...branchesState.branches.map((b) => DropdownMenuItem(
                        value: b.branchId,
                        child: Text(b.branchName),
                      )),
                    ],
                    onChanged: (val) => ref.read(adminPlacementProvider.notifier).setBranch(val),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Фильтр содержимого ячеек
              Expanded(
                child: TextField(
                  onChanged: (v) => ref.read(adminPlacementProvider.notifier).setContentSearch(v),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Поиск товара внутри ячеек...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true, fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Кнопка выбора товара для размещения
              ElevatedButton.icon(
                onPressed: () => _showItemSelector(context, ref, state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                icon: const Icon(Icons.add_box),
                label: const Text('Выбрать товар', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlacementBanner(WidgetRef ref, AdminPlacementState state) {
    return Container(
      color: Colors.amber.withOpacity(0.1),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber),
          const SizedBox(width: 12),
          Text('РАЗМЕЩЕНИЕ: ${state.itemToPlace!.name}. Выберите ячейку на складе', 
            style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(adminPlacementProvider.notifier).setItemToPlace(null), 
            child: const Text('ОТМЕНА', style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedPositions(BuildContext context, WidgetRef ref, AdminPlacementState state) {
    final branchesState = ref.watch(adminBranchesProvider);
    List<Widget> slivers = [];
    String? currentBranch;
    String? currentZone;
    String? currentStorage;
    final items = state.filteredPositions;

    List<PositionCellDto> chunk = [];
    void flush() {
      if (chunk.isNotEmpty) {
        final currentChunk = List<PositionCellDto>.from(chunk);
        slivers.add(SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 180, childAspectRatio: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
            delegate: SliverChildBuilderDelegate((c, i) => _buildCell(context, ref, state, currentChunk[i]), childCount: currentChunk.length),
          ),
        ));
        chunk = [];
      }
    }

    for (var pos in items) {
      if (pos.branchId.toString() != currentBranch || pos.zoneCode != currentZone || pos.flsNumber != currentStorage) {
        flush();
        // Заголовок филиала
        if (pos.branchId.toString() != currentBranch) {
          currentBranch = pos.branchId.toString();
          final branchStr = branchesState.branches.any((b) => b.branchId == pos.branchId) 
              ? branchesState.branches.firstWhere((b) => b.branchId == pos.branchId).branchName 
              : 'Филиал ${pos.branchId}';
          slivers.add(SliverToBoxAdapter(child: _header("Филиал: $branchStr", Icons.business, 16)));
        }
        // Заголовок зоны
        if (pos.zoneCode != currentZone) {
          currentZone = pos.zoneCode;
          slivers.add(SliverToBoxAdapter(child: _header("Зона $currentZone", Icons.map, 20)));
        }
        // Заголовок стеллажа
        currentStorage = pos.flsNumber;
        slivers.add(SliverToBoxAdapter(child: _header("Стеллаж $currentStorage", Icons.view_column, 40)));
      }
      chunk.add(pos);
    }
    flush();

    return CustomScrollView(slivers: slivers);
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, AdminPlacementState state, PositionCellDto pos) {
    final contents = state.getItemsInPosition(pos.positionId);
    final hasItems = contents.isNotEmpty;

    return InkWell(
      onTap: () {
        if (state.itemToPlace != null) {
          _showQuantityDialog(context, ref, pos);
        } else {
          _showContentsSheet(context, pos, contents);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: hasItems ? const Color(0xFF7C3AED).withOpacity(0.1) : const Color(0xFF1C1C1E),
          border: Border.all(color: hasItems ? const Color(0xFF7C3AED) : Colors.white10),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(pos.fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            if (hasItems) Text('${contents.length} наим.', style: const TextStyle(color: Colors.white54, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  // --- ИСПРАВЛЕНИЕ OVERFLOW В BOTTOM SHEET ---
  void _showContentsSheet(BuildContext context, PositionCellDto pos, List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context, 
      backgroundColor: const Color(0xFF1C1C1E),
      isScrollControlled: true, // Позволяет шторке менять размер
      builder: (c) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8), // Макс. высота 80% экрана
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Содержимое ${pos.fullName}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white10),
              if (items.isEmpty) const Text('Ячейка пуста', style: TextStyle(color: Colors.white38)),
              // Используем Flexible для того, чтобы ListView мог скроллиться внутри Column
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(items[i]['name'], style: const TextStyle(color: Colors.white)),
                    trailing: Text('${items[i]['quantity']} шт', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ИСПРАВЛЕНИЕ ОКНА ПОИСКА ТОВАРА ---
  void _showItemSelector(BuildContext context, WidgetRef ref, AdminPlacementState state) {
    showDialog(
      context: context,
      builder: (c) => ItemSelectorDialog(
        allItems: state.allItems,
        onSelect: (item) {
          ref.read(adminPlacementProvider.notifier).setItemToPlace(item);
        },
      ),
    );
  }

  // --- ИСПРАВЛЕНИЕ ЦВЕТА ЗАГОЛОВКА ---
  void _showQuantityDialog(BuildContext context, WidgetRef ref, PositionCellDto pos) {
    final controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text('Разместить в ${pos.fullName}', style: const TextStyle(color: Colors.white)), // Цвет заголовка
        content: TextField(
          controller: controller, keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Количество', 
            labelStyle: TextStyle(color: Colors.white54)
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ОТМЕНА')),
          ElevatedButton(
            onPressed: () {
              ref.read(adminPlacementProvider.notifier).executePlacement(pos.positionId, int.tryParse(controller.text) ?? 1);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              foregroundColor: Colors.white,
            ),
            child: const Text('ПОДТВЕРДИТЬ', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _header(String text, IconData icon, double left) => Padding(
    padding: EdgeInsets.only(left: left, top: 16, bottom: 8),
    child: Row(children: [Icon(icon, size: 16, color: Colors.white38), const SizedBox(width: 8), Text(text, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold))]),
  );
}

// Отдельный Stateful виджет для диалога выбора товара (с полем поиска)
class ItemSelectorDialog extends StatefulWidget {
  final List<ItemDto> allItems;
  final Function(ItemDto) onSelect;

  const ItemSelectorDialog({super.key, required this.allItems, required this.onSelect});

  @override
  State<ItemSelectorDialog> createState() => _ItemSelectorDialogState();
}

class _ItemSelectorDialogState extends State<ItemSelectorDialog> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.allItems.where((i) => 
      i.name.toLowerCase().contains(query.toLowerCase()) || 
      i.itemId.toString() == query
    ).toList();

    return AlertDialog(
      backgroundColor: const Color(0xFF1C1C1E),
      title: const Text('Выберите товар', style: TextStyle(color: Colors.white)),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Поиск по названию или ID...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(filtered[i].name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text("ID: ${filtered[i].itemId}", style: const TextStyle(color: Colors.white38)),
                  onTap: () {
                    widget.onSelect(filtered[i]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}