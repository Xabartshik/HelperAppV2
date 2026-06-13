import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/employee/employee_dto.dart';
import '../../../../core/utils/logger.dart';

class AdminEmployeesState {
  final bool isLoading;
  final List<EmployeeDto> employees;
  final String searchQuery;

  AdminEmployeesState({this.isLoading = false, this.employees = const [], this.searchQuery = ''});

  AdminEmployeesState copyWith({bool? isLoading, List<EmployeeDto>? employees, String? searchQuery}) {
    return AdminEmployeesState(
      isLoading: isLoading ?? this.isLoading,
      employees: employees ?? this.employees,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<EmployeeDto> get filteredEmployees {
    if (searchQuery.isEmpty) return employees;
    final q = searchQuery.toLowerCase();
    return employees.where((e) => 
      e.name.toLowerCase().contains(q) || e.surname.toLowerCase().contains(q)
    ).toList();
  }
}

// Провайдер для редактируемого сотрудника
final editingEmployeeProvider = StateProvider<EmployeeDto?>((ref) => null);

final adminEmployeesProvider = AutoDisposeNotifierProvider<AdminEmployeesViewModel, AdminEmployeesState>(
  () => AdminEmployeesViewModel(),
);

class AdminEmployeesViewModel extends AutoDisposeNotifier<AdminEmployeesState> {
  @override
  AdminEmployeesState build() {
    Future.microtask(() => loadEmployees());
    return AdminEmployeesState();
  }

  Future<void> loadEmployees() async {
    state = state.copyWith(isLoading: true);
    final list = await ref.read(apiClientProvider).getEmployeesAsync();
    state = state.copyWith(employees: list, isLoading: false);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  String generateRandomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(8, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

  Future<bool> updateEmployee(EmployeeDto employee) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updateEmployeeAsync(employee);
    if (success) await loadEmployees();
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<Map<String, String>?> registerWorkerCombined(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      final profile = data['profileType'] as String;
      final (workerRole, mobileRole) = _getRoleMapping(profile);

      int employeeId = -1;

      if (profile == 'courier') {
        employeeId = await ref.read(apiClientProvider).createCourierAsync({
          'surname': data['surname'],
          'name': data['name'],
          'middleName': data['middleName'] ?? '',
          'vehicleTypeId': data['vehicleType'],
          'maxWeightGrams': double.parse(data['maxWeight'].toString()),
          'maxLengthMm': double.parse(data['maxLength'].toString()),
          'maxWidthMm': double.parse(data['maxWidth'].toString()),
          'maxHeightMm': double.parse(data['maxHeight'].toString()),
        });
      } else {
        employeeId = await ref.read(apiClientProvider).createEmployeeAsync({
          'surname': data['surname'],
          'name': data['name'],
          'middleName': data['middleName'] ?? '',
          'role': workerRole,
        });
      }

      if (employeeId <= 0) return null;

      final password = generateRandomPassword();
      final success = await ref.read(apiClientProvider).createMobileAppUserAsync({
        'login': data['username'],      // В DTO свойство называется Login
        'password': password,           // В DTO свойство называется Password
        'role': mobileRole,             // Enum MobileUserRole
        'employeeId': employeeId,       // Привязка к созданному сотруднику
        // 'branchId': null             // Опционально, если админ привязывает к филиалу
      });

      if (success) {
        await loadEmployees();
        return {'login': data['username'], 'password': password};
      }
      return null;
    } catch (e) {
      Logger.e('Ошибка регистрации', e);
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  (int, int) _getRoleMapping(String profile) {
    return switch (profile) {
      'admin' => (3, 3),   // Manager, Admin
      'manager' => (3, 2), // Manager, Supervisor
      'courier' => (4, 5), // Courier, Courier
      'issuer' => (2, 1),  // Issuer, Worker
      _ => (1, 1),         // Storekeeper, Worker
    };
  }

  // Блокировка или разблокировка сотрудника
  Future<void> toggleBlockStatus(EmployeeDto emp) async {
    final client = ref.read(apiClientProvider);
    final newState = !emp.isBlocked;
    bool success = false;
    if (newState) {
      success = await client.blockEmployeeAsync(emp.employeesId);
    } else {
      success = await client.unblockEmployeeAsync(emp.employeesId);
    }
    if (success) {
      await loadEmployees();
    }
  }
}