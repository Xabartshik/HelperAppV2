import 'package:freezed_annotation/freezed_annotation.dart';

part 'break_status_dto.freezed.dart';
part 'break_status_dto.g.dart';

@freezed
class BreakStatusDto with _$BreakStatusDto {
  const factory BreakStatusDto({
    @Default(false) bool isOnBreak,
    @Default(0) int accumulatedMinutes,
    @Default(false) bool canStartBreak,
    @Default(false) bool isLimitReached,
    @Default(false) bool hasActiveTasks,
  }) = _BreakStatusDto;

  factory BreakStatusDto.fromJson(Map<String, dynamic> json) =>
      _$BreakStatusDtoFromJson(json);
}