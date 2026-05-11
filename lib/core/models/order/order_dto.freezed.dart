// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) {
  return _OrderDto.fromJson(json);
}

/// @nodoc
mixin _$OrderDto {
  int get orderId => throw _privateConstructorUsedError;
  int get customerId => throw _privateConstructorUsedError;
  int get branchId => throw _privateConstructorUsedError;
  String get deliveryType => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError; // Добавлено
  String get status => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  int? get deliverySlotId => throw _privateConstructorUsedError; // Добавлено
  String? get destinationAddress =>
      throw _privateConstructorUsedError; // Добавлено
  int? get postamatId => throw _privateConstructorUsedError; // Добавлено
  int? get postamatCellId => throw _privateConstructorUsedError; // Добавлено
  List<OrderPositionDto> get positions => throw _privateConstructorUsedError;

  /// Serializes this OrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDtoCopyWith<OrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDtoCopyWith<$Res> {
  factory $OrderDtoCopyWith(OrderDto value, $Res Function(OrderDto) then) =
      _$OrderDtoCopyWithImpl<$Res, OrderDto>;
  @useResult
  $Res call({
    int orderId,
    int customerId,
    int branchId,
    String deliveryType,
    String paymentType,
    String status,
    double totalPrice,
    DateTime? deliveryDate,
    DateTime? createdAt,
    int? deliverySlotId,
    String? destinationAddress,
    int? postamatId,
    int? postamatCellId,
    List<OrderPositionDto> positions,
  });
}

/// @nodoc
class _$OrderDtoCopyWithImpl<$Res, $Val extends OrderDto>
    implements $OrderDtoCopyWith<$Res> {
  _$OrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? customerId = null,
    Object? branchId = null,
    Object? deliveryType = null,
    Object? paymentType = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? deliveryDate = freezed,
    Object? createdAt = freezed,
    Object? deliverySlotId = freezed,
    Object? destinationAddress = freezed,
    Object? postamatId = freezed,
    Object? postamatCellId = freezed,
    Object? positions = null,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as int,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int,
            deliveryType: null == deliveryType
                ? _value.deliveryType
                : deliveryType // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentType: null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryDate: freezed == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliverySlotId: freezed == deliverySlotId
                ? _value.deliverySlotId
                : deliverySlotId // ignore: cast_nullable_to_non_nullable
                      as int?,
            destinationAddress: freezed == destinationAddress
                ? _value.destinationAddress
                : destinationAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            postamatId: freezed == postamatId
                ? _value.postamatId
                : postamatId // ignore: cast_nullable_to_non_nullable
                      as int?,
            postamatCellId: freezed == postamatCellId
                ? _value.postamatCellId
                : postamatCellId // ignore: cast_nullable_to_non_nullable
                      as int?,
            positions: null == positions
                ? _value.positions
                : positions // ignore: cast_nullable_to_non_nullable
                      as List<OrderPositionDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderDtoImplCopyWith<$Res>
    implements $OrderDtoCopyWith<$Res> {
  factory _$$OrderDtoImplCopyWith(
    _$OrderDtoImpl value,
    $Res Function(_$OrderDtoImpl) then,
  ) = __$$OrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int orderId,
    int customerId,
    int branchId,
    String deliveryType,
    String paymentType,
    String status,
    double totalPrice,
    DateTime? deliveryDate,
    DateTime? createdAt,
    int? deliverySlotId,
    String? destinationAddress,
    int? postamatId,
    int? postamatCellId,
    List<OrderPositionDto> positions,
  });
}

/// @nodoc
class __$$OrderDtoImplCopyWithImpl<$Res>
    extends _$OrderDtoCopyWithImpl<$Res, _$OrderDtoImpl>
    implements _$$OrderDtoImplCopyWith<$Res> {
  __$$OrderDtoImplCopyWithImpl(
    _$OrderDtoImpl _value,
    $Res Function(_$OrderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? customerId = null,
    Object? branchId = null,
    Object? deliveryType = null,
    Object? paymentType = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? deliveryDate = freezed,
    Object? createdAt = freezed,
    Object? deliverySlotId = freezed,
    Object? destinationAddress = freezed,
    Object? postamatId = freezed,
    Object? postamatCellId = freezed,
    Object? positions = null,
  }) {
    return _then(
      _$OrderDtoImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as int,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int,
        deliveryType: null == deliveryType
            ? _value.deliveryType
            : deliveryType // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentType: null == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryDate: freezed == deliveryDate
            ? _value.deliveryDate
            : deliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliverySlotId: freezed == deliverySlotId
            ? _value.deliverySlotId
            : deliverySlotId // ignore: cast_nullable_to_non_nullable
                  as int?,
        destinationAddress: freezed == destinationAddress
            ? _value.destinationAddress
            : destinationAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        postamatId: freezed == postamatId
            ? _value.postamatId
            : postamatId // ignore: cast_nullable_to_non_nullable
                  as int?,
        postamatCellId: freezed == postamatCellId
            ? _value.postamatCellId
            : postamatCellId // ignore: cast_nullable_to_non_nullable
                  as int?,
        positions: null == positions
            ? _value._positions
            : positions // ignore: cast_nullable_to_non_nullable
                  as List<OrderPositionDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDtoImpl implements _OrderDto {
  const _$OrderDtoImpl({
    required this.orderId,
    required this.customerId,
    required this.branchId,
    required this.deliveryType,
    required this.paymentType,
    required this.status,
    required this.totalPrice,
    this.deliveryDate,
    this.createdAt,
    this.deliverySlotId,
    this.destinationAddress,
    this.postamatId,
    this.postamatCellId,
    final List<OrderPositionDto> positions = const [],
  }) : _positions = positions;

  factory _$OrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDtoImplFromJson(json);

  @override
  final int orderId;
  @override
  final int customerId;
  @override
  final int branchId;
  @override
  final String deliveryType;
  @override
  final String paymentType;
  // Добавлено
  @override
  final String status;
  @override
  final double totalPrice;
  @override
  final DateTime? deliveryDate;
  @override
  final DateTime? createdAt;
  @override
  final int? deliverySlotId;
  // Добавлено
  @override
  final String? destinationAddress;
  // Добавлено
  @override
  final int? postamatId;
  // Добавлено
  @override
  final int? postamatCellId;
  // Добавлено
  final List<OrderPositionDto> _positions;
  // Добавлено
  @override
  @JsonKey()
  List<OrderPositionDto> get positions {
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_positions);
  }

  @override
  String toString() {
    return 'OrderDto(orderId: $orderId, customerId: $customerId, branchId: $branchId, deliveryType: $deliveryType, paymentType: $paymentType, status: $status, totalPrice: $totalPrice, deliveryDate: $deliveryDate, createdAt: $createdAt, deliverySlotId: $deliverySlotId, destinationAddress: $destinationAddress, postamatId: $postamatId, postamatCellId: $postamatCellId, positions: $positions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.deliveryType, deliveryType) ||
                other.deliveryType == deliveryType) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deliverySlotId, deliverySlotId) ||
                other.deliverySlotId == deliverySlotId) &&
            (identical(other.destinationAddress, destinationAddress) ||
                other.destinationAddress == destinationAddress) &&
            (identical(other.postamatId, postamatId) ||
                other.postamatId == postamatId) &&
            (identical(other.postamatCellId, postamatCellId) ||
                other.postamatCellId == postamatCellId) &&
            const DeepCollectionEquality().equals(
              other._positions,
              _positions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    customerId,
    branchId,
    deliveryType,
    paymentType,
    status,
    totalPrice,
    deliveryDate,
    createdAt,
    deliverySlotId,
    destinationAddress,
    postamatId,
    postamatCellId,
    const DeepCollectionEquality().hash(_positions),
  );

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      __$$OrderDtoImplCopyWithImpl<_$OrderDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDtoImplToJson(this);
  }
}

abstract class _OrderDto implements OrderDto {
  const factory _OrderDto({
    required final int orderId,
    required final int customerId,
    required final int branchId,
    required final String deliveryType,
    required final String paymentType,
    required final String status,
    required final double totalPrice,
    final DateTime? deliveryDate,
    final DateTime? createdAt,
    final int? deliverySlotId,
    final String? destinationAddress,
    final int? postamatId,
    final int? postamatCellId,
    final List<OrderPositionDto> positions,
  }) = _$OrderDtoImpl;

  factory _OrderDto.fromJson(Map<String, dynamic> json) =
      _$OrderDtoImpl.fromJson;

  @override
  int get orderId;
  @override
  int get customerId;
  @override
  int get branchId;
  @override
  String get deliveryType;
  @override
  String get paymentType; // Добавлено
  @override
  String get status;
  @override
  double get totalPrice;
  @override
  DateTime? get deliveryDate;
  @override
  DateTime? get createdAt;
  @override
  int? get deliverySlotId; // Добавлено
  @override
  String? get destinationAddress; // Добавлено
  @override
  int? get postamatId; // Добавлено
  @override
  int? get postamatCellId; // Добавлено
  @override
  List<OrderPositionDto> get positions;

  /// Create a copy of OrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDtoImplCopyWith<_$OrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderPositionDto _$OrderPositionDtoFromJson(Map<String, dynamic> json) {
  return _OrderPositionDto.fromJson(json);
}

/// @nodoc
mixin _$OrderPositionDto {
  int get uniqueId => throw _privateConstructorUsedError;
  int get itemId => throw _privateConstructorUsedError;
  String? get itemName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this OrderPositionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPositionDtoCopyWith<OrderPositionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPositionDtoCopyWith<$Res> {
  factory $OrderPositionDtoCopyWith(
    OrderPositionDto value,
    $Res Function(OrderPositionDto) then,
  ) = _$OrderPositionDtoCopyWithImpl<$Res, OrderPositionDto>;
  @useResult
  $Res call({
    int uniqueId,
    int itemId,
    String? itemName,
    int quantity,
    double price,
  });
}

/// @nodoc
class _$OrderPositionDtoCopyWithImpl<$Res, $Val extends OrderPositionDto>
    implements $OrderPositionDtoCopyWith<$Res> {
  _$OrderPositionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uniqueId = null,
    Object? itemId = null,
    Object? itemName = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _value.copyWith(
            uniqueId: null == uniqueId
                ? _value.uniqueId
                : uniqueId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemId: null == itemId
                ? _value.itemId
                : itemId // ignore: cast_nullable_to_non_nullable
                      as int,
            itemName: freezed == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String?,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderPositionDtoImplCopyWith<$Res>
    implements $OrderPositionDtoCopyWith<$Res> {
  factory _$$OrderPositionDtoImplCopyWith(
    _$OrderPositionDtoImpl value,
    $Res Function(_$OrderPositionDtoImpl) then,
  ) = __$$OrderPositionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int uniqueId,
    int itemId,
    String? itemName,
    int quantity,
    double price,
  });
}

/// @nodoc
class __$$OrderPositionDtoImplCopyWithImpl<$Res>
    extends _$OrderPositionDtoCopyWithImpl<$Res, _$OrderPositionDtoImpl>
    implements _$$OrderPositionDtoImplCopyWith<$Res> {
  __$$OrderPositionDtoImplCopyWithImpl(
    _$OrderPositionDtoImpl _value,
    $Res Function(_$OrderPositionDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uniqueId = null,
    Object? itemId = null,
    Object? itemName = freezed,
    Object? quantity = null,
    Object? price = null,
  }) {
    return _then(
      _$OrderPositionDtoImpl(
        uniqueId: null == uniqueId
            ? _value.uniqueId
            : uniqueId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        itemName: freezed == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String?,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderPositionDtoImpl implements _OrderPositionDto {
  const _$OrderPositionDtoImpl({
    required this.uniqueId,
    required this.itemId,
    this.itemName,
    required this.quantity,
    required this.price,
  });

  factory _$OrderPositionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPositionDtoImplFromJson(json);

  @override
  final int uniqueId;
  @override
  final int itemId;
  @override
  final String? itemName;
  @override
  final int quantity;
  @override
  final double price;

  @override
  String toString() {
    return 'OrderPositionDto(uniqueId: $uniqueId, itemId: $itemId, itemName: $itemName, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPositionDtoImpl &&
            (identical(other.uniqueId, uniqueId) ||
                other.uniqueId == uniqueId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uniqueId, itemId, itemName, quantity, price);

  /// Create a copy of OrderPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPositionDtoImplCopyWith<_$OrderPositionDtoImpl> get copyWith =>
      __$$OrderPositionDtoImplCopyWithImpl<_$OrderPositionDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPositionDtoImplToJson(this);
  }
}

abstract class _OrderPositionDto implements OrderPositionDto {
  const factory _OrderPositionDto({
    required final int uniqueId,
    required final int itemId,
    final String? itemName,
    required final int quantity,
    required final double price,
  }) = _$OrderPositionDtoImpl;

  factory _OrderPositionDto.fromJson(Map<String, dynamic> json) =
      _$OrderPositionDtoImpl.fromJson;

  @override
  int get uniqueId;
  @override
  int get itemId;
  @override
  String? get itemName;
  @override
  int get quantity;
  @override
  double get price;

  /// Create a copy of OrderPositionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPositionDtoImplCopyWith<_$OrderPositionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
