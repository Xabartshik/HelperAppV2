import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:helper_app/screens/admin_panel/tabs/branches/admin_branches_viewmodel.dart';
import 'admin_positions_viewmodel.dart';

class AdminPositionsTab extends ConsumerWidget {
  const AdminPositionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPositionsProvider);
    final branchesState = ref.watch(adminBranchesProvider);

    // Оборачиваем вкладку в Scaffold, чтобы добавить FloatingActionButton
    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // ДОБАВЛЕНА ПЛАВАЮЩАЯ КНОПКА ДЛЯ СОЗДАНИЯ
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C3AED),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Сбрасываем выбранную ячейку (чтобы форма открылась пустой)
          ref.read(editingPositionProvider.notifier).state = null;
          // Открываем правую шторку с формой
          Scaffold.of(context).openEndDrawer();
        },
      ),

      body: Column(
        children: [
          // Верхняя панель управления
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1C1C1E),
            child: Row(
              children: [
                // Выбор филиала
                SizedBox(
                  width: 250,
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
                      onChanged: (val) => ref.read(adminPositionsProvider.notifier).setBranchFilter(val),
                    ),
                  ),
                ),
                const Spacer(),
                // Кнопка печати выбранных
                if (state.selectedPositionIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => ref.read(adminPositionsProvider.notifier).exportSelectedToPdf(),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                      icon: const Icon(Icons.print, size: 18),
                      label: Text("Печать (${state.selectedPositionIds.length})"),
                    ),
                  ),
                if (state.selectedPositionIds.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_all, color: Colors.white54),
                    onPressed: () => ref.read(adminPositionsProvider.notifier).clearSelection(),
                    tooltip: "Сбросить выбор",
                  ),
              ],
            ),
          ),

          // Список ячеек
          Expanded(
            child: state.isLoading && state.positions.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
                : state.filteredPositions.isEmpty
                    ? const Center(child: Text("Ячейки не найдены", style: TextStyle(color: Colors.white54)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.filteredPositions.length,
                        itemBuilder: (context, index) {
                          final pos = state.filteredPositions[index];
                          final isSelected = state.selectedPositionIds.contains(pos.positionId);

                          return GestureDetector(
                            onTap: () => ref.read(adminPositionsProvider.notifier).toggleSelection(pos.positionId),
                            onLongPress: () {
                              ref.read(editingPositionProvider.notifier).state = pos;
                              Scaffold.of(context).openEndDrawer();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF7C3AED).withOpacity(0.3) : const Color(0xFF1C1C1E),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF7C3AED) : Colors.white10,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    pos.firstLevelStorageType == 'RACK' ? Icons.view_quilt : Icons.inventory_2,
                                    color: isSelected ? Colors.white : Colors.white38,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(pos.fullName, 
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                        Text(pos.firstLevelStorageType, 
                                          style: const TextStyle(color: Colors.white38, fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                  if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class PositionFormPanel extends ConsumerStatefulWidget {
  const PositionFormPanel({super.key});

  @override
  ConsumerState<PositionFormPanel> createState() => _PositionFormPanelState();
}

class _PositionFormPanelState extends ConsumerState<PositionFormPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final success = await ref.read(adminPositionsProvider.notifier).createBulkPositions(values);
      if (success && mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(adminBranchesProvider).branches;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Text("Массовое создание", 
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(
            child: FormBuilder(
              key: _formKey,
              initialValue: const {'storageType': 'RACK', 'startNum': '1', 'count': '1'},
              child: ListView(
                children: [
                  FormBuilderDropdown<int>(
                    name: 'branchId',
                    decoration: _inputDecoration('Филиал'),
                    dropdownColor: const Color(0xFF1C1C1E),
                    style: const TextStyle(color: Colors.white),
                    items: branches.map((b) => DropdownMenuItem(value: b.branchId, child: Text(b.branchName))).toList(),
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(height: 12),
                  _field('zoneCode', 'Код зоны (например, A)'),
                  const SizedBox(height: 12),
                  FormBuilderDropdown<String>(
                    name: 'storageType',
                    decoration: _inputDecoration('Тип хранилища'),
                    dropdownColor: const Color(0xFF1C1C1E),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'RACK', child: Text('Стеллаж')),
                      DropdownMenuItem(value: 'PALLET', child: Text('Паллетное место')),
                    ],
                    onChanged: (val) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  
                  // Поля для структуры стеллажа
                  if (_formKey.currentState?.fields['storageType']?.value == 'RACK') ...[
                    Row(
                      children: [
                        Expanded(child: _numField('shelvesCount', 'Полок')),
                        const SizedBox(width: 12),
                        Expanded(child: _numField('cellsCount', 'Ячеек на полку')),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  Row(
                    children: [
                      Expanded(child: _numField('startNum', 'Начать с №')),
                      const SizedBox(width: 12),
                      Expanded(child: _numField('count', 'Кол-во объектов')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              minimumSize: const Size(double.infinity, 50)
            ),
            child: const Text("СОЗДАТЬ И ПЕЧАТЬ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _field(String name, String label) => FormBuilderTextField(
    name: name, decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: FormBuilderValidators.required(errorText: "Поле обязательно"),
  );

  Widget _numField(String name, String label) => FormBuilderTextField(
    name: name, keyboardType: TextInputType.number,
    decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: FormBuilderValidators.required(errorText: "Поле обязательно"),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, filled: true, fillColor: const Color(0xFF1C1C1E),
    labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  );
}