// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position_cell_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PositionCellDto _$PositionCellDtoFromJson(Map<String, dynamic> json) {
  return _PositionCellDto.fromJson(json);
}

/// @nodoc
mixin _$PositionCellDto {
  int get positionId => throw _privateConstructorUsedError;
  int get branchId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get zoneCode => throw _privateConstructorUsedError;
  String get firstLevelStorageType => throw _privateConstructorUsedError;
  String get flsNumber => throw _privateConstructorUsedError;
  String? get secondLevelStorage => throw _privateConstructorUsedError;
  String? get thirdLevelStorage => throw _privateConstructorUsedError;
  double get length => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  /// Serializes this PositionCellDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionCellDtoCopyWith<PositionCellDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCellDtoCopyWith<$Res> {
  factory $PositionCellDtoCopyWith(
    PositionCellDto value,
    $Res Function(PositionCellDto) then,
  ) = _$PositionCellDtoCopyWithImpl<$Res, PositionCellDto>;
  @useResult
  $Res call({
    int positionId,
    int branchId,
    String status,
    String zoneCode,
    String firstLevelStorageType,
    String flsNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
    double length,
    double width,
    double height,
  });
}

/// @nodoc
class _$PositionCellDtoCopyWithImpl<$Res, $Val extends PositionCellDto>
    implements $PositionCellDtoCopyWith<$Res> {
  _$PositionCellDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positionId = null,
    Object? branchId = null,
    Object? status = null,
    Object? zoneCode = null,
    Object? firstLevelStorageType = null,
    Object? flsNumber = null,
    Object? secondLevelStorage = freezed,
    Object? thirdLevelStorage = freezed,
    Object? length = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(
      _value.copyWith(
            positionId: null == positionId
                ? _value.positionId
                : positionId // ignore: cast_nullable_to_non_nullable
                      as int,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            zoneCode: null == zoneCode
                ? _value.zoneCode
                : zoneCode // ignore: cast_nullable_to_non_nullable
                      as String,
            firstLevelStorageType: null == firstLevelStorageType
                ? _value.firstLevelStorageType
                : firstLevelStorageType // ignore: cast_nullable_to_non_nullable
                      as String,
            flsNumber: null == flsNumber
                ? _value.flsNumber
                : flsNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            secondLevelStorage: freezed == secondLevelStorage
                ? _value.secondLevelStorage
                : secondLevelStorage // ignore: cast_nullable_to_non_nullable
                      as String?,
            thirdLevelStorage: freezed == thirdLevelStorage
                ? _value.thirdLevelStorage
                : thirdLevelStorage // ignore: cast_nullable_to_non_nullable
                      as String?,
            length: null == length
                ? _value.length
                : length // ignore: cast_nullable_to_non_nullable
                      as double,
            width: null == width
                ? _value.width
                : width // ignore: cast_nullable_to_non_nullable
                      as double,
            height: null == height
                ? _value.height
                : height // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PositionCellDtoImplCopyWith<$Res>
    implements $PositionCellDtoCopyWith<$Res> {
  factory _$$PositionCellDtoImplCopyWith(
    _$PositionCellDtoImpl value,
    $Res Function(_$PositionCellDtoImpl) then,
  ) = __$$PositionCellDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int positionId,
    int branchId,
    String status,
    String zoneCode,
    String firstLevelStorageType,
    String flsNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
    double length,
    double width,
    double height,
  });
}

/// @nodoc
class __$$PositionCellDtoImplCopyWithImpl<$Res>
    extends _$PositionCellDtoCopyWithImpl<$Res, _$PositionCellDtoImpl>
    implements _$$PositionCellDtoImplCopyWith<$Res> {
  __$$PositionCellDtoImplCopyWithImpl(
    _$PositionCellDtoImpl _value,
    $Res Function(_$PositionCellDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? positionId = null,
    Object? branchId = null,
    Object? status = null,
    Object? zoneCode = null,
    Object? firstLevelStorageType = null,
    Object? flsNumber = null,
    Object? secondLevelStorage = freezed,
    Object? thirdLevelStorage = freezed,
    Object? length = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(
      _$PositionCellDtoImpl(
        positionId: null == positionId
            ? _value.positionId
            : positionId // ignore: cast_nullable_to_non_nullable
                  as int,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        zoneCode: null == zoneCode
            ? _value.zoneCode
            : zoneCode // ignore: cast_nullable_to_non_nullable
                  as String,
        firstLevelStorageType: null == firstLevelStorageType
            ? _value.firstLevelStorageType
            : firstLevelStorageType // ignore: cast_nullable_to_non_nullable
                  as String,
        flsNumber: null == flsNumber
            ? _value.flsNumber
            : flsNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        secondLevelStorage: freezed == secondLevelStorage
            ? _value.secondLevelStorage
            : secondLevelStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
        thirdLevelStorage: freezed == thirdLevelStorage
            ? _value.thirdLevelStorage
            : thirdLevelStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
        length: null == length
            ? _value.length
            : length // ignore: cast_nullable_to_non_nullable
                  as double,
        width: null == width
            ? _value.width
            : width // ignore: cast_nullable_to_non_nullable
                  as double,
        height: null == height
            ? _value.height
            : height // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionCellDtoImpl extends _PositionCellDto {
  const _$PositionCellDtoImpl({
    this.positionId = 0,
    required this.branchId,
    this.status = "Active",
    required this.zoneCode,
    required this.firstLevelStorageType,
    required this.flsNumber,
    this.secondLevelStorage,
    this.thirdLevelStorage,
    this.length = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  }) : super._();

  factory _$PositionCellDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionCellDtoImplFromJson(json);

  @override
  @JsonKey()
  final int positionId;
  @override
  final int branchId;
  @override
  @JsonKey()
  final String status;
  @override
  final String zoneCode;
  @override
  final String firstLevelStorageType;
  @override
  final String flsNumber;
  @override
  final String? secondLevelStorage;
  @override
  final String? thirdLevelStorage;
  @override
  @JsonKey()
  final double length;
  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;

  @override
  String toString() {
    return 'PositionCellDto(positionId: $positionId, branchId: $branchId, status: $status, zoneCode: $zoneCode, firstLevelStorageType: $firstLevelStorageType, flsNumber: $flsNumber, secondLevelStorage: $secondLevelStorage, thirdLevelStorage: $thirdLevelStorage, length: $length, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionCellDtoImpl &&
            (identical(other.positionId, positionId) ||
                other.positionId == positionId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.zoneCode, zoneCode) ||
                other.zoneCode == zoneCode) &&
            (identical(other.firstLevelStorageType, firstLevelStorageType) ||
                other.firstLevelStorageType == firstLevelStorageType) &&
            (identical(other.flsNumber, flsNumber) ||
                other.flsNumber == flsNumber) &&
            (identical(other.secondLevelStorage, secondLevelStorage) ||
                other.secondLevelStorage == secondLevelStorage) &&
            (identical(other.thirdLevelStorage, thirdLevelStorage) ||
                other.thirdLevelStorage == thirdLevelStorage) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    positionId,
    branchId,
    status,
    zoneCode,
    firstLevelStorageType,
    flsNumber,
    secondLevelStorage,
    thirdLevelStorage,
    length,
    width,
    height,
  );

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionCellDtoImplCopyWith<_$PositionCellDtoImpl> get copyWith =>
      __$$PositionCellDtoImplCopyWithImpl<_$PositionCellDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionCellDtoImplToJson(this);
  }
}

abstract class _PositionCellDto extends PositionCellDto {
  const factory _PositionCellDto({
    final int positionId,
    required final int branchId,
    final String status,
    required final String zoneCode,
    required final String firstLevelStorageType,
    required final String flsNumber,
    final String? secondLevelStorage,
    final String? thirdLevelStorage,
    final double length,
    final double width,
    final double height,
  }) = _$PositionCellDtoImpl;
  const _PositionCellDto._() : super._();

  factory _PositionCellDto.fromJson(Map<String, dynamic> json) =
      _$PositionCellDtoImpl.fromJson;

  @override
  int get positionId;
  @override
  int get branchId;
  @override
  String get status;
  @override
  String get zoneCode;
  @override
  String get firstLevelStorageType;
  @override
  String get flsNumber;
  @override
  String? get secondLevelStorage;
  @override
  String? get thirdLevelStorage;
  @override
  double get length;
  @override
  double get width;
  @override
  double get height;

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionCellDtoImplCopyWith<_$PositionCellDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
