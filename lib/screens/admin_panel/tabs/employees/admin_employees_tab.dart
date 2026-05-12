import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:helper_app/core/models/user/worker_role.dart';
import '../../../../core/services/pdf_export_service.dart';
import 'admin_employees_viewmodel.dart';

// Функция для перевода ролей на русский
String translateWorkerRole(WorkerRole? role) {
  switch (role) {
    case WorkerRole.storekeeper: return "Сборщик заказов";
    case WorkerRole.orderIssuer: return "Кассир (Выдача)";
    case WorkerRole.manager: return "Начальник";
    case WorkerRole.courier: return "Курьер";
    default: return "Сотрудник";
  }
}

class AdminEmployeesTab extends ConsumerWidget {
  const AdminEmployeesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminEmployeesProvider);
    
    if (state.isLoading && state.employees.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
    }

    if (state.filteredEmployees.isEmpty) {
      return const Center(child: Text("Сотрудники не найдены", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredEmployees.length,
      itemBuilder: (context, index) {
        final emp = state.filteredEmployees[index];
        return Card(
          color: const Color(0xFF1C1C1E),
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            onTap: () {
              // Устанавливаем сотрудника для редактирования
              ref.read(editingEmployeeProvider.notifier).state = emp;
              // Открываем боковую панель главного Scaffold
              Scaffold.of(context).openEndDrawer();
            },
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF7C3AED),
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
            title: Text("${emp.surname} ${emp.name}", 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(translateWorkerRole(emp.role as WorkerRole?), 
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: const Icon(Icons.edit, color: Colors.white24, size: 18),
          ),
        );
      },
    );
  }
}

class EmployeeFormPanel extends ConsumerStatefulWidget {
  const EmployeeFormPanel({super.key});

  @override
  ConsumerState<EmployeeFormPanel> createState() => _EmployeeFormPanelState();
}

class _EmployeeFormPanelState extends ConsumerState<EmployeeFormPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Маппинг роли обратно в строку для Dropdown
  String _getProfileTypeFromRole(WorkerRole role) {
    if (role == WorkerRole.courier) return 'courier';
    if (role == WorkerRole.manager) return 'manager';
    if (role == WorkerRole.orderIssuer) return 'issuer';
    return 'storekeeper';
  }

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final editingEmployee = ref.read(editingEmployeeProvider);
      
      if (editingEmployee != null) {
        // Логика обновления
        final updated = editingEmployee.copyWith(
          surname: values['surname'],
          name: values['name'],
          middleName: values['middleName'],
        );
        final success = await ref.read(adminEmployeesProvider.notifier).updateEmployee(updated);
        if (success && mounted) Navigator.pop(context);
      } else {
        // Логика создания
        final result = await ref.read(adminEmployeesProvider.notifier).registerWorkerCombined(values);
        if (result != null && mounted) {
          Navigator.pop(context);
          await PdfExportService.exportWorkerCredentials(
            fullName: "${values['surname']} ${values['name']}",
            role: values['profileType'].toString(),
            login: result['login']!,
            password: result['password']!,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingEmployee = ref.watch(editingEmployeeProvider);
    final isEdit = editingEmployee != null;

    return Container(
      padding: const EdgeInsets.all(24.0),
      color: const Color(0xFF141416),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isEdit ? "Редактировать" : "Новый сотрудник", 
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context))
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: FormBuilder(
              key: _formKey,
              initialValue: isEdit ? {
                'surname': editingEmployee.surname,
                'name': editingEmployee.name,
                'middleName': editingEmployee.middleName,
                'profileType': _getProfileTypeFromRole(editingEmployee.role),
              } : {'profileType': 'storekeeper'},
              child: ListView(
                children: [
                  _field('surname', 'Фамилия'),
                  const SizedBox(height: 12),
                  _field('name', 'Имя'),
                  const SizedBox(height: 12),
                  _field('middleName', 'Отчество', required: false),
                  const SizedBox(height: 12),
                  
                  FormBuilderDropdown<String>(
                    name: 'profileType',
                    decoration: _inputDecoration('Тип профиля'),
                    dropdownColor: const Color(0xFF1C1C1E),
                    style: const TextStyle(color: Colors.white), // Цвет выбранного текста
                    items: const [
                      DropdownMenuItem(value: 'storekeeper', child: Text('Сборщик заказов')),
                      DropdownMenuItem(value: 'issuer', child: Text('Кассир (Выдача)')),
                      DropdownMenuItem(value: 'courier', child: Text('Курьер')),
                      DropdownMenuItem(value: 'manager', child: Text('Начальник (Supervisor)')),
                      DropdownMenuItem(value: 'admin', child: Text('Администратор')),
                    ],
                    onChanged: (val) => setState(() {}),
                  ),

                  if (_formKey.currentState?.fields['profileType']?.value == 'courier') ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(color: Colors.white10)),
                    FormBuilderDropdown<int>(
                      name: 'vehicleType',
                      decoration: _inputDecoration('Тип ТС'),
                      dropdownColor: const Color(0xFF1C1C1E),
                      style: const TextStyle(color: Colors.white),
                      initialValue: 1,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Пеший')),
                        DropdownMenuItem(value: 2, child: Text('Велосипед/Самокат')),
                        DropdownMenuItem(value: 3, child: Text('Легковой авто')),
                        DropdownMenuItem(value: 4, child: Text('Фургон')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _numField('maxWeight', 'Вес (г)')),
                        const SizedBox(width: 12),
                        Expanded(child: _numField('maxLength', 'Длина (мм)')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _numField('maxWidth', 'Ширина (мм)')),
                        const SizedBox(width: 12),
                        Expanded(child: _numField('maxHeight', 'Высота (мм)')),
                      ],
                    ),
                  ],

                  if (!isEdit) ...[
                    const SizedBox(height: 24),
                    const Text("Данные аккаунта", style: TextStyle(color: Colors.white38, fontSize: 12)),
                    const SizedBox(height: 12),
                    _field('username', 'Логин'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isEdit ? "СОХРАНИТЬ ИЗМЕНЕНИЯ" : "СОЗДАТЬ И ПЕЧАТЬ", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _field(String name, String label, {bool required = true}) => FormBuilderTextField(
    name: name, 
    decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: required ? FormBuilderValidators.required(errorText: 'Обязательное поле') : null,
  );

  Widget _numField(String name, String label) => FormBuilderTextField(
    name: name,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white),
    decoration: _inputDecoration(label),
    initialValue: '0',
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.numeric(),
    ]),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, filled: true, fillColor: const Color(0xFF1C1C1E),
    labelStyle: const TextStyle(color: Colors.white54, fontSize: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF7C3AED))),
  );
}