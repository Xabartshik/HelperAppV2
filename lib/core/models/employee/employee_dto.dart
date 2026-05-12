import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_dto.freezed.dart';
part 'employee_dto.g.dart';

enum WorkerRole {
  @JsonValue(0) warehouseWorker,
  @JsonValue(1) courier,
  @JsonValue(2) supervisor,
  @JsonValue(3) admin,
  @JsonValue(100) unknown
}

@freezed
class EmployeeDto with _$EmployeeDto {
  const factory EmployeeDto({
    @Default(0) int employeesId,
    required String surname,
    required String name,
    String? middleName,
    @Default(WorkerRole.warehouseWorker) WorkerRole role,
  }) = _EmployeeDto;

  factory EmployeeDto.fromJson(Map<String, dynamic> json) => _$EmployeeDtoFromJson(json);
}