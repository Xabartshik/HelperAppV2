import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:helper_app/core/models/user/worker_role.dart';

part 'employee_dto.freezed.dart';
part 'employee_dto.g.dart';
@freezed
class EmployeeDto with _$EmployeeDto {
  const factory EmployeeDto({
    @Default(0) int employeesId,
    required String surname,
    required String name,
    String? middleName,
    @Default(WorkerRole.storekeeper) WorkerRole role,
    @Default(false) bool isBlocked,
  }) = _EmployeeDto;

  factory EmployeeDto.fromJson(Map<String, dynamic> json) => _$EmployeeDtoFromJson(json);
}