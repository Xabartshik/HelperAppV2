import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          // Верхняя панель: Фильтр содержимого и выбор товара
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
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1C1C1E),
      child: Column(
        children: [
          Row(
            children: [
              // 1. Фильтр ячеек по товару
              Expanded(
                child: TextField(
                  onChanged: (v) => ref.read(adminPlacementProvider.notifier).setContentSearch(v),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Найти ячейки с товаром...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true, fillColor: Colors.black26,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 2. Кнопка выбора товара для размещения
              ElevatedButton.icon(
                onPressed: () => _showItemSelector(context, ref, state),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                icon: const Icon(Icons.add_box),
                label: const Text('Разместить товар'),
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
          Text('Размещение: ${state.itemToPlace!.name}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(onPressed: () => ref.read(adminPlacementProvider.notifier).setItemToPlace(null), child: const Text('ОТМЕНА', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  // Группировка как в экране позиций
  Widget _buildGroupedPositions(BuildContext context, WidgetRef ref, AdminPlacementState state) {
    List<Widget> slivers = [];
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
      if (pos.zoneCode != currentZone || pos.flsNumber != currentStorage) {
        flush();
        if (pos.zoneCode != currentZone) {
          currentZone = pos.zoneCode;
          slivers.add(SliverToBoxAdapter(child: _header("Зона $currentZone", Icons.map, 20)));
        }
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

  void _showContentsSheet(BuildContext context, PositionCellDto pos, List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context, backgroundColor: const Color(0xFF1C1C1E),
      builder: (c) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Содержимое ${pos.fullName}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10),
            if (items.isEmpty) const Text('Ячейка пуста', style: TextStyle(color: Colors.white38)),
            ...items.map((i) => ListTile(
              title: Text(i['name'], style: const TextStyle(color: Colors.white)),
              trailing: Text('${i['quantity']} шт', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      ),
    );
  }

  // Диалог выбора товара
  void _showItemSelector(BuildContext context, WidgetRef ref, AdminPlacementState state) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text('Выберите товар', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.allItems.length,
            itemBuilder: (c, i) => ListTile(
              title: Text(state.allItems[i].name, style: const TextStyle(color: Colors.white)),
              onTap: () {
                ref.read(adminPlacementProvider.notifier).setItemToPlace(state.allItems[i]);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  // Диалог ввода количества
  void _showQuantityDialog(BuildContext context, WidgetRef ref, PositionCellDto pos) {
    final controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: Text('Разместить в ${pos.fullName}'),
        content: TextField(
          controller: controller, keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Количество'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ОТМЕНА')),
          ElevatedButton(
            onPressed: () {
              ref.read(adminPlacementProvider.notifier).executePlacement(pos.positionId, int.parse(controller.text));
              Navigator.pop(context);
            },
            child: const Text('ПОДТВЕРДИТЬ'),
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