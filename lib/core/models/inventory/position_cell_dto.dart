import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_cell_dto.freezed.dart';
part 'position_cell_dto.g.dart';

@freezed
class PositionCellDto with _$PositionCellDto {
  // Добавьте эту строку:
  const PositionCellDto._();

  const factory PositionCellDto({
    @Default(0) int positionId,
    required int branchId,
    @Default("Active") String status,
    required String zoneCode,
    required String firstLevelStorageType,
    required String flsNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
    @Default(0.0) double length,
    @Default(0.0) double width,
    @Default(0.0) double height,
  }) = _PositionCellDto;

  factory PositionCellDto.fromJson(Map<String, dynamic> json) => _$PositionCellDtoFromJson(json);

  String get fullName {
    String name = "$zoneCode-$flsNumber";
    if (secondLevelStorage != null && secondLevelStorage!.isNotEmpty) {
      name += "-$secondLevelStorage";
    }
    if (thirdLevelStorage != null && thirdLevelStorage!.isNotEmpty) {
      name += "-$thirdLevelStorage";
    }
    return name;
  }
}