import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../../../core/services/pdf_export_service.dart';
import 'admin_employees_viewmodel.dart';

class AdminEmployeesTab extends ConsumerWidget {
  const AdminEmployeesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminEmployeesProvider);
    
    if (state.isLoading && state.employees.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7C3AED),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Сбрасываем состояние редактирования при создании нового
          ref.read(editingEmployeeProvider.notifier).state = null;
          Scaffold.of(context).openEndDrawer();
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.filteredEmployees.length,
        itemBuilder: (context, index) {
          final emp = state.filteredEmployees[index];
          return Card(
            color: const Color(0xFF1C1C1E),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              // Логика выбора сотрудника для редактирования
              onTap: () {
                ref.read(editingEmployeeProvider.notifier).state = emp;
                Scaffold.of(context).openEndDrawer();
              },
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF7C3AED),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                "${emp.surname} ${emp.name}",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                emp.role.name,
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.edit, color: Colors.white24, size: 20),
            ),
          );
        },
      ),
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

  // Вспомогательный метод для преобразования роли обратно в ключ для Dropdown
  String _reverseMapRole(dynamic role) {
    // Если role - это enum или объект с полем name/value
    return role.toString().split('.').last.toLowerCase();
  }

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = Map<String, dynamic>.from(_formKey.currentState!.value);
      final editingEmployee = ref.read(editingEmployeeProvider);
      
      if (editingEmployee == null) {
        // Создание нового сотрудника
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
      } else {
        // Обновление существующего сотрудника
        // Создаем обновленный DTO на основе текущих данных
        final updatedDto = editingEmployee.copyWith(
          name: values['name'],
          surname: values['surname'],
          middleName: values['middleName'],
          // Роль обновляется через ViewModel в зависимости от профиля
        );
        
        final success = await ref.read(adminEmployeesProvider.notifier).updateEmployee(updatedDto);
        if (success && mounted) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editingEmployee = ref.watch(editingEmployeeProvider);
    final isEdit = editingEmployee != null;

    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF09090B),
      child: FormBuilder(
        key: _formKey,
        initialValue: isEdit ? {
          'surname': editingEmployee.surname,
          'name': editingEmployee.name,
          'middleName': editingEmployee.middleName ?? '',
          'profileType': _reverseMapRole(editingEmployee.role),
        } : {
          'profileType': 'storekeeper',
        },
        child: ListView(
          children: [
            Text(
              isEdit ? "Редактировать данные" : "Новый сотрудник",
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 24),
            
            _field('surname', 'Фамилия'),
            const SizedBox(height: 12),
            _field('name', 'Имя'),
            const SizedBox(height: 12),
            _field('middleName', 'Отчество (при наличии)', required: false),
            const SizedBox(height: 24),
            
            FormBuilderDropdown<String>(
              name: 'profileType',
              decoration: _inputDecoration('Тип профиля'),
              items: const [
                DropdownMenuItem(value: 'storekeeper', child: Text('Сборщик заказов')),
                DropdownMenuItem(value: 'issuer', child: Text('Кассир (Выдача)')),
                DropdownMenuItem(value: 'courier', child: Text('Курьер')),
                DropdownMenuItem(value: 'manager', child: Text('Начальник (Supervisor)')),
                DropdownMenuItem(value: 'admin', child: Text('Администратор')),
              ],
              onChanged: (val) => setState(() {}),
            ),

            // Поля для курьера
            if (_formKey.currentState?.fields['profileType']?.value == 'courier') ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white10),
              ),
              const Text("Транспортное средство", style: TextStyle(color: Colors.white38)),
              const SizedBox(height: 12),
              FormBuilderDropdown<int>(
                name: 'vehicleType',
                decoration: _inputDecoration('Тип ТС'),
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
                  Expanded(child: _numField('maxWeight', 'Грузоподъемность (г)')),
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

            // Настройки входа (только при создании)
            if (!isEdit) ...[
              const SizedBox(height: 24),
              const Text("Настройки входа", style: TextStyle(color: Colors.white38)),
              const SizedBox(height: 12),
              _field('username', 'Логин'),
            ],

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              child: Text(
                isEdit ? "СОХРАНИТЬ ИЗМЕНЕНИЯ" : "СОЗДАТЬ И ПЕЧАТЬ",
                style: const TextStyle(fontWeight: FontWeight.bold)
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String name, String label, {bool required = true}) => FormBuilderTextField(
    name: name, 
    decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: required ? FormBuilderValidators.required(errorText: 'Обязательное поле') : null,
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, 
    filled: true, 
    fillColor: const Color(0xFF1C1C1E),
    labelStyle: const TextStyle(color: Colors.white54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1)
    ),
  );

  Widget _numField(String name, String label) => FormBuilderTextField(
    name: name,
    keyboardType: TextInputType.number,
    style: const TextStyle(color: Colors.white),
    decoration: _inputDecoration(label),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Обязательное поле'),
      FormBuilderValidators.numeric(errorText: 'Только числа'),
    ]),
  );
}