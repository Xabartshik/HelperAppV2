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

final adminEmployeesProvider = AutoDisposeNotifierProvider<AdminEmployeesViewModel, AdminEmployeesState>(
  () => AdminEmployeesViewModel(),
);
class RoleMapper {
  static (int workerRole, int mobileRole) getMapping(String profileType) {
    return switch (profileType) {
      'admin'      => (3, 3), // WorkerRole.Manager (3), MobileUserRole.Admin (3)
      'manager'    => (3, 2), // WorkerRole.Manager (3), MobileUserRole.Supervisor (2)
      'courier'    => (4, 5), // WorkerRole.Courier (4), MobileUserRole.Courier (5)
      'storekeeper'=> (1, 1), // WorkerRole.Storekeeper (1), MobileUserRole.Worker (1)
      'issuer'     => (2, 1), // WorkerRole.OrderIssuer (2), MobileUserRole.Worker (1)
      _            => (1, 0),
    };
  }
}

final editingEmployeeProvider = StateProvider<EmployeeDto?>((ref) => null);

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

  Future<bool> updateEmployee(EmployeeDto employee) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updateEmployeeAsync(employee);
    if (success) await loadEmployees();
    state = state.copyWith(isLoading: false);
    return success;
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  String generateRandomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(Iterable.generate(8, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
  }

// В методе registerWorkerCombined во ViewModel:
Future<Map<String, String>?> registerWorkerCombined(Map<String, dynamic> data) async {
  state = state.copyWith(isLoading: true);
  
  try {
    final profile = data['profileType'] as String;
    final (workerRole, mobileRole) = RoleMapper.getMapping(profile);

    int employeeId = -1;

    // ШАГ 1: Создание физической записи
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

    if (employeeId <= 0) throw Exception('Ошибка создания сотрудника');

    // ШАГ 2: Создание аккаунта
    final password = generateRandomPassword();
    final success = await ref.read(apiClientProvider).registerMobileUserAsync({
      'username': data['username'],
      'password': password,
      'firstName': data['name'],
      'lastName': data['surname'],
      'role': mobileRole,
      'employeeId': employeeId,
      'isActive': true
    });

    if (success) {
      await loadEmployees();
      return {'login': data['username'], 'password': password};
    }
    return null;
  } catch (e) {
    Logger.e('Регистрация прервана', e);
    return null;
  } finally {
    state = state.copyWith(isLoading: false);
  }
}

}