import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_io_employee_dto.freezed.dart';
part 'check_io_employee_dto.g.dart';

@freezed
class CheckIOEmployeeDto with _$CheckIOEmployeeDto {
  const factory CheckIOEmployeeDto({
    required int id,
    required int employeeId,
    required int branchId,
    required String checkType, // "in" или "out"
    required DateTime checkTimeStamp,
  }) = _CheckIOEmployeeDto;

  factory CheckIOEmployeeDto.fromJson(Map<String, dynamic> json) =>
      _$CheckIOEmployeeDtoFromJson(json);
}