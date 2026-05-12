// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_assembly_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScanPickRequest _$ScanPickRequestFromJson(Map<String, dynamic> json) {
  return _ScanPickRequest.fromJson(json);
}

/// @nodoc
mixin _$ScanPickRequest {
  int get lineId => throw _privateConstructorUsedError;
  String get barcode => throw _privateConstructorUsedError;

  /// Serializes this ScanPickRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanPickRequestCopyWith<ScanPickRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanPickRequestCopyWith<$Res> {
  factory $ScanPickRequestCopyWith(
    ScanPickRequest value,
    $Res Function(ScanPickRequest) then,
  ) = _$ScanPickRequestCopyWithImpl<$Res, ScanPickRequest>;
  @useResult
  $Res call({int lineId, String barcode});
}

/// @nodoc
class _$ScanPickRequestCopyWithImpl<$Res, $Val extends ScanPickRequest>
    implements $ScanPickRequestCopyWith<$Res> {
  _$ScanPickRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? barcode = null}) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as int,
            barcode: null == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanPickRequestImplCopyWith<$Res>
    implements $ScanPickRequestCopyWith<$Res> {
  factory _$$ScanPickRequestImplCopyWith(
    _$ScanPickRequestImpl value,
    $Res Function(_$ScanPickRequestImpl) then,
  ) = __$$ScanPickRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int lineId, String barcode});
}

/// @nodoc
class __$$ScanPickRequestImplCopyWithImpl<$Res>
    extends _$ScanPickRequestCopyWithImpl<$Res, _$ScanPickRequestImpl>
    implements _$$ScanPickRequestImplCopyWith<$Res> {
  __$$ScanPickRequestImplCopyWithImpl(
    _$ScanPickRequestImpl _value,
    $Res Function(_$ScanPickRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? barcode = null}) {
    return _then(
      _$ScanPickRequestImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as int,
        barcode: null == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanPickRequestImpl implements _ScanPickRequest {
  const _$ScanPickRequestImpl({required this.lineId, required this.barcode});

  factory _$ScanPickRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanPickRequestImplFromJson(json);

  @override
  final int lineId;
  @override
  final String barcode;

  @override
  String toString() {
    return 'ScanPickRequest(lineId: $lineId, barcode: $barcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanPickRequestImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.barcode, barcode) || other.barcode == barcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lineId, barcode);

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanPickRequestImplCopyWith<_$ScanPickRequestImpl> get copyWith =>
      __$$ScanPickRequestImplCopyWithImpl<_$ScanPickRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanPickRequestImplToJson(this);
  }
}

abstract class _ScanPickRequest implements ScanPickRequest {
  const factory _ScanPickRequest({
    required final int lineId,
    required final String barcode,
  }) = _$ScanPickRequestImpl;

  factory _ScanPickRequest.fromJson(Map<String, dynamic> json) =
      _$ScanPickRequestImpl.fromJson;

  @override
  int get lineId;
  @override
  String get barcode;

  /// Create a copy of ScanPickRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanPickRequestImplCopyWith<_$ScanPickRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanPlaceBulkRequest _$ScanPlaceBulkRequestFromJson(Map<String, dynamic> json) {
  return _ScanPlaceBulkRequest.fromJson(json);
}

/// @nodoc
mixin _$ScanPlaceBulkRequest {
  int get assignmentId => throw _privateConstructorUsedError;
  String get cellCode => throw _privateConstructorUsedError;

  /// Serializes this ScanPlaceBulkRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanPlaceBulkRequestCopyWith<ScanPlaceBulkRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanPlaceBulkRequestCopyWith<$Res> {
  factory $ScanPlaceBulkRequestCopyWith(
    ScanPlaceBulkRequest value,
    $Res Function(ScanPlaceBulkRequest) then,
  ) = _$ScanPlaceBulkRequestCopyWithImpl<$Res, ScanPlaceBulkRequest>;
  @useResult
  $Res call({int assignmentId, String cellCode});
}

/// @nodoc
class _$ScanPlaceBulkRequestCopyWithImpl<
  $Res,
  $Val extends ScanPlaceBulkRequest
>
    implements $ScanPlaceBulkRequestCopyWith<$Res> {
  _$ScanPlaceBulkRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assignmentId = null, Object? cellCode = null}) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as int,
            cellCode: null == cellCode
                ? _value.cellCode
                : cellCode // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScanPlaceBulkRequestImplCopyWith<$Res>
    implements $ScanPlaceBulkRequestCopyWith<$Res> {
  factory _$$ScanPlaceBulkRequestImplCopyWith(
    _$ScanPlaceBulkRequestImpl value,
    $Res Function(_$ScanPlaceBulkRequestImpl) then,
  ) = __$$ScanPlaceBulkRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int assignmentId, String cellCode});
}

/// @nodoc
class __$$ScanPlaceBulkRequestImplCopyWithImpl<$Res>
    extends _$ScanPlaceBulkRequestCopyWithImpl<$Res, _$ScanPlaceBulkRequestImpl>
    implements _$$ScanPlaceBulkRequestImplCopyWith<$Res> {
  __$$ScanPlaceBulkRequestImplCopyWithImpl(
    _$ScanPlaceBulkRequestImpl _value,
    $Res Function(_$ScanPlaceBulkRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? assignmentId = null, Object? cellCode = null}) {
    return _then(
      _$ScanPlaceBulkRequestImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as int,
        cellCode: null == cellCode
            ? _value.cellCode
            : cellCode // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanPlaceBulkRequestImpl implements _ScanPlaceBulkRequest {
  const _$ScanPlaceBulkRequestImpl({
    required this.assignmentId,
    required this.cellCode,
  });

  factory _$ScanPlaceBulkRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanPlaceBulkRequestImplFromJson(json);

  @override
  final int assignmentId;
  @override
  final String cellCode;

  @override
  String toString() {
    return 'ScanPlaceBulkRequest(assignmentId: $assignmentId, cellCode: $cellCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanPlaceBulkRequestImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.cellCode, cellCode) ||
                other.cellCode == cellCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, assignmentId, cellCode);

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanPlaceBulkRequestImplCopyWith<_$ScanPlaceBulkRequestImpl>
  get copyWith =>
      __$$ScanPlaceBulkRequestImplCopyWithImpl<_$ScanPlaceBulkRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanPlaceBulkRequestImplToJson(this);
  }
}

abstract class _ScanPlaceBulkRequest implements ScanPlaceBulkRequest {
  const factory _ScanPlaceBulkRequest({
    required final int assignmentId,
    required final String cellCode,
  }) = _$ScanPlaceBulkRequestImpl;

  factory _ScanPlaceBulkRequest.fromJson(Map<String, dynamic> json) =
      _$ScanPlaceBulkRequestImpl.fromJson;

  @override
  int get assignmentId;
  @override
  String get cellCode;

  /// Create a copy of ScanPlaceBulkRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanPlaceBulkRequestImplCopyWith<_$ScanPlaceBulkRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ReportMissingRequest _$ReportMissingRequestFromJson(Map<String, dynamic> json) {
  return _ReportMissingRequest.fromJson(json);
}

/// @nodoc
mixin _$ReportMissingRequest {
  int get lineId => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;

  /// Serializes this ReportMissingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportMissingRequestCopyWith<ReportMissingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportMissingRequestCopyWith<$Res> {
  factory $ReportMissingRequestCopyWith(
    ReportMissingRequest value,
    $Res Function(ReportMissingRequest) then,
  ) = _$ReportMissingRequestCopyWithImpl<$Res, ReportMissingRequest>;
  @useResult
  $Res call({int lineId, String reason});
}

/// @nodoc
class _$ReportMissingRequestCopyWithImpl<
  $Res,
  $Val extends ReportMissingRequest
>
    implements $ReportMissingRequestCopyWith<$Res> {
  _$ReportMissingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? reason = null}) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportMissingRequestImplCopyWith<$Res>
    implements $ReportMissingRequestCopyWith<$Res> {
  factory _$$ReportMissingRequestImplCopyWith(
    _$ReportMissingRequestImpl value,
    $Res Function(_$ReportMissingRequestImpl) then,
  ) = __$$ReportMissingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int lineId, String reason});
}

/// @nodoc
class __$$ReportMissingRequestImplCopyWithImpl<$Res>
    extends _$ReportMissingRequestCopyWithImpl<$Res, _$ReportMissingRequestImpl>
    implements _$$ReportMissingRequestImplCopyWith<$Res> {
  __$$ReportMissingRequestImplCopyWithImpl(
    _$ReportMissingRequestImpl _value,
    $Res Function(_$ReportMissingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? lineId = null, Object? reason = null}) {
    return _then(
      _$ReportMissingRequestImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportMissingRequestImpl implements _ReportMissingRequest {
  const _$ReportMissingRequestImpl({
    required this.lineId,
    required this.reason,
  });

  factory _$ReportMissingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportMissingRequestImplFromJson(json);

  @override
  final int lineId;
  @override
  final String reason;

  @override
  String toString() {
    return 'ReportMissingRequest(lineId: $lineId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportMissingRequestImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, lineId, reason);

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportMissingRequestImplCopyWith<_$ReportMissingRequestImpl>
  get copyWith =>
      __$$ReportMissingRequestImplCopyWithImpl<_$ReportMissingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportMissingRequestImplToJson(this);
  }
}

abstract class _ReportMissingRequest implements ReportMissingRequest {
  const factory _ReportMissingRequest({
    required final int lineId,
    required final String reason,
  }) = _$ReportMissingRequestImpl;

  factory _ReportMissingRequest.fromJson(Map<String, dynamic> json) =
      _$ReportMissingRequestImpl.fromJson;

  @override
  int get lineId;
  @override
  String get reason;

  /// Create a copy of ReportMissingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportMissingRequestImplCopyWith<_$ReportMissingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PlacementLineDto _$PlacementLineDtoFromJson(Map<String, dynamic> json) {
  return _PlacementLineDto.fromJson(json);
}

/// @nodoc
mixin _$PlacementLineDto {
  int get lineId => throw _privateConstructorUsedError;
  int get itemPositionId => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  String? get sourceCellCode => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get pickedQuantity => throw _privateConstructorUsedError;
  OrderAssemblyLineStatus get status => throw _privateConstructorUsedError;

  /// Serializes this PlacementLineDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlacementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlacementLineDtoCopyWith<PlacementLineDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacementLineDtoCopyWith<$Res> {
  factory $PlacementLineDtoCopyWith(
    PlacementLineDto value,
    $Res Function(PlacementLineDto) then,
  ) = _$PlacementLineDtoCopyWithImpl<$Res, PlacementLineDto>;
  @useResult
  $Res call({
    int lineId,
    int itemPositionId,
    int itemId,
    String? itemName,
    String? barcode,
    String? sourceCellCode,
    int quantity,
    int pickedQuantity,
    OrderAssemblyLineStatus status,
  });
}

/// @nodoc
class _$PlacementLineDtoCopyWithImpl<$Res, $Val extends PlacementLineDto>
    implements $PlacementLineDtoCopyWith<$Res> {
  _$PlacementLineDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlacementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? itemPositionId = null,
    Object? itemId = null,
    Object? itemName = freezed,
    Object? barcode = freezed,
    Object? sourceCellCode = freezed,
    Object? quantity = null,
    Object? pickedQuantity = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemPositionId: null == itemPositionId
                ? _value.itemPositionId
                : itemPositionId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            barcode: freezed == barcode
                ? _value.barcode
                : barcode // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceCellCode: freezed == sourceCellCode
                ? _value.sourceCellCode
                : sourceCellCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            pickedQuantity: null == pickedQuantity
                ? _value.pickedQuantity
                : pickedQuantity // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as OrderAssemblyLineStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlacementLineDtoImplCopyWith<$Res>
    implements $PlacementLineDtoCopyWith<$Res> {
  factory _$$PlacementLineDtoImplCopyWith(
    _$PlacementLineDtoImpl value,
    $Res Function(_$PlacementLineDtoImpl) then,
  ) = __$$PlacementLineDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int lineId,
    int itemPositionId,
    int itemId,
    String? itemName,
    String? barcode,
    String? sourceCellCode,
    int quantity,
    int pickedQuantity,
    OrderAssemblyLineStatus status,
  });
}

/// @nodoc
class __$$PlacementLineDtoImplCopyWithImpl<$Res>
    extends _$PlacementLineDtoCopyWithImpl<$Res, _$PlacementLineDtoImpl>
    implements _$$PlacementLineDtoImplCopyWith<$Res> {
  __$$PlacementLineDtoImplCopyWithImpl(
    _$PlacementLineDtoImpl _value,
    $Res Function(_$PlacementLineDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlacementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lineId = null,
    Object? itemPositionId = null,
    Object? itemId = null,
    Object? itemName = freezed,
    Object? barcode = freezed,
    Object? sourceCellCode = freezed,
    Object? quantity = null,
    Object? pickedQuantity = null,
    Object? status = null,
  }) {
    return _then(
      _$PlacementLineDtoImpl(
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemPositionId: null == itemPositionId
            ? _value.itemPositionId
            : itemPositionId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        barcode: freezed == barcode
            ? _value.barcode
            : barcode // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceCellCode: freezed == sourceCellCode
            ? _value.sourceCellCode
            : sourceCellCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        pickedQuantity: null == pickedQuantity
            ? _value.pickedQuantity
            : pickedQuantity // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as OrderAssemblyLineStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlacementLineDtoImpl implements _PlacementLineDto {
  const _$PlacementLineDtoImpl({
    required this.lineId,
    required this.itemPositionId,
    required this.itemId,
    this.itemName,
    this.barcode,
    this.sourceCellCode,
    required this.quantity,
    required this.pickedQuantity,
    required this.status,
  });

  factory _$PlacementLineDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlacementLineDtoImplFromJson(json);

  @override
  final int lineId;
  @override
  final int itemPositionId;
  @override
  final int itemId;
  @override
  final String? itemName;
  @override
  final String? barcode;
  @override
  final String? sourceCellCode;
  @override
  final int quantity;
  @override
  final int pickedQuantity;
  @override
  final OrderAssemblyLineStatus status;

  @override
  String toString() {
    return 'PlacementLineDto(lineId: $lineId, itemPositionId: $itemPositionId, itemId: $itemId, itemName: $itemName, barcode: $barcode, sourceCellCode: $sourceCellCode, quantity: $quantity, pickedQuantity: $pickedQuantity, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlacementLineDtoImpl &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.itemPositionId, itemPositionId) ||
                other.itemPositionId == itemPositionId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.sourceCellCode, sourceCellCode) ||
                other.sourceCellCode == sourceCellCode) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.pickedQuantity, pickedQuantity) ||
                other.pickedQuantity == pickedQuantity) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    lineId,
    itemPositionId,
    itemId,
    itemName,
    barcode,
    sourceCellCode,
    quantity,
    pickedQuantity,
    status,
  );

  /// Create a copy of PlacementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlacementLineDtoImplCopyWith<_$PlacementLineDtoImpl> get copyWith =>
      __$$PlacementLineDtoImplCopyWithImpl<_$PlacementLineDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlacementLineDtoImplToJson(this);
  }
}

abstract class _PlacementLineDto implements PlacementLineDto {
  const factory _PlacementLineDto({
    required final int lineId,
    required final int itemPositionId,
    required final int itemId,
    final String? itemName,
    final String? barcode,
    final String? sourceCellCode,
    required final int quantity,
    required final int pickedQuantity,
    required final OrderAssemblyLineStatus status,
  }) = _$PlacementLineDtoImpl;

  factory _PlacementLineDto.fromJson(Map<String, dynamic> json) =
      _$PlacementLineDtoImpl.fromJson;

  @override
  int get lineId;
  @override
  int get itemPositionId;
  @override
  int get itemId;
  @override
  String? get itemName;
  @override
  String? get barcode;
  @override
  String? get sourceCellCode;
  @override
  int get quantity;
  @override
  int get pickedQuantity;
  @override
  OrderAssemblyLineStatus get status;

  /// Create a copy of PlacementLineDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlacementLineDtoImplCopyWith<_$PlacementLineDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CellPlacementInfoDto _$CellPlacementInfoDtoFromJson(Map<String, dynamic> json) {
  return _CellPlacementInfoDto.fromJson(json);
}

/// @nodoc
mixin _$CellPlacementInfoDto {
  int get targetPositionId => throw _privateConstructorUsedError;
  String? get cellCode => throw _privateConstructorUsedError;
  String? get cellDisplayName => throw _privateConstructorUsedError;
  List<PlacementLineDto> get items => throw _privateConstructorUsedError;

  /// Serializes this CellPlacementInfoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CellPlacementInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CellPlacementInfoDtoCopyWith<CellPlacementInfoDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellPlacementInfoDtoCopyWith<$Res> {
  factory $CellPlacementInfoDtoCopyWith(
    CellPlacementInfoDto value,
    $Res Function(CellPlacementInfoDto) then,
  ) = _$CellPlacementInfoDtoCopyWithImpl<$Res, CellPlacementInfoDto>;
  @useResult
  $Res call({
    int targetPositionId,
    String? cellCode,
    String? cellDisplayName,
    List<PlacementLineDto> items,
  });
}

/// @nodoc
class _$CellPlacementInfoDtoCopyWithImpl<
  $Res,
  $Val extends CellPlacementInfoDto
>
    implements $CellPlacementInfoDtoCopyWith<$Res> {
  _$CellPlacementInfoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CellPlacementInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetPositionId = null,
    Object? cellCode = freezed,
    Object? cellDisplayName = freezed,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            targetPositionId: null == targetPositionId
                ? _value.targetPositionId
                : targetPositionId // ignore: cast_nullable_to_non_nullable
                      as int,
            cellCode: freezed == cellCode
                ? _value.cellCode
                : cellCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            cellDisplayName: freezed == cellDisplayName
                ? _value.cellDisplayName
                : cellDisplayName // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PlacementLineDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CellPlacementInfoDtoImplCopyWith<$Res>
    implements $CellPlacementInfoDtoCopyWith<$Res> {
  factory _$$CellPlacementInfoDtoImplCopyWith(
    _$CellPlacementInfoDtoImpl value,
    $Res Function(_$CellPlacementInfoDtoImpl) then,
  ) = __$$CellPlacementInfoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int targetPositionId,
    String? cellCode,
    String? cellDisplayName,
    List<PlacementLineDto> items,
  });
}

/// @nodoc
class __$$CellPlacementInfoDtoImplCopyWithImpl<$Res>
    extends _$CellPlacementInfoDtoCopyWithImpl<$Res, _$CellPlacementInfoDtoImpl>
    implements _$$CellPlacementInfoDtoImplCopyWith<$Res> {
  __$$CellPlacementInfoDtoImplCopyWithImpl(
    _$CellPlacementInfoDtoImpl _value,
    $Res Function(_$CellPlacementInfoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CellPlacementInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetPositionId = null,
    Object? cellCode = freezed,
    Object? cellDisplayName = freezed,
    Object? items = null,
  }) {
    return _then(
      _$CellPlacementInfoDtoImpl(
        targetPositionId: null == targetPositionId
            ? _value.targetPositionId
            : targetPositionId // ignore: cast_nullable_to_non_nullable
                  as int,
        cellCode: freezed == cellCode
            ? _value.cellCode
            : cellCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        cellDisplayName: freezed == cellDisplayName
            ? _value.cellDisplayName
            : cellDisplayName // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PlacementLineDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CellPlacementInfoDtoImpl implements _CellPlacementInfoDto {
  const _$CellPlacementInfoDtoImpl({
    required this.targetPositionId,
    this.cellCode,
    this.cellDisplayName,
    final List<PlacementLineDto> items = const [],
  }) : _items = items;

  factory _$CellPlacementInfoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CellPlacementInfoDtoImplFromJson(json);

  @override
  final int targetPositionId;
  @override
  final String? cellCode;
  @override
  final String? cellDisplayName;
  final List<PlacementLineDto> _items;
  @override
  @JsonKey()
  List<PlacementLineDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CellPlacementInfoDto(targetPositionId: $targetPositionId, cellCode: $cellCode, cellDisplayName: $cellDisplayName, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CellPlacementInfoDtoImpl &&
            (identical(other.targetPositionId, targetPositionId) ||
                other.targetPositionId == targetPositionId) &&
            (identical(other.cellCode, cellCode) ||
                other.cellCode == cellCode) &&
            (identical(other.cellDisplayName, cellDisplayName) ||
                other.cellDisplayName == cellDisplayName) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    targetPositionId,
    cellCode,
    cellDisplayName,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of CellPlacementInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CellPlacementInfoDtoImplCopyWith<_$CellPlacementInfoDtoImpl>
  get copyWith =>
      __$$CellPlacementInfoDtoImplCopyWithImpl<_$CellPlacementInfoDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CellPlacementInfoDtoImplToJson(this);
  }
}

abstract class _CellPlacementInfoDto implements CellPlacementInfoDto {
  const factory _CellPlacementInfoDto({
    required final int targetPositionId,
    final String? cellCode,
    final String? cellDisplayName,
    final List<PlacementLineDto> items,
  }) = _$CellPlacementInfoDtoImpl;

  factory _CellPlacementInfoDto.fromJson(Map<String, dynamic> json) =
      _$CellPlacementInfoDtoImpl.fromJson;

  @override
  int get targetPositionId;
  @override
  String? get cellCode;
  @override
  String? get cellDisplayName;
  @override
  List<PlacementLineDto> get items;

  /// Create a copy of CellPlacementInfoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CellPlacementInfoDtoImplCopyWith<_$CellPlacementInfoDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

WorkerAssemblyTaskDto _$WorkerAssemblyTaskDtoFromJson(
  Map<String, dynamic> json,
) {
  return _WorkerAssemblyTaskDto.fromJson(json);
}

/// @nodoc
mixin _$WorkerAssemblyTaskDto {
  int get assignmentId => throw _privateConstructorUsedError;
  int get taskId => throw _privateConstructorUsedError;
  String? get taskNumber => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  AssignmentStatus get status => throw _privateConstructorUsedError;
  DateTime? get createdDate => throw _privateConstructorUsedError;
  int get totalLines => throw _privateConstructorUsedError;
  List<CellPlacementInfoDto> get cellPlacements =>
      throw _privateConstructorUsedError;
  bool get isCooperative => throw _privateConstructorUsedError;
  String? get partnerName => throw _privateConstructorUsedError;
  AssignmentStatus? get partnerStatus => throw _privateConstructorUsedError;

  /// Serializes this WorkerAssemblyTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkerAssemblyTaskDtoCopyWith<WorkerAssemblyTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkerAssemblyTaskDtoCopyWith<$Res> {
  factory $WorkerAssemblyTaskDtoCopyWith(
    WorkerAssemblyTaskDto value,
    $Res Function(WorkerAssemblyTaskDto) then,
  ) = _$WorkerAssemblyTaskDtoCopyWithImpl<$Res, WorkerAssemblyTaskDto>;
  @useResult
  $Res call({
    int assignmentId,
    int taskId,
    String? taskNumber,
    int orderId,
    AssignmentStatus status,
    DateTime? createdDate,
    int totalLines,
    List<CellPlacementInfoDto> cellPlacements,
    bool isCooperative,
    String? partnerName,
    AssignmentStatus? partnerStatus,
  });
}

/// @nodoc
class _$WorkerAssemblyTaskDtoCopyWithImpl<
  $Res,
  $Val extends WorkerAssemblyTaskDto
>
    implements $WorkerAssemblyTaskDtoCopyWith<$Res> {
  _$WorkerAssemblyTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? taskId = null,
    Object? taskNumber = freezed,
    Object? orderId = null,
    Object? status = null,
    Object? createdDate = freezed,
    Object? totalLines = null,
    Object? cellPlacements = null,
    Object? isCooperative = null,
    Object? partnerName = freezed,
    Object? partnerStatus = freezed,
  }) {
    return _then(
      _value.copyWith(
            assignmentId: null == assignmentId
                ? _value.assignmentId
                : assignmentId // ignore: cast_nullable_to_non_nullable
                      as int,
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as int,
            taskNumber: freezed == taskNumber
                ? _value.taskNumber
                : taskNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AssignmentStatus,
            createdDate: freezed == createdDate
                ? _value.createdDate
                : createdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalLines: null == totalLines
                ? _value.totalLines
                : totalLines // ignore: cast_nullable_to_non_nullable
                      as int,
            cellPlacements: null == cellPlacements
                ? _value.cellPlacements
                : cellPlacements // ignore: cast_nullable_to_non_nullable
                      as List<CellPlacementInfoDto>,
            isCooperative: null == isCooperative
                ? _value.isCooperative
                : isCooperative // ignore: cast_nullable_to_non_nullable
                      as bool,
            partnerName: freezed == partnerName
                ? _value.partnerName
                : partnerName // ignore: cast_nullable_to_non_nullable
                      as String?,
            partnerStatus: freezed == partnerStatus
                ? _value.partnerStatus
                : partnerStatus // ignore: cast_nullable_to_non_nullable
                      as AssignmentStatus?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkerAssemblyTaskDtoImplCopyWith<$Res>
    implements $WorkerAssemblyTaskDtoCopyWith<$Res> {
  factory _$$WorkerAssemblyTaskDtoImplCopyWith(
    _$WorkerAssemblyTaskDtoImpl value,
    $Res Function(_$WorkerAssemblyTaskDtoImpl) then,
  ) = __$$WorkerAssemblyTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int assignmentId,
    int taskId,
    String? taskNumber,
    int orderId,
    AssignmentStatus status,
    DateTime? createdDate,
    int totalLines,
    List<CellPlacementInfoDto> cellPlacements,
    bool isCooperative,
    String? partnerName,
    AssignmentStatus? partnerStatus,
  });
}

/// @nodoc
class __$$WorkerAssemblyTaskDtoImplCopyWithImpl<$Res>
    extends
        _$WorkerAssemblyTaskDtoCopyWithImpl<$Res, _$WorkerAssemblyTaskDtoImpl>
    implements _$$WorkerAssemblyTaskDtoImplCopyWith<$Res> {
  __$$WorkerAssemblyTaskDtoImplCopyWithImpl(
    _$WorkerAssemblyTaskDtoImpl _value,
    $Res Function(_$WorkerAssemblyTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignmentId = null,
    Object? taskId = null,
    Object? taskNumber = freezed,
    Object? orderId = null,
    Object? status = null,
    Object? createdDate = freezed,
    Object? totalLines = null,
    Object? cellPlacements = null,
    Object? isCooperative = null,
    Object? partnerName = freezed,
    Object? partnerStatus = freezed,
  }) {
    return _then(
      _$WorkerAssemblyTaskDtoImpl(
        assignmentId: null == assignmentId
            ? _value.assignmentId
            : assignmentId // ignore: cast_nullable_to_non_nullable
                  as int,
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as int,
        taskNumber: freezed == taskNumber
            ? _value.taskNumber
            : taskNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AssignmentStatus,
        createdDate: freezed == createdDate
            ? _value.createdDate
            : createdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalLines: null == totalLines
            ? _value.totalLines
            : totalLines // ignore: cast_nullable_to_non_nullable
                  as int,
        cellPlacements: null == cellPlacements
            ? _value._cellPlacements
            : cellPlacements // ignore: cast_nullable_to_non_nullable
                  as List<CellPlacementInfoDto>,
        isCooperative: null == isCooperative
            ? _value.isCooperative
            : isCooperative // ignore: cast_nullable_to_non_nullable
                  as bool,
        partnerName: freezed == partnerName
            ? _value.partnerName
            : partnerName // ignore: cast_nullable_to_non_nullable
                  as String?,
        partnerStatus: freezed == partnerStatus
            ? _value.partnerStatus
            : partnerStatus // ignore: cast_nullable_to_non_nullable
                  as AssignmentStatus?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkerAssemblyTaskDtoImpl implements _WorkerAssemblyTaskDto {
  const _$WorkerAssemblyTaskDtoImpl({
    required this.assignmentId,
    required this.taskId,
    this.taskNumber,
    required this.orderId,
    required this.status,
    this.createdDate,
    required this.totalLines,
    final List<CellPlacementInfoDto> cellPlacements = const [],
    this.isCooperative = false,
    this.partnerName,
    this.partnerStatus,
  }) : _cellPlacements = cellPlacements;

  factory _$WorkerAssemblyTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkerAssemblyTaskDtoImplFromJson(json);

  @override
  final int assignmentId;
  @override
  final int taskId;
  @override
  final String? taskNumber;
  @override
  final int orderId;
  @override
  final AssignmentStatus status;
  @override
  final DateTime? createdDate;
  @override
  final int totalLines;
  final List<CellPlacementInfoDto> _cellPlacements;
  @override
  @JsonKey()
  List<CellPlacementInfoDto> get cellPlacements {
    if (_cellPlacements is EqualUnmodifiableListView) return _cellPlacements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cellPlacements);
  }

  @override
  @JsonKey()
  final bool isCooperative;
  @override
  final String? partnerName;
  @override
  final AssignmentStatus? partnerStatus;

  @override
  String toString() {
    return 'WorkerAssemblyTaskDto(assignmentId: $assignmentId, taskId: $taskId, taskNumber: $taskNumber, orderId: $orderId, status: $status, createdDate: $createdDate, totalLines: $totalLines, cellPlacements: $cellPlacements, isCooperative: $isCooperative, partnerName: $partnerName, partnerStatus: $partnerStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkerAssemblyTaskDtoImpl &&
            (identical(other.assignmentId, assignmentId) ||
                other.assignmentId == assignmentId) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.taskNumber, taskNumber) ||
                other.taskNumber == taskNumber) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.totalLines, totalLines) ||
                other.totalLines == totalLines) &&
            const DeepCollectionEquality().equals(
              other._cellPlacements,
              _cellPlacements,
            ) &&
            (identical(other.isCooperative, isCooperative) ||
                other.isCooperative == isCooperative) &&
            (identical(other.partnerName, partnerName) ||
                other.partnerName == partnerName) &&
            (identical(other.partnerStatus, partnerStatus) ||
                other.partnerStatus == partnerStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    assignmentId,
    taskId,
    taskNumber,
    orderId,
    status,
    createdDate,
    totalLines,
    const DeepCollectionEquality().hash(_cellPlacements),
    isCooperative,
    partnerName,
    partnerStatus,
  );

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkerAssemblyTaskDtoImplCopyWith<_$WorkerAssemblyTaskDtoImpl>
  get copyWith =>
      __$$WorkerAssemblyTaskDtoImplCopyWithImpl<_$WorkerAssemblyTaskDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkerAssemblyTaskDtoImplToJson(this);
  }
}

abstract class _WorkerAssemblyTaskDto implements WorkerAssemblyTaskDto {
  const factory _WorkerAssemblyTaskDto({
    required final int assignmentId,
    required final int taskId,
    final String? taskNumber,
    required final int orderId,
    required final AssignmentStatus status,
    final DateTime? createdDate,
    required final int totalLines,
    final List<CellPlacementInfoDto> cellPlacements,
    final bool isCooperative,
    final String? partnerName,
    final AssignmentStatus? partnerStatus,
  }) = _$WorkerAssemblyTaskDtoImpl;

  factory _WorkerAssemblyTaskDto.fromJson(Map<String, dynamic> json) =
      _$WorkerAssemblyTaskDtoImpl.fromJson;

  @override
  int get assignmentId;
  @override
  int get taskId;
  @override
  String? get taskNumber;
  @override
  int get orderId;
  @override
  AssignmentStatus get status;
  @override
  DateTime? get createdDate;
  @override
  int get totalLines;
  @override
  List<CellPlacementInfoDto> get cellPlacements;
  @override
  bool get isCooperative;
  @override
  String? get partnerName;
  @override
  AssignmentStatus? get partnerStatus;

  /// Create a copy of WorkerAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkerAssemblyTaskDtoImplCopyWith<_$WorkerAssemblyTaskDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
