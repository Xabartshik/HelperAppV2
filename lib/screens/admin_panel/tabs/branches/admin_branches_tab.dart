import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
      // Встроенная боковая шторка для формы добавления
      endDrawer: const Drawer(
        width: 400, // Фиксированная ширина панели на десктопе
        backgroundColor: Color(0xFF2C2C2E),
        child: _BranchFormPanel(),
      ),
      body: state.branches.isEmpty
          ? const Center(child: Text("Филиалов пока нет", style: TextStyle(color: Colors.white54)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.branches.length,
              itemBuilder: (context, index) {
                final branch = state.branches[index];
                return Card(
                  color: const Color(0xFF1C1C1E),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF7C3AED),
                      child: Icon(Icons.business, color: Colors.white, size: 18),
                    ),
                    title: Text(branch.branchName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text('${branch.branchType} • ${branch.address}', style: const TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white24),
                  ),
                );
              },
            ),
    );
  }
}

// === ФОРМА ДОБАВЛЕНИЯ ===
class _BranchFormPanel extends ConsumerStatefulWidget {
  const _BranchFormPanel();

  @override
  ConsumerState<_BranchFormPanel> createState() => _BranchFormPanelState();
}

class _BranchFormPanelState extends ConsumerState<_BranchFormPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      
      final success = await ref.read(adminBranchesProvider.notifier).createBranch(formData);
      
      if (success && mounted) {
        Navigator.pop(context); // Закрываем боковую панель при успехе
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Филиал успешно создан!'), backgroundColor: Colors.green),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Новый филиал", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                child: Column(
                  children: [
                    // Поле: Название филиала
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
                    
                    // Поле: Тип филиала
                    FormBuilderDropdown<String>(
                      name: 'branchType',
                      dropdownColor: const Color(0xFF1C1C1E),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('Тип филиала'),
                      items: const [
                        DropdownMenuItem(value: 'Main', child: Text('Главный склад')),
                        DropdownMenuItem(value: 'Transit', child: Text('Транзитный узел')),
                        DropdownMenuItem(value: 'Retail', child: Text('Розничная точка')),
                      ],
                      validator: FormBuilderValidators.required(errorText: 'Выберите тип'),
                    ),
                    const SizedBox(height: 16),

                    // Поле: Адрес
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
          // Кнопка сохранения
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('СОХРАНИТЬ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED))),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}