// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PositionCodeDto _$PositionCodeDtoFromJson(Map<String, dynamic> json) {
  return _PositionCodeDto.fromJson(json);
}

/// @nodoc
mixin _$PositionCodeDto {
  int get branchId => throw _privateConstructorUsedError;
  String get zoneCode => throw _privateConstructorUsedError;
  String get firstLevelStorageType => throw _privateConstructorUsedError;
  String get fLSNumber => throw _privateConstructorUsedError;
  String? get secondLevelStorage => throw _privateConstructorUsedError;
  String? get thirdLevelStorage => throw _privateConstructorUsedError;

  /// Serializes this PositionCodeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PositionCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionCodeDtoCopyWith<PositionCodeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCodeDtoCopyWith<$Res> {
  factory $PositionCodeDtoCopyWith(
    PositionCodeDto value,
    $Res Function(PositionCodeDto) then,
  ) = _$PositionCodeDtoCopyWithImpl<$Res, PositionCodeDto>;
  @useResult
  $Res call({
    int branchId,
    String zoneCode,
    String firstLevelStorageType,
    String fLSNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
  });
}

/// @nodoc
class _$PositionCodeDtoCopyWithImpl<$Res, $Val extends PositionCodeDto>
    implements $PositionCodeDtoCopyWith<$Res> {
  _$PositionCodeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PositionCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? zoneCode = null,
    Object? firstLevelStorageType = null,
    Object? fLSNumber = null,
    Object? secondLevelStorage = freezed,
    Object? thirdLevelStorage = freezed,
  }) {
    return _then(
      _value.copyWith(
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int,
            zoneCode: null == zoneCode
                ? _value.zoneCode
                : zoneCode // ignore: cast_nullable_to_non_nullable
                      as String,
            firstLevelStorageType: null == firstLevelStorageType
                ? _value.firstLevelStorageType
                : firstLevelStorageType // ignore: cast_nullable_to_non_nullable
                      as String,
            fLSNumber: null == fLSNumber
                ? _value.fLSNumber
                : fLSNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            secondLevelStorage: freezed == secondLevelStorage
                ? _value.secondLevelStorage
                : secondLevelStorage // ignore: cast_nullable_to_non_nullable
                      as String?,
            thirdLevelStorage: freezed == thirdLevelStorage
                ? _value.thirdLevelStorage
                : thirdLevelStorage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PositionCodeDtoImplCopyWith<$Res>
    implements $PositionCodeDtoCopyWith<$Res> {
  factory _$$PositionCodeDtoImplCopyWith(
    _$PositionCodeDtoImpl value,
    $Res Function(_$PositionCodeDtoImpl) then,
  ) = __$$PositionCodeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int branchId,
    String zoneCode,
    String firstLevelStorageType,
    String fLSNumber,
    String? secondLevelStorage,
    String? thirdLevelStorage,
  });
}

/// @nodoc
class __$$PositionCodeDtoImplCopyWithImpl<$Res>
    extends _$PositionCodeDtoCopyWithImpl<$Res, _$PositionCodeDtoImpl>
    implements _$$PositionCodeDtoImplCopyWith<$Res> {
  __$$PositionCodeDtoImplCopyWithImpl(
    _$PositionCodeDtoImpl _value,
    $Res Function(_$PositionCodeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PositionCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? zoneCode = null,
    Object? firstLevelStorageType = null,
    Object? fLSNumber = null,
    Object? secondLevelStorage = freezed,
    Object? thirdLevelStorage = freezed,
  }) {
    return _then(
      _$PositionCodeDtoImpl(
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int,
        zoneCode: null == zoneCode
            ? _value.zoneCode
            : zoneCode // ignore: cast_nullable_to_non_nullable
                  as String,
        firstLevelStorageType: null == firstLevelStorageType
            ? _value.firstLevelStorageType
            : firstLevelStorageType // ignore: cast_nullable_to_non_nullable
                  as String,
        fLSNumber: null == fLSNumber
            ? _value.fLSNumber
            : fLSNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        secondLevelStorage: freezed == secondLevelStorage
            ? _value.secondLevelStorage
            : secondLevelStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
        thirdLevelStorage: freezed == thirdLevelStorage
            ? _value.thirdLevelStorage
            : thirdLevelStorage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionCodeDtoImpl implements _PositionCodeDto {
  const _$PositionCodeDtoImpl({
    required this.branchId,
    this.zoneCode = '',
    this.firstLevelStorageType = '',
    this.fLSNumber = '',
    this.secondLevelStorage,
    this.thirdLevelStorage,
  });

  factory _$PositionCodeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionCodeDtoImplFromJson(json);

  @override
  final int branchId;
  @override
  @JsonKey()
  final String zoneCode;
  @override
  @JsonKey()
  final String firstLevelStorageType;
  @override
  @JsonKey()
  final String fLSNumber;
  @override
  final String? secondLevelStorage;
  @override
  final String? thirdLevelStorage;

  @override
  String toString() {
    return 'PositionCodeDto(branchId: $branchId, zoneCode: $zoneCode, firstLevelStorageType: $firstLevelStorageType, fLSNumber: $fLSNumber, secondLevelStorage: $secondLevelStorage, thirdLevelStorage: $thirdLevelStorage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionCodeDtoImpl &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.zoneCode, zoneCode) ||
                other.zoneCode == zoneCode) &&
            (identical(other.firstLevelStorageType, firstLevelStorageType) ||
                other.firstLevelStorageType == firstLevelStorageType) &&
            (identical(other.fLSNumber, fLSNumber) ||
                other.fLSNumber == fLSNumber) &&
            (identical(other.secondLevelStorage, secondLevelStorage) ||
                other.secondLevelStorage == secondLevelStorage) &&
            (identical(other.thirdLevelStorage, thirdLevelStorage) ||
                other.thirdLevelStorage == thirdLevelStorage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    branchId,
    zoneCode,
    firstLevelStorageType,
    fLSNumber,
    secondLevelStorage,
    thirdLevelStorage,
  );

  /// Create a copy of PositionCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionCodeDtoImplCopyWith<_$PositionCodeDtoImpl> get copyWith =>
      __$$PositionCodeDtoImplCopyWithImpl<_$PositionCodeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionCodeDtoImplToJson(this);
  }
}

abstract class _PositionCodeDto implements PositionCodeDto {
  const factory _PositionCodeDto({
    required final int branchId,
    final String zoneCode,
    final String firstLevelStorageType,
    final String fLSNumber,
    final String? secondLevelStorage,
    final String? thirdLevelStorage,
  }) = _$PositionCodeDtoImpl;

  factory _PositionCodeDto.fromJson(Map<String, dynamic> json) =
      _$PositionCodeDtoImpl.fromJson;

  @override
  int get branchId;
  @override
  String get zoneCode;
  @override
  String get firstLevelStorageType;
  @override
  String get fLSNumber;
  @override
  String? get secondLevelStorage;
  @override
  String? get thirdLevelStorage;

  /// Create a copy of PositionCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionCodeDtoImplCopyWith<_$PositionCodeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryAssignmentLineWithItemDto _$InventoryAssignmentLineWithItemDtoFromJson(
  Map<String, dynamic> json,
) {
  return _InventoryAssignmentLineWithItemDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryAssignmentLineWithItemDto {
  int get id => throw _privateConstructorUsedError;
  int get itemPositionId => throw _privateConstructorUsedError;
  int get positionId => throw _privateConstructorUsedError;
  int get expectedQuantity => throw _privateConstructorUsedError;
  int? get actualQuantity => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  PositionCodeDto get positionCode => throw _privateConstructorUsedError;

  /// Serializes this InventoryAssignmentLineWithItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryAssignmentLineWithItemDtoCopyWith<
    InventoryAssignmentLineWithItemDto
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAssignmentLineWithItemDtoCopyWith<$Res> {
  factory $InventoryAssignmentLineWithItemDtoCopyWith(
    InventoryAssignmentLineWithItemDto value,
    $Res Function(InventoryAssignmentLineWithItemDto) then,
  ) =
      _$InventoryAssignmentLineWithItemDtoCopyWithImpl<
        $Res,
        InventoryAssignmentLineWithItemDto
      >;
  @useResult
  $Res call({
    int id,
    int itemPositionId,
    int positionId,
    int expectedQuantity,
    int? actualQuantity,
    int itemId,
    String itemName,
    String displayName,
    PositionCodeDto positionCode,
  });

  $PositionCodeDtoCopyWith<$Res> get positionCode;
}

/// @nodoc
class _$InventoryAssignmentLineWithItemDtoCopyWithImpl<
  $Res,
  $Val extends InventoryAssignmentLineWithItemDto
>
    implements $InventoryAssignmentLineWithItemDtoCopyWith<$Res> {
  _$InventoryAssignmentLineWithItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemPositionId = null,
    Object? positionId = null,
    Object? expectedQuantity = null,
    Object? actualQuantity = freezed,
    Object? itemId = null,
    Object? itemName = null,
    Object? displayName = null,
    Object? positionCode = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            itemPositionId: null == itemPositionId
                ? _value.itemPositionId
                : itemPositionId // ignore: cast_nullable_to_non_nullable
                      as int,
            positionId: null == positionId
                ? _value.positionId
                : positionId // ignore: cast_nullable_to_non_nullable
                      as int,
            expectedQuantity: null == expectedQuantity
                ? _value.expectedQuantity
                : expectedQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            actualQuantity: freezed == actualQuantity
                ? _value.actualQuantity
                : actualQuantity // ignore: cast_nullable_to_non_nullable
                      as int?,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            positionCode: null == positionCode
                ? _value.positionCode
                : positionCode // ignore: cast_nullable_to_non_nullable
                      as PositionCodeDto,
          )
          as $Val,
    );
  }

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PositionCodeDtoCopyWith<$Res> get positionCode {
    return $PositionCodeDtoCopyWith<$Res>(_value.positionCode, (value) {
      return _then(_value.copyWith(positionCode: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InventoryAssignmentLineWithItemDtoImplCopyWith<$Res>
    implements $InventoryAssignmentLineWithItemDtoCopyWith<$Res> {
  factory _$$InventoryAssignmentLineWithItemDtoImplCopyWith(
    _$InventoryAssignmentLineWithItemDtoImpl value,
    $Res Function(_$InventoryAssignmentLineWithItemDtoImpl) then,
  ) = __$$InventoryAssignmentLineWithItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int itemPositionId,
    int positionId,
    int expectedQuantity,
    int? actualQuantity,
    int itemId,
    String itemName,
    String displayName,
    PositionCodeDto positionCode,
  });

  @override
  $PositionCodeDtoCopyWith<$Res> get positionCode;
}

/// @nodoc
class __$$InventoryAssignmentLineWithItemDtoImplCopyWithImpl<$Res>
    extends
        _$InventoryAssignmentLineWithItemDtoCopyWithImpl<
          $Res,
          _$InventoryAssignmentLineWithItemDtoImpl
        >
    implements _$$InventoryAssignmentLineWithItemDtoImplCopyWith<$Res> {
  __$$InventoryAssignmentLineWithItemDtoImplCopyWithImpl(
    _$InventoryAssignmentLineWithItemDtoImpl _value,
    $Res Function(_$InventoryAssignmentLineWithItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemPositionId = null,
    Object? positionId = null,
    Object? expectedQuantity = null,
    Object? actualQuantity = freezed,
    Object? itemId = null,
    Object? itemName = null,
    Object? displayName = null,
    Object? positionCode = null,
  }) {
    return _then(
      _$InventoryAssignmentLineWithItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        itemPositionId: null == itemPositionId
            ? _value.itemPositionId
            : itemPositionId // ignore: cast_nullable_to_non_nullable
                  as int,
        positionId: null == positionId
            ? _value.positionId
            : positionId // ignore: cast_nullable_to_non_nullable
                  as int,
        expectedQuantity: null == expectedQuantity
            ? _value.expectedQuantity
            : expectedQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        actualQuantity: freezed == actualQuantity
            ? _value.actualQuantity
            : actualQuantity // ignore: cast_nullable_to_non_nullable
                  as int?,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        positionCode: null == positionCode
            ? _value.positionCode
            : positionCode // ignore: cast_nullable_to_non_nullable
                  as PositionCodeDto,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryAssignmentLineWithItemDtoImpl
    implements _InventoryAssignmentLineWithItemDto {
  const _$InventoryAssignmentLineWithItemDtoImpl({
    required this.id,
    required this.itemPositionId,
    required this.positionId,
    required this.expectedQuantity,
    this.actualQuantity,
    required this.itemId,
    this.itemName = '',
    this.displayName = '',
    required this.positionCode,
  });

  factory _$InventoryAssignmentLineWithItemDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$InventoryAssignmentLineWithItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int itemPositionId;
  @override
  final int positionId;
  @override
  final int expectedQuantity;
  @override
  final int? actualQuantity;
  @override
  final int itemId;
  @override
  @JsonKey()
  final String itemName;
  @override
  @JsonKey()
  final String displayName;
  @override
  final PositionCodeDto positionCode;

  @override
  String toString() {
    return 'InventoryAssignmentLineWithItemDto(id: $id, itemPositionId: $itemPositionId, positionId: $positionId, expectedQuantity: $expectedQuantity, actualQuantity: $actualQuantity, itemId: $itemId, itemName: $itemName, displayName: $displayName, positionCode: $positionCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAssignmentLineWithItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemPositionId, itemPositionId) ||
                other.itemPositionId == itemPositionId) &&
            (identical(other.positionId, positionId) ||
                other.positionId == positionId) &&
            (identical(other.expectedQuantity, expectedQuantity) ||
                other.expectedQuantity == expectedQuantity) &&
            (identical(other.actualQuantity, actualQuantity) ||
                other.actualQuantity == actualQuantity) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.positionCode, positionCode) ||
                other.positionCode == positionCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    itemPositionId,
    positionId,
    expectedQuantity,
    actualQuantity,
    itemId,
    itemName,
    displayName,
    positionCode,
  );

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAssignmentLineWithItemDtoImplCopyWith<
    _$InventoryAssignmentLineWithItemDtoImpl
  >
  get copyWith =>
      __$$InventoryAssignmentLineWithItemDtoImplCopyWithImpl<
        _$InventoryAssignmentLineWithItemDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAssignmentLineWithItemDtoImplToJson(this);
  }
}

abstract class _InventoryAssignmentLineWithItemDto
    implements InventoryAssignmentLineWithItemDto {
  const factory _InventoryAssignmentLineWithItemDto({
    required final int id,
    required final int itemPositionId,
    required final int positionId,
    required final int expectedQuantity,
    final int? actualQuantity,
    required final int itemId,
    final String itemName,
    final String displayName,
    required final PositionCodeDto positionCode,
  }) = _$InventoryAssignmentLineWithItemDtoImpl;

  factory _InventoryAssignmentLineWithItemDto.fromJson(
    Map<String, dynamic> json,
  ) = _$InventoryAssignmentLineWithItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get itemPositionId;
  @override
  int get positionId;
  @override
  int get expectedQuantity;
  @override
  int? get actualQuantity;
  @override
  int get itemId;
  @override
  String get itemName;
  @override
  String get displayName;
  @override
  PositionCodeDto get positionCode;

  /// Create a copy of InventoryAssignmentLineWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryAssignmentLineWithItemDtoImplCopyWith<
    _$InventoryAssignmentLineWithItemDtoImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

InventoryAssignmentDetailedWithItemDto
_$InventoryAssignmentDetailedWithItemDtoFromJson(Map<String, dynamic> json) {
  return _InventoryAssignmentDetailedWithItemDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryAssignmentDetailedWithItemDto {
  int get id => throw _privateConstructorUsedError;
  String get taskNumber => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get createdDate => throw _privateConstructorUsedError;
  List<InventoryAssignmentLineWithItemDto> get lines =>
      throw _privateConstructorUsedError;

  /// Serializes this InventoryAssignmentDetailedWithItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryAssignmentDetailedWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryAssignmentDetailedWithItemDtoCopyWith<
    InventoryAssignmentDetailedWithItemDto
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryAssignmentDetailedWithItemDtoCopyWith<$Res> {
  factory $InventoryAssignmentDetailedWithItemDtoCopyWith(
    InventoryAssignmentDetailedWithItemDto value,
    $Res Function(InventoryAssignmentDetailedWithItemDto) then,
  ) =
      _$InventoryAssignmentDetailedWithItemDtoCopyWithImpl<
        $Res,
        InventoryAssignmentDetailedWithItemDto
      >;
  @useResult
  $Res call({
    int id,
    String taskNumber,
    String description,
    String? createdDate,
    List<InventoryAssignmentLineWithItemDto> lines,
  });
}

/// @nodoc
class _$InventoryAssignmentDetailedWithItemDtoCopyWithImpl<
  $Res,
  $Val extends InventoryAssignmentDetailedWithItemDto
>
    implements $InventoryAssignmentDetailedWithItemDtoCopyWith<$Res> {
  _$InventoryAssignmentDetailedWithItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryAssignmentDetailedWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskNumber = null,
    Object? description = null,
    Object? createdDate = freezed,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            taskNumber: null == taskNumber
                ? _value.taskNumber
                : taskNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            createdDate: freezed == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<InventoryAssignmentLineWithItemDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryAssignmentDetailedWithItemDtoImplCopyWith<$Res>
    implements $InventoryAssignmentDetailedWithItemDtoCopyWith<$Res> {
  factory _$$InventoryAssignmentDetailedWithItemDtoImplCopyWith(
    _$InventoryAssignmentDetailedWithItemDtoImpl value,
    $Res Function(_$InventoryAssignmentDetailedWithItemDtoImpl) then,
  ) = __$$InventoryAssignmentDetailedWithItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String taskNumber,
    String description,
    String? createdDate,
    List<InventoryAssignmentLineWithItemDto> lines,
  });
}

/// @nodoc
class __$$InventoryAssignmentDetailedWithItemDtoImplCopyWithImpl<$Res>
    extends
        _$InventoryAssignmentDetailedWithItemDtoCopyWithImpl<
          $Res,
          _$InventoryAssignmentDetailedWithItemDtoImpl
        >
    implements _$$InventoryAssignmentDetailedWithItemDtoImplCopyWith<$Res> {
  __$$InventoryAssignmentDetailedWithItemDtoImplCopyWithImpl(
    _$InventoryAssignmentDetailedWithItemDtoImpl _value,
    $Res Function(_$InventoryAssignmentDetailedWithItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryAssignmentDetailedWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskNumber = null,
    Object? description = null,
    Object? createdDate = freezed,
    Object? lines = null,
  }) {
    return _then(
      _$InventoryAssignmentDetailedWithItemDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        taskNumber: null == taskNumber
            ? _value.taskNumber
            : taskNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        createdDate: freezed == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<InventoryAssignmentLineWithItemDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryAssignmentDetailedWithItemDtoImpl
    implements _InventoryAssignmentDetailedWithItemDto {
  const _$InventoryAssignmentDetailedWithItemDtoImpl({
    required this.id,
    this.taskNumber = '',
    this.description = '',
    this.createdDate,
    final List<InventoryAssignmentLineWithItemDto> lines = const [],
  }) : _lines = lines;

  factory _$InventoryAssignmentDetailedWithItemDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$InventoryAssignmentDetailedWithItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String taskNumber;
  @override
  @JsonKey()
  final String description;
  @override
  final String? createdDate;
  final List<InventoryAssignmentLineWithItemDto> _lines;
  @override
  @JsonKey()
  List<InventoryAssignmentLineWithItemDto> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'InventoryAssignmentDetailedWithItemDto(id: $id, taskNumber: $taskNumber, description: $description, createdDate: $createdDate, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryAssignmentDetailedWithItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskNumber, taskNumber) ||
                other.taskNumber == taskNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    taskNumber,
    description,
    createdDate,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of InventoryAssignmentDetailedWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryAssignmentDetailedWithItemDtoImplCopyWith<
    _$InventoryAssignmentDetailedWithItemDtoImpl
  >
  get copyWith =>
      __$$InventoryAssignmentDetailedWithItemDtoImplCopyWithImpl<
        _$InventoryAssignmentDetailedWithItemDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryAssignmentDetailedWithItemDtoImplToJson(this);
  }
}

abstract class _InventoryAssignmentDetailedWithItemDto
    implements InventoryAssignmentDetailedWithItemDto {
  const factory _InventoryAssignmentDetailedWithItemDto({
    required final int id,
    final String taskNumber,
    final String description,
    final String? createdDate,
    final List<InventoryAssignmentLineWithItemDto> lines,
  }) = _$InventoryAssignmentDetailedWithItemDtoImpl;

  factory _InventoryAssignmentDetailedWithItemDto.fromJson(
    Map<String, dynamic> json,
  ) = _$InventoryAssignmentDetailedWithItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get taskNumber;
  @override
  String get description;
  @override
  String? get createdDate;
  @override
  List<InventoryAssignmentLineWithItemDto> get lines;

  /// Create a copy of InventoryAssignmentDetailedWithItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryAssignmentDetailedWithItemDtoImplCopyWith<
    _$InventoryAssignmentDetailedWithItemDtoImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

TaskCheckResponse _$TaskCheckResponseFromJson(Map<String, dynamic> json) {
  return _TaskCheckResponse.fromJson(json);
}

/// @nodoc
mixin _$TaskCheckResponse {
  bool get hasNewTasks => throw _privateConstructorUsedError;
  int get newTaskCount => throw _privateConstructorUsedError;
  DateTime? get latestTaskTime => throw _privateConstructorUsedError;
  DateTime get lastChecked => throw _privateConstructorUsedError;

  /// Serializes this TaskCheckResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCheckResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCheckResponseCopyWith<TaskCheckResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCheckResponseCopyWith<$Res> {
  factory $TaskCheckResponseCopyWith(
    TaskCheckResponse value,
    $Res Function(TaskCheckResponse) then,
  ) = _$TaskCheckResponseCopyWithImpl<$Res, TaskCheckResponse>;
  @useResult
  $Res call({
    bool hasNewTasks,
    int newTaskCount,
    DateTime? latestTaskTime,
    DateTime lastChecked,
  });
}

/// @nodoc
class _$TaskCheckResponseCopyWithImpl<$Res, $Val extends TaskCheckResponse>
    implements $TaskCheckResponseCopyWith<$Res> {
  _$TaskCheckResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCheckResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNewTasks = null,
    Object? newTaskCount = null,
    Object? latestTaskTime = freezed,
    Object? lastChecked = null,
  }) {
    return _then(
      _value.copyWith(
            hasNewTasks: null == hasNewTasks
                ? _value.hasNewTasks
                : hasNewTasks // ignore: cast_nullable_to_non_nullable
                      as bool,
            newTaskCount: null == newTaskCount
                ? _value.newTaskCount
                : newTaskCount // ignore: cast_nullable_to_non_nullable
                      as int,
            latestTaskTime: freezed == latestTaskTime
                ? _value.latestTaskTime
                : latestTaskTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastChecked: null == lastChecked
                ? _value.lastChecked
                : lastChecked // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskCheckResponseImplCopyWith<$Res>
    implements $TaskCheckResponseCopyWith<$Res> {
  factory _$$TaskCheckResponseImplCopyWith(
    _$TaskCheckResponseImpl value,
    $Res Function(_$TaskCheckResponseImpl) then,
  ) = __$$TaskCheckResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool hasNewTasks,
    int newTaskCount,
    DateTime? latestTaskTime,
    DateTime lastChecked,
  });
}

/// @nodoc
class __$$TaskCheckResponseImplCopyWithImpl<$Res>
    extends _$TaskCheckResponseCopyWithImpl<$Res, _$TaskCheckResponseImpl>
    implements _$$TaskCheckResponseImplCopyWith<$Res> {
  __$$TaskCheckResponseImplCopyWithImpl(
    _$TaskCheckResponseImpl _value,
    $Res Function(_$TaskCheckResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskCheckResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasNewTasks = null,
    Object? newTaskCount = null,
    Object? latestTaskTime = freezed,
    Object? lastChecked = null,
  }) {
    return _then(
      _$TaskCheckResponseImpl(
        hasNewTasks: null == hasNewTasks
            ? _value.hasNewTasks
            : hasNewTasks // ignore: cast_nullable_to_non_nullable
                  as bool,
        newTaskCount: null == newTaskCount
            ? _value.newTaskCount
            : newTaskCount // ignore: cast_nullable_to_non_nullable
                  as int,
        latestTaskTime: freezed == latestTaskTime
            ? _value.latestTaskTime
            : latestTaskTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastChecked: null == lastChecked
            ? _value.lastChecked
            : lastChecked // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCheckResponseImpl implements _TaskCheckResponse {
  const _$TaskCheckResponseImpl({
    required this.hasNewTasks,
    required this.newTaskCount,
    this.latestTaskTime,
    required this.lastChecked,
  });

  factory _$TaskCheckResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCheckResponseImplFromJson(json);

  @override
  final bool hasNewTasks;
  @override
  final int newTaskCount;
  @override
  final DateTime? latestTaskTime;
  @override
  final DateTime lastChecked;

  @override
  String toString() {
    return 'TaskCheckResponse(hasNewTasks: $hasNewTasks, newTaskCount: $newTaskCount, latestTaskTime: $latestTaskTime, lastChecked: $lastChecked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCheckResponseImpl &&
            (identical(other.hasNewTasks, hasNewTasks) ||
                other.hasNewTasks == hasNewTasks) &&
            (identical(other.newTaskCount, newTaskCount) ||
                other.newTaskCount == newTaskCount) &&
            (identical(other.latestTaskTime, latestTaskTime) ||
                other.latestTaskTime == latestTaskTime) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hasNewTasks,
    newTaskCount,
    latestTaskTime,
    lastChecked,
  );

  /// Create a copy of TaskCheckResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCheckResponseImplCopyWith<_$TaskCheckResponseImpl> get copyWith =>
      __$$TaskCheckResponseImplCopyWithImpl<_$TaskCheckResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCheckResponseImplToJson(this);
  }
}

abstract class _TaskCheckResponse implements TaskCheckResponse {
  const factory _TaskCheckResponse({
    required final bool hasNewTasks,
    required final int newTaskCount,
    final DateTime? latestTaskTime,
    required final DateTime lastChecked,
  }) = _$TaskCheckResponseImpl;

  factory _TaskCheckResponse.fromJson(Map<String, dynamic> json) =
      _$TaskCheckResponseImpl.fromJson;

  @override
  bool get hasNewTasks;
  @override
  int get newTaskCount;
  @override
  DateTime? get latestTaskTime;
  @override
  DateTime get lastChecked;

  /// Create a copy of TaskCheckResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCheckResponseImplCopyWith<_$TaskCheckResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryItemDto _$InventoryItemDtoFromJson(Map<String, dynamic> json) {
  return _InventoryItemDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryItemDto {
  int get itemId => throw _privateConstructorUsedError;
  int? get lineId => throw _privateConstructorUsedError;
  String get itemName => throw _privateConstructorUsedError;
  String get positionCode => throw _privateConstructorUsedError;
  int get positionId => throw _privateConstructorUsedError;
  int get expectedQuantity => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError;
  double get length => throw _privateConstructorUsedError;
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this InventoryItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryItemDtoCopyWith<InventoryItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryItemDtoCopyWith<$Res> {
  factory $InventoryItemDtoCopyWith(
    InventoryItemDto value,
    $Res Function(InventoryItemDto) then,
  ) = _$InventoryItemDtoCopyWithImpl<$Res, InventoryItemDto>;
  @useResult
  $Res call({
    int itemId,
    int? lineId,
    String itemName,
    String positionCode,
    int positionId,
    int expectedQuantity,
    double weight,
    double length,
    double width,
    double height,
    String status,
  });
}

/// @nodoc
class _$InventoryItemDtoCopyWithImpl<$Res, $Val extends InventoryItemDto>
    implements $InventoryItemDtoCopyWith<$Res> {
  _$InventoryItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? lineId = freezed,
    Object? itemName = null,
    Object? positionCode = null,
    Object? positionId = null,
    Object? expectedQuantity = null,
    Object? weight = null,
    Object? length = null,
    Object? width = null,
    Object? height = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            lineId: freezed == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as int?,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            positionCode: null == positionCode
                ? _value.positionCode
                : positionCode // ignore: cast_nullable_to_non_nullable
                      as String,
            positionId: null == positionId
                ? _value.positionId
                : positionId // ignore: cast_nullable_to_non_nullable
                      as int,
            expectedQuantity: null == expectedQuantity
                ? _value.expectedQuantity
                : expectedQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            weight: null == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryItemDtoImplCopyWith<$Res>
    implements $InventoryItemDtoCopyWith<$Res> {
  factory _$$InventoryItemDtoImplCopyWith(
    _$InventoryItemDtoImpl value,
    $Res Function(_$InventoryItemDtoImpl) then,
  ) = __$$InventoryItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int itemId,
    int? lineId,
    String itemName,
    String positionCode,
    int positionId,
    int expectedQuantity,
    double weight,
    double length,
    double width,
    double height,
    String status,
  });
}

/// @nodoc
class __$$InventoryItemDtoImplCopyWithImpl<$Res>
    extends _$InventoryItemDtoCopyWithImpl<$Res, _$InventoryItemDtoImpl>
    implements _$$InventoryItemDtoImplCopyWith<$Res> {
  __$$InventoryItemDtoImplCopyWithImpl(
    _$InventoryItemDtoImpl _value,
    $Res Function(_$InventoryItemDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? lineId = freezed,
    Object? itemName = null,
    Object? positionCode = null,
    Object? positionId = null,
    Object? expectedQuantity = null,
    Object? weight = null,
    Object? length = null,
    Object? width = null,
    Object? height = null,
    Object? status = null,
  }) {
    return _then(
      _$InventoryItemDtoImpl(
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        lineId: freezed == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as int?,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        positionCode: null == positionCode
            ? _value.positionCode
            : positionCode // ignore: cast_nullable_to_non_nullable
                  as String,
        positionId: null == positionId
            ? _value.positionId
            : positionId // ignore: cast_nullable_to_non_nullable
                  as int,
        expectedQuantity: null == expectedQuantity
            ? _value.expectedQuantity
            : expectedQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        weight: null == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double,
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryItemDtoImpl implements _InventoryItemDto {
  const _$InventoryItemDtoImpl({
    required this.itemId,
    this.lineId,
    this.itemName = '',
    this.positionCode = '',
    required this.positionId,
    required this.expectedQuantity,
    this.weight = 0,
    this.length = 0,
    this.width = 0,
    this.height = 0,
    this.status = 'Available',
  });

  factory _$InventoryItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryItemDtoImplFromJson(json);

  @override
  final int itemId;
  @override
  final int? lineId;
  @override
  @JsonKey()
  final String itemName;
  @override
  @JsonKey()
  final String positionCode;
  @override
  final int positionId;
  @override
  final int expectedQuantity;
  @override
  @JsonKey()
  final double weight;
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
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'InventoryItemDto(itemId: $itemId, lineId: $lineId, itemName: $itemName, positionCode: $positionCode, positionId: $positionId, expectedQuantity: $expectedQuantity, weight: $weight, length: $length, width: $width, height: $height, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryItemDtoImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.positionCode, positionCode) ||
                other.positionCode == positionCode) &&
            (identical(other.positionId, positionId) ||
                other.positionId == positionId) &&
            (identical(other.expectedQuantity, expectedQuantity) ||
                other.expectedQuantity == expectedQuantity) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.length, length) || other.length == length) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    itemId,
    lineId,
    itemName,
    positionCode,
    positionId,
    expectedQuantity,
    weight,
    length,
    width,
    height,
    status,
  );

  /// Create a copy of InventoryItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryItemDtoImplCopyWith<_$InventoryItemDtoImpl> get copyWith =>
      __$$InventoryItemDtoImplCopyWithImpl<_$InventoryItemDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryItemDtoImplToJson(this);
  }
}

abstract class _InventoryItemDto implements InventoryItemDto {
  const factory _InventoryItemDto({
    required final int itemId,
    final int? lineId,
    final String itemName,
    final String positionCode,
    required final int positionId,
    required final int expectedQuantity,
    final double weight,
    final double length,
    final double width,
    final double height,
    final String status,
  }) = _$InventoryItemDtoImpl;

  factory _InventoryItemDto.fromJson(Map<String, dynamic> json) =
      _$InventoryItemDtoImpl.fromJson;

  @override
  int get itemId;
  @override
  int? get lineId;
  @override
  String get itemName;
  @override
  String get positionCode;
  @override
  int get positionId;
  @override
  int get expectedQuantity;
  @override
  double get weight;
  @override
  double get length;
  @override
  double get width;
  @override
  double get height;
  @override
  String get status;

  /// Create a copy of InventoryItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryItemDtoImplCopyWith<_$InventoryItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryTaskDetailsDto _$InventoryTaskDetailsDtoFromJson(
  Map<String, dynamic> json,
) {
  return _InventoryTaskDetailsDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryTaskDetailsDto {
  int get taskId => throw _privateConstructorUsedError;
  String get zoneCode => throw _privateConstructorUsedError;
  List<InventoryItemDto> get items => throw _privateConstructorUsedError;
  int get totalExpectedCount => throw _privateConstructorUsedError;
  DateTime get initiatedAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryTaskDetailsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryTaskDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryTaskDetailsDtoCopyWith<InventoryTaskDetailsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryTaskDetailsDtoCopyWith<$Res> {
  factory $InventoryTaskDetailsDtoCopyWith(
    InventoryTaskDetailsDto value,
    $Res Function(InventoryTaskDetailsDto) then,
  ) = _$InventoryTaskDetailsDtoCopyWithImpl<$Res, InventoryTaskDetailsDto>;
  @useResult
  $Res call({
    int taskId,
    String zoneCode,
    List<InventoryItemDto> items,
    int totalExpectedCount,
    DateTime initiatedAt,
  });
}

/// @nodoc
class _$InventoryTaskDetailsDtoCopyWithImpl<
  $Res,
  $Val extends InventoryTaskDetailsDto
>
    implements $InventoryTaskDetailsDtoCopyWith<$Res> {
  _$InventoryTaskDetailsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryTaskDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? zoneCode = null,
    Object? items = null,
    Object? totalExpectedCount = null,
    Object? initiatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as int,
            zoneCode: null == zoneCode
                ? _value.zoneCode
                : zoneCode // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<InventoryItemDto>,
            totalExpectedCount: null == totalExpectedCount
                ? _value.totalExpectedCount
                : totalExpectedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            initiatedAt: null == initiatedAt
                ? _value.initiatedAt
                : initiatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryTaskDetailsDtoImplCopyWith<$Res>
    implements $InventoryTaskDetailsDtoCopyWith<$Res> {
  factory _$$InventoryTaskDetailsDtoImplCopyWith(
    _$InventoryTaskDetailsDtoImpl value,
    $Res Function(_$InventoryTaskDetailsDtoImpl) then,
  ) = __$$InventoryTaskDetailsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int taskId,
    String zoneCode,
    List<InventoryItemDto> items,
    int totalExpectedCount,
    DateTime initiatedAt,
  });
}

/// @nodoc
class __$$InventoryTaskDetailsDtoImplCopyWithImpl<$Res>
    extends
        _$InventoryTaskDetailsDtoCopyWithImpl<
          $Res,
          _$InventoryTaskDetailsDtoImpl
        >
    implements _$$InventoryTaskDetailsDtoImplCopyWith<$Res> {
  __$$InventoryTaskDetailsDtoImplCopyWithImpl(
    _$InventoryTaskDetailsDtoImpl _value,
    $Res Function(_$InventoryTaskDetailsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryTaskDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? zoneCode = null,
    Object? items = null,
    Object? totalExpectedCount = null,
    Object? initiatedAt = null,
  }) {
    return _then(
      _$InventoryTaskDetailsDtoImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as int,
        zoneCode: null == zoneCode
            ? _value.zoneCode
            : zoneCode // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<InventoryItemDto>,
        totalExpectedCount: null == totalExpectedCount
            ? _value.totalExpectedCount
            : totalExpectedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        initiatedAt: null == initiatedAt
            ? _value.initiatedAt
            : initiatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryTaskDetailsDtoImpl implements _InventoryTaskDetailsDto {
  const _$InventoryTaskDetailsDtoImpl({
    required this.taskId,
    this.zoneCode = '',
    final List<InventoryItemDto> items = const [],
    required this.totalExpectedCount,
    required this.initiatedAt,
  }) : _items = items;

  factory _$InventoryTaskDetailsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryTaskDetailsDtoImplFromJson(json);

  @override
  final int taskId;
  @override
  @JsonKey()
  final String zoneCode;
  final List<InventoryItemDto> _items;
  @override
  @JsonKey()
  List<InventoryItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int totalExpectedCount;
  @override
  final DateTime initiatedAt;

  @override
  String toString() {
    return 'InventoryTaskDetailsDto(taskId: $taskId, zoneCode: $zoneCode, items: $items, totalExpectedCount: $totalExpectedCount, initiatedAt: $initiatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryTaskDetailsDtoImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.zoneCode, zoneCode) ||
                other.zoneCode == zoneCode) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.totalExpectedCount, totalExpectedCount) ||
                other.totalExpectedCount == totalExpectedCount) &&
            (identical(other.initiatedAt, initiatedAt) ||
                other.initiatedAt == initiatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    zoneCode,
    const DeepCollectionEquality().hash(_items),
    totalExpectedCount,
    initiatedAt,
  );

  /// Create a copy of InventoryTaskDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryTaskDetailsDtoImplCopyWith<_$InventoryTaskDetailsDtoImpl>
  get copyWith =>
      __$$InventoryTaskDetailsDtoImplCopyWithImpl<
        _$InventoryTaskDetailsDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryTaskDetailsDtoImplToJson(this);
  }
}

abstract class _InventoryTaskDetailsDto implements InventoryTaskDetailsDto {
  const factory _InventoryTaskDetailsDto({
    required final int taskId,
    final String zoneCode,
    final List<InventoryItemDto> items,
    required final int totalExpectedCount,
    required final DateTime initiatedAt,
  }) = _$InventoryTaskDetailsDtoImpl;

  factory _InventoryTaskDetailsDto.fromJson(Map<String, dynamic> json) =
      _$InventoryTaskDetailsDtoImpl.fromJson;

  @override
  int get taskId;
  @override
  String get zoneCode;
  @override
  List<InventoryItemDto> get items;
  @override
  int get totalExpectedCount;
  @override
  DateTime get initiatedAt;

  /// Create a copy of InventoryTaskDetailsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryTaskDetailsDtoImplCopyWith<_$InventoryTaskDetailsDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CompleteAssignmentLineDto _$CompleteAssignmentLineDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CompleteAssignmentLineDto.fromJson(json);
}

/// @nodoc
mixin _$CompleteAssignmentLineDto {
  int? get lineId => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String get positionCode => throw _privateConstructorUsedError;
  int? get actualQuantity => throw _privateConstructorUsedError;

  /// Serializes this CompleteAssignmentLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteAssignmentLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteAssignmentLineDtoCopyWith<CompleteAssignmentLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteAssignmentLineDtoCopyWith<$Res> {
  factory $CompleteAssignmentLineDtoCopyWith(
    CompleteAssignmentLineDto value,
    $Res Function(CompleteAssignmentLineDto) then,
  ) = _$CompleteAssignmentLineDtoCopyWithImpl<$Res, CompleteAssignmentLineDto>;
  @useResult
  $Res call({
    int? lineId,
    int itemId,
    String positionCode,
    int? actualQuantity,
  });
}

/// @nodoc
class _$CompleteAssignmentLineDtoCopyWithImpl<
  $Res,
  $Val extends CompleteAssignmentLineDto
>
    implements $CompleteAssignmentLineDtoCopyWith<$Res> {
  _$CompleteAssignmentLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteAssignmentLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = freezed,
    Object? itemId = null,
    Object? positionCode = null,
    Object? actualQuantity = freezed,
  }) {
    return _then(
      _value.copyWith(
            lineId: freezed == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as int?,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            positionCode: null == positionCode
                ? _value.positionCode
                : positionCode // ignore: cast_nullable_to_non_nullable
                      as String,
            actualQuantity: freezed == actualQuantity
                ? _value.actualQuantity
                : actualQuantity // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompleteAssignmentLineDtoImplCopyWith<$Res>
    implements $CompleteAssignmentLineDtoCopyWith<$Res> {
  factory _$$CompleteAssignmentLineDtoImplCopyWith(
    _$CompleteAssignmentLineDtoImpl value,
    $Res Function(_$CompleteAssignmentLineDtoImpl) then,
  ) = __$$CompleteAssignmentLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? lineId,
    int itemId,
    String positionCode,
    int? actualQuantity,
  });
}

/// @nodoc
class __$$CompleteAssignmentLineDtoImplCopyWithImpl<$Res>
    extends
        _$CompleteAssignmentLineDtoCopyWithImpl<
          $Res,
          _$CompleteAssignmentLineDtoImpl
        >
    implements _$$CompleteAssignmentLineDtoImplCopyWith<$Res> {
  __$$CompleteAssignmentLineDtoImplCopyWithImpl(
    _$CompleteAssignmentLineDtoImpl _value,
    $Res Function(_$CompleteAssignmentLineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompleteAssignmentLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = freezed,
    Object? itemId = null,
    Object? positionCode = null,
    Object? actualQuantity = freezed,
  }) {
    return _then(
      _$CompleteAssignmentLineDtoImpl(
        lineId: freezed == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as int?,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        positionCode: null == positionCode
            ? _value.positionCode
            : positionCode // ignore: cast_nullable_to_non_nullable
                  as String,
        actualQuantity: freezed == actualQuantity
            ? _value.actualQuantity
            : actualQuantity // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompleteAssignmentLineDtoImpl implements _CompleteAssignmentLineDto {
  const _$CompleteAssignmentLineDtoImpl({
    this.lineId,
    required this.itemId,
    this.positionCode = '',
    this.actualQuantity,
  });

  factory _$CompleteAssignmentLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompleteAssignmentLineDtoImplFromJson(json);

  @override
  final int? lineId;
  @override
  final int itemId;
  @override
  @JsonKey()
  final String positionCode;
  @override
  final int? actualQuantity;

  @override
  String toString() {
    return 'CompleteAssignmentLineDto(lineId: $lineId, itemId: $itemId, positionCode: $positionCode, actualQuantity: $actualQuantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteAssignmentLineDtoImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.positionCode, positionCode) ||
                other.positionCode == positionCode) &&
            (identical(other.actualQuantity, actualQuantity) ||
                other.actualQuantity == actualQuantity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, lineId, itemId, positionCode, actualQuantity);

  /// Create a copy of CompleteAssignmentLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteAssignmentLineDtoImplCopyWith<_$CompleteAssignmentLineDtoImpl>
  get copyWith =>
      __$$CompleteAssignmentLineDtoImplCopyWithImpl<
        _$CompleteAssignmentLineDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteAssignmentLineDtoImplToJson(this);
  }
}

abstract class _CompleteAssignmentLineDto implements CompleteAssignmentLineDto {
  const factory _CompleteAssignmentLineDto({
    final int? lineId,
    required final int itemId,
    final String positionCode,
    final int? actualQuantity,
  }) = _$CompleteAssignmentLineDtoImpl;

  factory _CompleteAssignmentLineDto.fromJson(Map<String, dynamic> json) =
      _$CompleteAssignmentLineDtoImpl.fromJson;

  @override
  int? get lineId;
  @override
  int get itemId;
  @override
  String get positionCode;
  @override
  int? get actualQuantity;

  /// Create a copy of CompleteAssignmentLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteAssignmentLineDtoImplCopyWith<_$CompleteAssignmentLineDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CompleteAssignmentDto _$CompleteAssignmentDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CompleteAssignmentDto.fromJson(json);
}

/// @nodoc
mixin _$CompleteAssignmentDto {
  int get assignmentId => throw _privateConstructorUsedError;
  int get workerId => throw _privateConstructorUsedError;
  List<CompleteAssignmentLineDto> get lines =>
      throw _privateConstructorUsedError;

  /// Serializes this CompleteAssignmentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteAssignmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteAssignmentDtoCopyWith<CompleteAssignmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteAssignmentDtoCopyWith<$Res> {
  factory $CompleteAssignmentDtoCopyWith(
    CompleteAssignmentDto value,
    $Res Function(CompleteAssignmentDto) then,
  ) = _$CompleteAssignmentDtoCopyWithImpl<$Res, CompleteAssignmentDto>;
  @useResult
  $Res call({
    int assignmentId,
    int workerId,
    List<CompleteAssignmentLineDto> lines,
  });
}

/// @nodoc
class _$CompleteAssignmentDtoCopyWithImpl<
  $Res,
  $Val extends CompleteAssignmentDto
>
    implements $CompleteAssignmentDtoCopyWith<$Res> {
  _$CompleteAssignmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteAssignmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? workerId = null,
    Object? lines = null,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as int,
            workerId: null == workerId
                ? _value.workerId
                : workerId // ignore: cast_nullable_to_non_nullable
                      as int,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<CompleteAssignmentLineDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CompleteAssignmentDtoImplCopyWith<$Res>
    implements $CompleteAssignmentDtoCopyWith<$Res> {
  factory _$$CompleteAssignmentDtoImplCopyWith(
    _$CompleteAssignmentDtoImpl value,
    $Res Function(_$CompleteAssignmentDtoImpl) then,
  ) = __$$CompleteAssignmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int assignmentId,
    int workerId,
    List<CompleteAssignmentLineDto> lines,
  });
}

/// @nodoc
class __$$CompleteAssignmentDtoImplCopyWithImpl<$Res>
    extends
        _$CompleteAssignmentDtoCopyWithImpl<$Res, _$CompleteAssignmentDtoImpl>
    implements _$$CompleteAssignmentDtoImplCopyWith<$Res> {
  __$$CompleteAssignmentDtoImplCopyWithImpl(
    _$CompleteAssignmentDtoImpl _value,
    $Res Function(_$CompleteAssignmentDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompleteAssignmentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? workerId = null,
    Object? lines = null,
  }) {
    return _then(
      _$CompleteAssignmentDtoImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as int,
        workerId: null == workerId
            ? _value.workerId
            : workerId // ignore: cast_nullable_to_non_nullable
                  as int,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<CompleteAssignmentLineDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompleteAssignmentDtoImpl implements _CompleteAssignmentDto {
  const _$CompleteAssignmentDtoImpl({
    required this.assignmentId,
    required this.workerId,
    final List<CompleteAssignmentLineDto> lines = const [],
  }) : _lines = lines;

  factory _$CompleteAssignmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompleteAssignmentDtoImplFromJson(json);

  @override
  final int assignmentId;
  @override
  final int workerId;
  final List<CompleteAssignmentLineDto> _lines;
  @override
  @JsonKey()
  List<CompleteAssignmentLineDto> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

  @override
  String toString() {
    return 'CompleteAssignmentDto(assignmentId: $assignmentId, workerId: $workerId, lines: $lines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteAssignmentDtoImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.workerId, workerId) ||
                other.workerId == workerId) &&
            const DeepCollectionEquality().equals(other._lines, _lines));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assignmentId,
    workerId,
    const DeepCollectionEquality().hash(_lines),
  );

  /// Create a copy of CompleteAssignmentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteAssignmentDtoImplCopyWith<_$CompleteAssignmentDtoImpl>
  get copyWith =>
      __$$CompleteAssignmentDtoImplCopyWithImpl<_$CompleteAssignmentDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteAssignmentDtoImplToJson(this);
  }
}

abstract class _CompleteAssignmentDto implements CompleteAssignmentDto {
  const factory _CompleteAssignmentDto({
    required final int assignmentId,
    required final int workerId,
    final List<CompleteAssignmentLineDto> lines,
  }) = _$CompleteAssignmentDtoImpl;

  factory _CompleteAssignmentDto.fromJson(Map<String, dynamic> json) =
      _$CompleteAssignmentDtoImpl.fromJson;

  @override
  int get assignmentId;
  @override
  int get workerId;
  @override
  List<CompleteAssignmentLineDto> get lines;

  /// Create a copy of CompleteAssignmentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteAssignmentDtoImplCopyWith<_$CompleteAssignmentDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InventoryStatisticsDto _$InventoryStatisticsDtoFromJson(
  Map<String, dynamic> json,
) {
  return _InventoryStatisticsDto.fromJson(json);
}

/// @nodoc
mixin _$InventoryStatisticsDto {
  int get id => throw _privateConstructorUsedError;
  int get inventoryAssignmentId => throw _privateConstructorUsedError;
  int get totalPositions => throw _privateConstructorUsedError;
  int get countedPositions => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  int get discrepancyCount => throw _privateConstructorUsedError;
  int get surplusCount => throw _privateConstructorUsedError;
  int get shortageCount => throw _privateConstructorUsedError;
  int get totalSurplusQuantity => throw _privateConstructorUsedError;
  int get totalShortageQuantity => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryStatisticsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryStatisticsDtoCopyWith<InventoryStatisticsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryStatisticsDtoCopyWith<$Res> {
  factory $InventoryStatisticsDtoCopyWith(
    InventoryStatisticsDto value,
    $Res Function(InventoryStatisticsDto) then,
  ) = _$InventoryStatisticsDtoCopyWithImpl<$Res, InventoryStatisticsDto>;
  @useResult
  $Res call({
    int id,
    int inventoryAssignmentId,
    int totalPositions,
    int countedPositions,
    double completionPercentage,
    int discrepancyCount,
    int surplusCount,
    int shortageCount,
    int totalSurplusQuantity,
    int totalShortageQuantity,
    DateTime? startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$InventoryStatisticsDtoCopyWithImpl<
  $Res,
  $Val extends InventoryStatisticsDto
>
    implements $InventoryStatisticsDtoCopyWith<$Res> {
  _$InventoryStatisticsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryAssignmentId = null,
    Object? totalPositions = null,
    Object? countedPositions = null,
    Object? completionPercentage = null,
    Object? discrepancyCount = null,
    Object? surplusCount = null,
    Object? shortageCount = null,
    Object? totalSurplusQuantity = null,
    Object? totalShortageQuantity = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            inventoryAssignmentId: null == inventoryAssignmentId
                ? _value.inventoryAssignmentId
                : inventoryAssignmentId // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPositions: null == totalPositions
                ? _value.totalPositions
                : totalPositions // ignore: cast_nullable_to_non_nullable
                      as int,
            countedPositions: null == countedPositions
                ? _value.countedPositions
                : countedPositions // ignore: cast_nullable_to_non_nullable
                      as int,
            completionPercentage: null == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            discrepancyCount: null == discrepancyCount
                ? _value.discrepancyCount
                : discrepancyCount // ignore: cast_nullable_to_non_nullable
                      as int,
            surplusCount: null == surplusCount
                ? _value.surplusCount
                : surplusCount // ignore: cast_nullable_to_non_nullable
                      as int,
            shortageCount: null == shortageCount
                ? _value.shortageCount
                : shortageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSurplusQuantity: null == totalSurplusQuantity
                ? _value.totalSurplusQuantity
                : totalSurplusQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            totalShortageQuantity: null == totalShortageQuantity
                ? _value.totalShortageQuantity
                : totalShortageQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InventoryStatisticsDtoImplCopyWith<$Res>
    implements $InventoryStatisticsDtoCopyWith<$Res> {
  factory _$$InventoryStatisticsDtoImplCopyWith(
    _$InventoryStatisticsDtoImpl value,
    $Res Function(_$InventoryStatisticsDtoImpl) then,
  ) = __$$InventoryStatisticsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int inventoryAssignmentId,
    int totalPositions,
    int countedPositions,
    double completionPercentage,
    int discrepancyCount,
    int surplusCount,
    int shortageCount,
    int totalSurplusQuantity,
    int totalShortageQuantity,
    DateTime? startedAt,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$InventoryStatisticsDtoImplCopyWithImpl<$Res>
    extends
        _$InventoryStatisticsDtoCopyWithImpl<$Res, _$InventoryStatisticsDtoImpl>
    implements _$$InventoryStatisticsDtoImplCopyWith<$Res> {
  __$$InventoryStatisticsDtoImplCopyWithImpl(
    _$InventoryStatisticsDtoImpl _value,
    $Res Function(_$InventoryStatisticsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InventoryStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryAssignmentId = null,
    Object? totalPositions = null,
    Object? countedPositions = null,
    Object? completionPercentage = null,
    Object? discrepancyCount = null,
    Object? surplusCount = null,
    Object? shortageCount = null,
    Object? totalSurplusQuantity = null,
    Object? totalShortageQuantity = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$InventoryStatisticsDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        inventoryAssignmentId: null == inventoryAssignmentId
            ? _value.inventoryAssignmentId
            : inventoryAssignmentId // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPositions: null == totalPositions
            ? _value.totalPositions
            : totalPositions // ignore: cast_nullable_to_non_nullable
                  as int,
        countedPositions: null == countedPositions
            ? _value.countedPositions
            : countedPositions // ignore: cast_nullable_to_non_nullable
                  as int,
        completionPercentage: null == completionPercentage
            ? _value.completionPercentage
            : completionPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        discrepancyCount: null == discrepancyCount
            ? _value.discrepancyCount
            : discrepancyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        surplusCount: null == surplusCount
            ? _value.surplusCount
            : surplusCount // ignore: cast_nullable_to_non_nullable
                  as int,
        shortageCount: null == shortageCount
            ? _value.shortageCount
            : shortageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSurplusQuantity: null == totalSurplusQuantity
            ? _value.totalSurplusQuantity
            : totalSurplusQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        totalShortageQuantity: null == totalShortageQuantity
            ? _value.totalShortageQuantity
            : totalShortageQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryStatisticsDtoImpl implements _InventoryStatisticsDto {
  const _$InventoryStatisticsDtoImpl({
    this.id = 0,
    this.inventoryAssignmentId = 0,
    this.totalPositions = 0,
    this.countedPositions = 0,
    this.completionPercentage = 0.0,
    this.discrepancyCount = 0,
    this.surplusCount = 0,
    this.shortageCount = 0,
    this.totalSurplusQuantity = 0,
    this.totalShortageQuantity = 0,
    this.startedAt,
    this.completedAt,
  });

  factory _$InventoryStatisticsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryStatisticsDtoImplFromJson(json);

  @override
  @JsonKey()
  final int id;
  @override
  @JsonKey()
  final int inventoryAssignmentId;
  @override
  @JsonKey()
  final int totalPositions;
  @override
  @JsonKey()
  final int countedPositions;
  @override
  @JsonKey()
  final double completionPercentage;
  @override
  @JsonKey()
  final int discrepancyCount;
  @override
  @JsonKey()
  final int surplusCount;
  @override
  @JsonKey()
  final int shortageCount;
  @override
  @JsonKey()
  final int totalSurplusQuantity;
  @override
  @JsonKey()
  final int totalShortageQuantity;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'InventoryStatisticsDto(id: $id, inventoryAssignmentId: $inventoryAssignmentId, totalPositions: $totalPositions, countedPositions: $countedPositions, completionPercentage: $completionPercentage, discrepancyCount: $discrepancyCount, surplusCount: $surplusCount, shortageCount: $shortageCount, totalSurplusQuantity: $totalSurplusQuantity, totalShortageQuantity: $totalShortageQuantity, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryStatisticsDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryAssignmentId, inventoryAssignmentId) ||
                other.inventoryAssignmentId == inventoryAssignmentId) &&
            (identical(other.totalPositions, totalPositions) ||
                other.totalPositions == totalPositions) &&
            (identical(other.countedPositions, countedPositions) ||
                other.countedPositions == countedPositions) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.discrepancyCount, discrepancyCount) ||
                other.discrepancyCount == discrepancyCount) &&
            (identical(other.surplusCount, surplusCount) ||
                other.surplusCount == surplusCount) &&
            (identical(other.shortageCount, shortageCount) ||
                other.shortageCount == shortageCount) &&
            (identical(other.totalSurplusQuantity, totalSurplusQuantity) ||
                other.totalSurplusQuantity == totalSurplusQuantity) &&
            (identical(other.totalShortageQuantity, totalShortageQuantity) ||
                other.totalShortageQuantity == totalShortageQuantity) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    inventoryAssignmentId,
    totalPositions,
    countedPositions,
    completionPercentage,
    discrepancyCount,
    surplusCount,
    shortageCount,
    totalSurplusQuantity,
    totalShortageQuantity,
    startedAt,
    completedAt,
  );

  /// Create a copy of InventoryStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryStatisticsDtoImplCopyWith<_$InventoryStatisticsDtoImpl>
  get copyWith =>
      __$$InventoryStatisticsDtoImplCopyWithImpl<_$InventoryStatisticsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryStatisticsDtoImplToJson(this);
  }
}

abstract class _InventoryStatisticsDto implements InventoryStatisticsDto {
  const factory _InventoryStatisticsDto({
    final int id,
    final int inventoryAssignmentId,
    final int totalPositions,
    final int countedPositions,
    final double completionPercentage,
    final int discrepancyCount,
    final int surplusCount,
    final int shortageCount,
    final int totalSurplusQuantity,
    final int totalShortageQuantity,
    final DateTime? startedAt,
    final DateTime? completedAt,
  }) = _$InventoryStatisticsDtoImpl;

  factory _InventoryStatisticsDto.fromJson(Map<String, dynamic> json) =
      _$InventoryStatisticsDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get inventoryAssignmentId;
  @override
  int get totalPositions;
  @override
  int get countedPositions;
  @override
  double get completionPercentage;
  @override
  int get discrepancyCount;
  @override
  int get surplusCount;
  @override
  int get shortageCount;
  @override
  int get totalSurplusQuantity;
  @override
  int get totalShortageQuantity;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;

  /// Create a copy of InventoryStatisticsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryStatisticsDtoImplCopyWith<_$InventoryStatisticsDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CompleteAssignmentResultDto _$CompleteAssignmentResultDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CompleteAssignmentResultDto.fromJson(json);
}

/// @nodoc
mixin _$CompleteAssignmentResultDto {
  int get assignmentId => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  InventoryStatisticsDto? get statistics => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this CompleteAssignmentResultDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteAssignmentResultDtoCopyWith<CompleteAssignmentResultDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteAssignmentResultDtoCopyWith<$Res> {
  factory $CompleteAssignmentResultDtoCopyWith(
    CompleteAssignmentResultDto value,
    $Res Function(CompleteAssignmentResultDto) then,
  ) =
      _$CompleteAssignmentResultDtoCopyWithImpl<
        $Res,
        CompleteAssignmentResultDto
      >;
  @useResult
  $Res call({
    int assignmentId,
    String message,
    InventoryStatisticsDto? statistics,
    DateTime? completedAt,
  });

  $InventoryStatisticsDtoCopyWith<$Res>? get statistics;
}

/// @nodoc
class _$CompleteAssignmentResultDtoCopyWithImpl<
  $Res,
  $Val extends CompleteAssignmentResultDto
>
    implements $CompleteAssignmentResultDtoCopyWith<$Res> {
  _$CompleteAssignmentResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? message = null,
    Object? statistics = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as int,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            statistics: freezed == statistics
                ? _value.statistics
                : statistics // ignore: cast_nullable_to_non_nullable
                      as InventoryStatisticsDto?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InventoryStatisticsDtoCopyWith<$Res>? get statistics {
    if (_value.statistics == null) {
      return null;
    }

    return $InventoryStatisticsDtoCopyWith<$Res>(_value.statistics!, (value) {
      return _then(_value.copyWith(statistics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompleteAssignmentResultDtoImplCopyWith<$Res>
    implements $CompleteAssignmentResultDtoCopyWith<$Res> {
  factory _$$CompleteAssignmentResultDtoImplCopyWith(
    _$CompleteAssignmentResultDtoImpl value,
    $Res Function(_$CompleteAssignmentResultDtoImpl) then,
  ) = __$$CompleteAssignmentResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int assignmentId,
    String message,
    InventoryStatisticsDto? statistics,
    DateTime? completedAt,
  });

  @override
  $InventoryStatisticsDtoCopyWith<$Res>? get statistics;
}

/// @nodoc
class __$$CompleteAssignmentResultDtoImplCopyWithImpl<$Res>
    extends
        _$CompleteAssignmentResultDtoCopyWithImpl<
          $Res,
          _$CompleteAssignmentResultDtoImpl
        >
    implements _$$CompleteAssignmentResultDtoImplCopyWith<$Res> {
  __$$CompleteAssignmentResultDtoImplCopyWithImpl(
    _$CompleteAssignmentResultDtoImpl _value,
    $Res Function(_$CompleteAssignmentResultDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? message = null,
    Object? statistics = freezed,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$CompleteAssignmentResultDtoImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as int,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        statistics: freezed == statistics
            ? _value.statistics
            : statistics // ignore: cast_nullable_to_non_nullable
                  as InventoryStatisticsDto?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CompleteAssignmentResultDtoImpl
    implements _CompleteAssignmentResultDto {
  const _$CompleteAssignmentResultDtoImpl({
    this.assignmentId = 0,
    this.message = '',
    this.statistics,
    this.completedAt,
  });

  factory _$CompleteAssignmentResultDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CompleteAssignmentResultDtoImplFromJson(json);

  @override
  @JsonKey()
  final int assignmentId;
  @override
  @JsonKey()
  final String message;
  @override
  final InventoryStatisticsDto? statistics;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'CompleteAssignmentResultDto(assignmentId: $assignmentId, message: $message, statistics: $statistics, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteAssignmentResultDtoImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, assignmentId, message, statistics, completedAt);

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteAssignmentResultDtoImplCopyWith<_$CompleteAssignmentResultDtoImpl>
  get copyWith =>
      __$$CompleteAssignmentResultDtoImplCopyWithImpl<
        _$CompleteAssignmentResultDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteAssignmentResultDtoImplToJson(this);
  }
}

abstract class _CompleteAssignmentResultDto
    implements CompleteAssignmentResultDto {
  const factory _CompleteAssignmentResultDto({
    final int assignmentId,
    final String message,
    final InventoryStatisticsDto? statistics,
    final DateTime? completedAt,
  }) = _$CompleteAssignmentResultDtoImpl;

  factory _CompleteAssignmentResultDto.fromJson(Map<String, dynamic> json) =
      _$CompleteAssignmentResultDtoImpl.fromJson;

  @override
  int get assignmentId;
  @override
  String get message;
  @override
  InventoryStatisticsDto? get statistics;
  @override
  DateTime? get completedAt;

  /// Create a copy of CompleteAssignmentResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteAssignmentResultDtoImplCopyWith<_$CompleteAssignmentResultDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ItemInfoDto _$ItemInfoDtoFromJson(Map<String, dynamic> json) {
  return _ItemInfoDto.fromJson(json);
}

/// @nodoc
mixin _$ItemInfoDto {
  int get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this ItemInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ItemInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ItemInfoDtoCopyWith<ItemInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemInfoDtoCopyWith<$Res> {
  factory $ItemInfoDtoCopyWith(
    ItemInfoDto value,
    $Res Function(ItemInfoDto) then,
  ) = _$ItemInfoDtoCopyWithImpl<$Res, ItemInfoDto>;
  @useResult
  $Res call({int itemId, String name});
}

/// @nodoc
class _$ItemInfoDtoCopyWithImpl<$Res, $Val extends ItemInfoDto>
    implements $ItemInfoDtoCopyWith<$Res> {
  _$ItemInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ItemInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? itemId = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ItemInfoDtoImplCopyWith<$Res>
    implements $ItemInfoDtoCopyWith<$Res> {
  factory _$$ItemInfoDtoImplCopyWith(
    _$ItemInfoDtoImpl value,
    $Res Function(_$ItemInfoDtoImpl) then,
  ) = __$$ItemInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int itemId, String name});
}

/// @nodoc
class __$$ItemInfoDtoImplCopyWithImpl<$Res>
    extends _$ItemInfoDtoCopyWithImpl<$Res, _$ItemInfoDtoImpl>
    implements _$$ItemInfoDtoImplCopyWith<$Res> {
  __$$ItemInfoDtoImplCopyWithImpl(
    _$ItemInfoDtoImpl _value,
    $Res Function(_$ItemInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ItemInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? itemId = null, Object? name = null}) {
    return _then(
      _$ItemInfoDtoImpl(
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemInfoDtoImpl implements _ItemInfoDto {
  const _$ItemInfoDtoImpl({required this.itemId, this.name = ''});

  factory _$ItemInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemInfoDtoImplFromJson(json);

  @override
  final int itemId;
  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'ItemInfoDto(itemId: $itemId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemInfoDtoImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemId, name);

  /// Create a copy of ItemInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemInfoDtoImplCopyWith<_$ItemInfoDtoImpl> get copyWith =>
      __$$ItemInfoDtoImplCopyWithImpl<_$ItemInfoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemInfoDtoImplToJson(this);
  }
}

abstract class _ItemInfoDto implements ItemInfoDto {
  const factory _ItemInfoDto({required final int itemId, final String name}) =
      _$ItemInfoDtoImpl;

  factory _ItemInfoDto.fromJson(Map<String, dynamic> json) =
      _$ItemInfoDtoImpl.fromJson;

  @override
  int get itemId;
  @override
  String get name;

  /// Create a copy of ItemInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ItemInfoDtoImplCopyWith<_$ItemInfoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
