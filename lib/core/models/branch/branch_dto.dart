import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_dto.freezed.dart';
part 'branch_dto.g.dart';

@freezed
class BranchDto with _$BranchDto {
  const factory BranchDto({
    @Default(0) int branchId,
    @Default('') String branchName,
    @Default('') String branchType,
    @Default('') String address,
  }) = _BranchDto;

  factory BranchDto.fromJson(Map<String, dynamic> json) => _$BranchDtoFromJson(json);
}