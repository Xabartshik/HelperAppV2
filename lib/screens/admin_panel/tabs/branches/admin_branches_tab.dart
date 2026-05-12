import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:helper_app/core/models/branch/branch_dto.dart';
import 'admin_branches_viewmodel.dart';

class AdminBranchesTab extends ConsumerWidget {
  const AdminBranchesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminBranchesProvider);

    if (state.isLoading && state.branches.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      // endDrawer должен быть определен здесь, чтобы openEndDrawer() работал
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.4,
        backgroundColor: const Color(0xFF0F0F12),
        child: const BranchFormPanel(),
      ),
      body: state.filteredBranches.isEmpty
          ? const Center(
              child: Text("Ничего не найдено", style: TextStyle(color: Colors.white54)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.filteredBranches.length,
              itemBuilder: (context, index) {
                final branch = state.filteredBranches[index];
                return Card(
                  color: const Color(0xFF1C1C1E),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    onTap: () {
                      // 1. Записываем выбранный филиал в провайдер редактирования
                      ref.read(editingBranchProvider.notifier).state = branch;
                      // 2. Открываем боковую панель
                      Scaffold.of(context).openEndDrawer();
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF7C3AED),
                      child: Icon(Icons.business, color: Colors.white, size: 18),
                    ),
                    title: Text(
                      branch.branchName,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(branch.address, style: const TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                  ),
                );
              },
            ),
    );
  }
}

// === УНИВЕРСАЛЬНАЯ ФОРМА (СОЗДАНИЕ / РЕДАКТИРОВАНИЕ) ===
class BranchFormPanel extends ConsumerStatefulWidget {
  const BranchFormPanel({super.key});

  @override
  ConsumerState<BranchFormPanel> createState() => _BranchFormPanelState();
}

class _BranchFormPanelState extends ConsumerState<BranchFormPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit(bool isEdit, int? existingId) async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = Map<String, dynamic>.from(_formKey.currentState!.value);
      
      // Всегда Warehouse, как договаривались
      values['branchType'] = 'Warehouse'; 

      bool success;
      if (isEdit) {
        // Создаем объект для обновления (используем ваш BranchDto или аналогичный класс)
        final updatedBranch = BranchDto(
          branchId: existingId!,
          branchName: values['branchName'],
          address: values['address'],
          branchType: values['branchType'],
        );
        success = await ref.read(adminBranchesProvider.notifier).updateBranch(updatedBranch);
      } else {
        success = await ref.read(adminBranchesProvider.notifier).createBranch(values);
      }

      if (success && mounted) {
        Navigator.pop(context); // Закрываем панель
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Обновлено!' : 'Филиал успешно создан!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Слушаем провайдер: если там есть данные — мы в режиме редактирования
    final editingBranch = ref.watch(editingBranchProvider);
    final isEdit = editingBranch != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEdit ? "Редактировать" : "Новый филиал",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                // Подставляем данные филиала, если редактируем
                initialValue: isEdit ? {
                  'branchName': editingBranch.branchName,
                  'address': editingBranch.address,
                } : {},
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'branchName',
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Название филиала'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Обязательное поле'),
                        FormBuilderValidators.maxLength(200),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'address',
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Физический адрес'),
                      maxLines: 3,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(errorText: 'Обязательное поле'),
                        FormBuilderValidators.maxLength(500),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _submit(isEdit, editingBranch?.branchId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isEdit ? 'СОХРАНИТЬ ИЗМЕНЕНИЯ' : 'СОЗДАТЬ',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF7C3AED)),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}