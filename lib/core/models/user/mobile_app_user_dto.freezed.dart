// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_app_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileAppUserDto _$MobileAppUserDtoFromJson(Map<String, dynamic> json) {
  return _MobileAppUserDto.fromJson(json);
}

/// @nodoc
mixin _$MobileAppUserDto {
  int get id => throw _privateConstructorUsedError;
  int get employeeId => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MobileAppUserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileAppUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileAppUserDtoCopyWith<MobileAppUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileAppUserDtoCopyWith<$Res> {
  factory $MobileAppUserDtoCopyWith(
    MobileAppUserDto value,
    $Res Function(MobileAppUserDto) then,
  ) = _$MobileAppUserDtoCopyWithImpl<$Res, MobileAppUserDto>;
  @useResult
  $Res call({
    int id,
    int employeeId,
    String firstName,
    String lastName,
    String role,
    bool isActive,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$MobileAppUserDtoCopyWithImpl<$Res, $Val extends MobileAppUserDto>
    implements $MobileAppUserDtoCopyWith<$Res> {
  _$MobileAppUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileAppUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as int,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileAppUserDtoImplCopyWith<$Res>
    implements $MobileAppUserDtoCopyWith<$Res> {
  factory _$$MobileAppUserDtoImplCopyWith(
    _$MobileAppUserDtoImpl value,
    $Res Function(_$MobileAppUserDtoImpl) then,
  ) = __$$MobileAppUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int employeeId,
    String firstName,
    String lastName,
    String role,
    bool isActive,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$MobileAppUserDtoImplCopyWithImpl<$Res>
    extends _$MobileAppUserDtoCopyWithImpl<$Res, _$MobileAppUserDtoImpl>
    implements _$$MobileAppUserDtoImplCopyWith<$Res> {
  __$$MobileAppUserDtoImplCopyWithImpl(
    _$MobileAppUserDtoImpl _value,
    $Res Function(_$MobileAppUserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileAppUserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? employeeId = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? role = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$MobileAppUserDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as int,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileAppUserDtoImpl implements _MobileAppUserDto {
  const _$MobileAppUserDtoImpl({
    required this.id,
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory _$MobileAppUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileAppUserDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int employeeId;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final String role;
  @override
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MobileAppUserDto(id: $id, employeeId: $employeeId, firstName: $firstName, lastName: $lastName, role: $role, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileAppUserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    employeeId,
    firstName,
    lastName,
    role,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MobileAppUserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileAppUserDtoImplCopyWith<_$MobileAppUserDtoImpl> get copyWith =>
      __$$MobileAppUserDtoImplCopyWithImpl<_$MobileAppUserDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileAppUserDtoImplToJson(this);
  }
}

abstract class _MobileAppUserDto implements MobileAppUserDto {
  const factory _MobileAppUserDto({
    required final int id,
    required final int employeeId,
    required final String firstName,
    required final String lastName,
    required final String role,
    required final bool isActive,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$MobileAppUserDtoImpl;

  factory _MobileAppUserDto.fromJson(Map<String, dynamic> json) =
      _$MobileAppUserDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get employeeId;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get role;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MobileAppUserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileAppUserDtoImplCopyWith<_$MobileAppUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
