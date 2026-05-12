import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_dto.freezed.dart';
part 'employee_dto.g.dart';

enum WorkerRole {
  @JsonValue(1) 
  storekeeper,   // Сборщик заказов (был warehouseWorker)

  @JsonValue(2) 
  orderIssuer,   // Кассир / Выдача (был supervisor)

  @JsonValue(3) 
  manager,       // Начальник (был admin)

  @JsonValue(4) 
  courier,       // Курьер (теперь соответствует C#)

  @JsonValue(100) 
  unknown
}

@freezed
class EmployeeDto with _$EmployeeDto {
  const factory EmployeeDto({
    @Default(0) int employeesId,
    required String surname,
    required String name,
    String? middleName,
    @Default(WorkerRole.storekeeper) WorkerRole role,
  }) = _EmployeeDto;

  factory EmployeeDto.fromJson(Map<String, dynamic> json) => _$EmployeeDtoFromJson(json);
}