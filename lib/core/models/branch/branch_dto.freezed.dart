// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BranchDto _$BranchDtoFromJson(Map<String, dynamic> json) {
  return _BranchDto.fromJson(json);
}

/// @nodoc
mixin _$BranchDto {
  int get branchId => throw _privateConstructorUsedError;
  String get branchName => throw _privateConstructorUsedError;
  String get branchType => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;

  /// Serializes this BranchDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BranchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BranchDtoCopyWith<BranchDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BranchDtoCopyWith<$Res> {
  factory $BranchDtoCopyWith(BranchDto value, $Res Function(BranchDto) then) =
      _$BranchDtoCopyWithImpl<$Res, BranchDto>;
  @useResult
  $Res call({
    int branchId,
    String branchName,
    String branchType,
    String address,
  });
}

/// @nodoc
class _$BranchDtoCopyWithImpl<$Res, $Val extends BranchDto>
    implements $BranchDtoCopyWith<$Res> {
  _$BranchDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BranchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? branchName = null,
    Object? branchType = null,
    Object? address = null,
  }) {
    return _then(
      _value.copyWith(
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int,
            branchName: null == branchName
                ? _value.branchName
                : branchName // ignore: cast_nullable_to_non_nullable
                      as String,
            branchType: null == branchType
                ? _value.branchType
                : branchType // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BranchDtoImplCopyWith<$Res>
    implements $BranchDtoCopyWith<$Res> {
  factory _$$BranchDtoImplCopyWith(
    _$BranchDtoImpl value,
    $Res Function(_$BranchDtoImpl) then,
  ) = __$$BranchDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int branchId,
    String branchName,
    String branchType,
    String address,
  });
}

/// @nodoc
class __$$BranchDtoImplCopyWithImpl<$Res>
    extends _$BranchDtoCopyWithImpl<$Res, _$BranchDtoImpl>
    implements _$$BranchDtoImplCopyWith<$Res> {
  __$$BranchDtoImplCopyWithImpl(
    _$BranchDtoImpl _value,
    $Res Function(_$BranchDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BranchDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? branchId = null,
    Object? branchName = null,
    Object? branchType = null,
    Object? address = null,
  }) {
    return _then(
      _$BranchDtoImpl(
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int,
        branchName: null == branchName
            ? _value.branchName
            : branchName // ignore: cast_nullable_to_non_nullable
                  as String,
        branchType: null == branchType
            ? _value.branchType
            : branchType // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BranchDtoImpl implements _BranchDto {
  const _$BranchDtoImpl({
    this.branchId = 0,
    this.branchName = '',
    this.branchType = '',
    this.address = '',
  });

  factory _$BranchDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BranchDtoImplFromJson(json);

  @override
  @JsonKey()
  final int branchId;
  @override
  @JsonKey()
  final String branchName;
  @override
  @JsonKey()
  final String branchType;
  @override
  @JsonKey()
  final String address;

  @override
  String toString() {
    return 'BranchDto(branchId: $branchId, branchName: $branchName, branchType: $branchType, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BranchDtoImpl &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.branchName, branchName) ||
                other.branchName == branchName) &&
            (identical(other.branchType, branchType) ||
                other.branchType == branchType) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, branchId, branchName, branchType, address);

  /// Create a copy of BranchDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BranchDtoImplCopyWith<_$BranchDtoImpl> get copyWith =>
      __$$BranchDtoImplCopyWithImpl<_$BranchDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BranchDtoImplToJson(this);
  }
}

abstract class _BranchDto implements BranchDto {
  const factory _BranchDto({
    final int branchId,
    final String branchName,
    final String branchType,
    final String address,
  }) = _$BranchDtoImpl;

  factory _BranchDto.fromJson(Map<String, dynamic> json) =
      _$BranchDtoImpl.fromJson;

  @override
  int get branchId;
  @override
  String get branchName;
  @override
  String get branchType;
  @override
  String get address;

  /// Create a copy of BranchDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BranchDtoImplCopyWith<_$BranchDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
