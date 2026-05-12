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
    if (state.isLoading && state.employees.isEmpty) return const Center(child: CircularProgressIndicator());

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.filteredEmployees.length,
      itemBuilder: (context, index) {
        final emp = state.filteredEmployees[index];
        return Card(
          color: const Color(0xFF1C1C1E),
          child: ListTile(
            leading: const CircleAvatar(backgroundColor: Color(0xFF7C3AED), child: Icon(Icons.person, color: Colors.white)),
            title: Text("${emp.surname} ${emp.name}", style: const TextStyle(color: Colors.white)),
            subtitle: Text(emp.role.name, style: const TextStyle(color: Colors.white54)),
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

  void _submit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final values = _formKey.currentState!.value;
      final result = await ref.read(adminEmployeesProvider.notifier).registerWorkerCombined(values);

      if (result != null && mounted) {
        Navigator.pop(context);
        
        // После создания предлагаем скачать PDF
        await PdfExportService.exportWorkerCredentials(
          fullName: "${values['surname']} ${values['name']}",
          role: values['role'].toString(),
          login: result['login']!,
          password: result['password']!,
        );
      }
    }
  }

// Внутри EmployeeFormPanelState

@override
Widget build(BuildContext context) {
  return FormBuilder(
    key: _formKey,
    child: ListView(
      children: [
        _field('surname', 'Фамилия'),
        const SizedBox(height: 12),
        _field('name', 'Имя'),
        const SizedBox(height: 12),
        
        // ВЫБОР ТИПА ПРОФИЛЯ
        FormBuilderDropdown<String>(
          name: 'profileType',
          decoration: _inputDecoration('Тип профиля'),
          initialValue: 'storekeeper',
          items: const [
            DropdownMenuItem(value: 'storekeeper', child: Text('Сборщик заказов')),
            DropdownMenuItem(value: 'issuer', child: Text('Кассир (Выдача)')),
            DropdownMenuItem(value: 'courier', child: Text('Курьер')),
            DropdownMenuItem(value: 'manager', child: Text('Начальник (Supervisor)')),
            DropdownMenuItem(value: 'admin', child: Text('Администратор')),
          ],
          onChanged: (val) => setState(() {}), // Перестраиваем форму при смене
        ),

        // ПОЛЯ ДЛЯ КУРЬЕРА (показываем только если выбран курьер)
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

        const SizedBox(height: 24),
        const Text("Настройки входа", style: TextStyle(color: Colors.white38)),
        const SizedBox(height: 12),
        _field('username', 'Логин'),
        const SizedBox(height: 32),
        
        ElevatedButton(
          onPressed: _submit, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C3AED),
            minimumSize: const Size(double.infinity, 50)
          ),
          child: const Text("СОЗДАТЬ И СГЕНЕРИРОВАТЬ ПДФ")
        ),
      ],
    ),
  );
}

  Widget _field(String name, String label) => FormBuilderTextField(
    name: name, 
    decoration: _inputDecoration(label),
    style: const TextStyle(color: Colors.white),
    validator: FormBuilderValidators.required(),
  );

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label, filled: true, fillColor: const Color(0xFF1C1C1E),
    labelStyle: const TextStyle(color: Colors.white54),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _numField(String name, String label) {
    return FormBuilderTextField(
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
}