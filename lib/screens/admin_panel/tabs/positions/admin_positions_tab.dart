import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:helper_app/screens/admin_panel/tabs/branches/admin_branches_viewmodel.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'admin_positions_viewmodel.dart';

void _showQrDialog(BuildContext context, String data) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1C1C1E),
      title: Text(data, style: const TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center),
      content: SizedBox(
        width: 250,
        height: 250,
        child: Center(
          child: QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("ЗАКРЫТЬ", style: TextStyle(color: Color(0xFF7C3AED))),
        )
      ],
    ),
  );
}

class AdminPositionsTab extends ConsumerWidget {
  const AdminPositionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminPositionsProvider);
    final branchesState = ref.watch(adminBranchesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      
      // Динамические плавающие кнопки (справа внизу)
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Если выбрана ровно ОДНА ячейка, показываем доп. действия
          if (state.selectedPositionIds.length == 1) ...[
            FloatingActionButton.small(
              heroTag: 'qr_btn',
              backgroundColor: const Color(0xFF2C2C2E),
              tooltip: 'Показать QR код',
              onPressed: () {
                final posId = state.selectedPositionIds.first;
                final pos = state.positions.firstWhere((p) => p.positionId == posId);
                _showQrDialog(context, pos.fullName);
              },
              child: const Icon(Icons.qr_code, color: Colors.white),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.small(
              heroTag: 'edit_btn',
              backgroundColor: const Color(0xFF2C2C2E),
              tooltip: 'Редактировать ячейку',
              onPressed: () {
                final posId = state.selectedPositionIds.first;
                final pos = state.positions.firstWhere((p) => p.positionId == posId);
                ref.read(editingPositionProvider.notifier).state = pos;
                Scaffold.of(context).openEndDrawer();
              },
              child: const Icon(Icons.edit, color: Colors.white),
            ),
            const SizedBox(height: 8),
          ],
          
          // Основная кнопка "Добавить"
          FloatingActionButton(
            heroTag: 'add_pos_btn',
            backgroundColor: const Color(0xFF7C3AED),
            tooltip: 'Создать новые ячейки',
            onPressed: () {
              ref.read(editingPositionProvider.notifier).state = null;
              Scaffold.of(context).openEndDrawer();
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1C1C1E),
            child: Row(
              children: [
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

                          return InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => ref.read(adminPositionsProvider.notifier).toggleSelection(pos.positionId),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF7C3AED).withOpacity(0.3) : const Color(0xFF1C1C1E),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF7C3AED) : Colors.white10,
                                  width: 1.5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    pos.firstLevelStorageType == 'RACK' ? Icons.view_quilt : Icons.inventory_2,
                                    color: isSelected ? Colors.white : Colors.white38,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(pos.fullName, 
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                          maxLines: 1, overflow: TextOverflow.ellipsis),
                                        Text(pos.firstLevelStorageType, 
                                          style: const TextStyle(color: Colors.white38, fontSize: 10),
                                          maxLines: 1, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  if (isSelected) const Icon(Icons.check_circle, color: Colors.white, size: 20),
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
      final editingPosition = ref.read(editingPositionProvider);
      
      if (editingPosition != null) {
        // Редактирование
        final updated = editingPosition.copyWith(
          branchId: values['branchId'],
          zoneCode: values['zoneCode'],
          firstLevelStorageType: values['storageType'],
          flsNumber: values['startNum'].toString(),
          secondLevelStorage: values['shelvesCount']?.toString(),
          thirdLevelStorage: values['cellsCount']?.toString(),
          length: double.tryParse(values['length'].toString()) ?? 0,
          width: double.tryParse(values['width'].toString()) ?? 0,
          height: double.tryParse(values['height'].toString()) ?? 0,
        );
        final success = await ref.read(adminPositionsProvider.notifier).updatePosition(updated);
        if (success && mounted) Navigator.pop(context);
      } else {
        // Создание
        final success = await ref.read(adminPositionsProvider.notifier).createBulkPositions(values);
        if (success && mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingPosition = ref.watch(editingPositionProvider);
    final isEdit = editingPosition != null;
    final branches = ref.watch(adminBranchesProvider).branches;

    // Считываем текущий тип, чтобы форма корректно отобразила поля стеллажа при первом открытии
    final currentStorageType = _formKey.currentState?.fields['storageType']?.value 
                               ?? (isEdit ? editingPosition.firstLevelStorageType : 'RACK');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? "Изменение позиции" : "Добавление позиций", 
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FormBuilder(
              key: _formKey,
              initialValue: isEdit ? {
                'branchId': editingPosition.branchId,
                'zoneCode': editingPosition.zoneCode,
                'storageType': editingPosition.firstLevelStorageType,
                'startNum': editingPosition.flsNumber,
                'count': '1',
                'shelvesCount': editingPosition.secondLevelStorage,
                'cellsCount': editingPosition.thirdLevelStorage,
                'length': editingPosition.length.toString(),
                'width': editingPosition.width.toString(),
                'height': editingPosition.height.toString(),
              } : {
                'storageType': 'RACK', 
                'startNum': '1', 
                'count': '1',
                'length': '0',
                'width': '0',
                'height': '0',
              },
              child: ListView(
                children: [
                  FormBuilderDropdown<int>(
                    name: 'branchId',
                    decoration: _inputDecoration('Филиал'),
                    dropdownColor: const Color(0xFF1C1C1E),
                    style: const TextStyle(color: Colors.white),
                    items: branches.map((b) => DropdownMenuItem(value: b.branchId, child: Text(b.branchName))).toList(),
                    validator: FormBuilderValidators.required(errorText: "Выберите филиал"),
                  ),
                  const SizedBox(height: 12),
                  
                  _field('zoneCode', 'Буквенный код зоны (напр. A, B, X)'),
                  const SizedBox(height: 12),
                  
                  FormBuilderDropdown<String>(
                    name: 'storageType',
                    decoration: _inputDecoration('Тип хранилища'),
                    dropdownColor: const Color(0xFF1C1C1E),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'RACK', child: Text('Стеллаж')),
                      DropdownMenuItem(value: 'PALLET', child: Text('Паллетное место')),
                      DropdownMenuItem(value: 'TABLE', child: Text('Рабочий стол')),
                    ],
                    onChanged: (val) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  
                  // Поля для структуры стеллажа
                  if (currentStorageType == 'RACK') ...[
                    Row(
                      children: [
                        Expanded(child: _numField('shelvesCount', 'Количество полок')),
                        const SizedBox(width: 12),
                        Expanded(child: _numField('cellsCount', 'Ячеек на полке')),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Габариты
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text("Габариты (мм)", style: TextStyle(color: Colors.white54, fontSize: 12)),
                  ),
                  Row(
                    children: [
                      Expanded(child: _numField('length', 'Длина')),
                      const SizedBox(width: 8),
                      Expanded(child: _numField('width', 'Ширина')),
                      const SizedBox(width: 8),
                      Expanded(child: _numField('height', 'Высота')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(child: _numField('startNum', isEdit ? 'Номер позиции' : 'Начальный №')),
                      if (!isEdit) ...[
                        const SizedBox(width: 12),
                        Expanded(child: _numField('count', 'Количество (шт)')),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isEdit ? "СОХРАНИТЬ ИЗМЕНЕНИЯ" : "СОЗДАТЬ И ПЕЧАТЬ", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          )
        ],
      ),
    );
  }

  Widget _field(String name, String label) => FormBuilderTextField(
    name: name, decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: FormBuilderValidators.required(errorText: "Заполните поле"),
  );

  Widget _numField(String name, String label) => FormBuilderTextField(
    name: name, keyboardType: TextInputType.number,
    decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: FormBuilderValidators.required(errorText: "Заполните поле"),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, filled: true, fillColor: const Color(0xFF1C1C1E),
    labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED))),
  );
}