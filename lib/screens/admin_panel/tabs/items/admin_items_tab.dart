import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../core/models/item/item_dto.dart';
import 'admin_items_viewmodel.dart';

class AdminItemsTab extends ConsumerWidget {
  const AdminItemsTab({super.key});

@override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminItemsProvider);

    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
    }

    if (state.filteredItems.isEmpty) {
      return const Center(child: Text("Товары не найдены", style: TextStyle(color: Colors.white54)));
    }

    // ВОТ ЗДЕСЬ ИЗМЕНЕНИЕ: Возвращаем ListView напрямую, без Scaffold!
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredItems.length,
      itemBuilder: (context, index) {
        final item = state.filteredItems[index];
        return Card(
          color: const Color(0xFF1C1C1E),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: () {
              // 1. Записываем товар в провайдер редактирования
              ref.read(editingItemProvider.notifier).state = item;
              // 2. Теперь контекст без помех найдет главный Scaffold (AdminDashboardPage) и откроет форму!
              Scaffold.of(context).openEndDrawer();
            },
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF7C3AED),
              child: Icon(Icons.inventory_2, color: Colors.white, size: 18),
            ),
            title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('Вес: ${item.weight}г • ${item.length}x${item.width}x${item.height}мм', 
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: Text('${item.price} ₽', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

class ItemFormPanel extends ConsumerStatefulWidget {
  const ItemFormPanel({super.key});

  @override
  ConsumerState<ItemFormPanel> createState() => _ItemFormPanelState();
}

class _ItemFormPanelState extends ConsumerState<ItemFormPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = Map<String, dynamic>.from(_formKey.currentState!.value);
      final editingItem = ref.read(editingItemProvider);
      
      // Парсим числовые значения
      final double weight = double.tryParse(values['weight'].toString()) ?? 0;
      final double length = double.tryParse(values['length'].toString()) ?? 0;
      final double width = double.tryParse(values['width'].toString()) ?? 0;
      final double height = double.tryParse(values['height'].toString()) ?? 0;
      final double price = double.tryParse(values['price'].toString()) ?? 0;

      bool success;
      if (editingItem != null) {
        final updated = editingItem.copyWith(
          name: values['name'],
          weight: weight,
          length: length,
          width: width,
          height: height,
          price: price,
        );
        success = await ref.read(adminItemsProvider.notifier).updateItem(updated);
      } else {
        success = await ref.read(adminItemsProvider.notifier).createItem({
          'name': values['name'],
          'weight': weight,
          'length': length,
          'width': width,
          'height': height,
          'price': price,
        });
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Готово!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingItem = ref.watch(editingItemProvider);
    final isEdit = editingItem != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isEdit ? "Редактировать товар" : "Новый товар", 
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context))
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                initialValue: isEdit ? {
                  'name': editingItem.name,
                  'weight': editingItem.weight.toString(),
                  'length': editingItem.length.toString(),
                  'width': editingItem.width.toString(),
                  'height': editingItem.height.toString(),
                  'price': editingItem.price.toString(),
                } : {},
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Название'),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _numField('weight', 'Вес (г)')),
                        const SizedBox(width: 12),
                        Expanded(child: _numField('price', 'Цена (₽)')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text("Габариты (мм)", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _numField('length', 'Д')),
                        const SizedBox(width: 8),
                        Expanded(child: _numField('width', 'Ш')),
                        const SizedBox(width: 8),
                        Expanded(child: _numField('height', 'В')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
              child: Text(isEdit ? 'ОБНОВИТЬ' : 'СОЗДАТЬ'),
            ),
          )
        ],
      ),
    );
  }

  Widget _numField(String name, String label) {
    return FormBuilderTextField(
      name: name,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.numeric(),
      ]),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}