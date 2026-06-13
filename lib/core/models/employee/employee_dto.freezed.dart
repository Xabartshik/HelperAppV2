// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeeDto _$EmployeeDtoFromJson(Map<String, dynamic> json) {
  return _EmployeeDto.fromJson(json);
}

/// @nodoc
mixin _$EmployeeDto {
  int get employeesId => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get middleName => throw _privateConstructorUsedError;
  WorkerRole get role => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;

  /// Serializes this EmployeeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeDtoCopyWith<EmployeeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeDtoCopyWith<$Res> {
  factory $EmployeeDtoCopyWith(
    EmployeeDto value,
    $Res Function(EmployeeDto) then,
  ) = _$EmployeeDtoCopyWithImpl<$Res, EmployeeDto>;
  @useResult
  $Res call({
    int employeesId,
    String surname,
    String name,
    String? middleName,
    WorkerRole role,
    bool isBlocked,
  });
}

/// @nodoc
class _$EmployeeDtoCopyWithImpl<$Res, $Val extends EmployeeDto>
    implements $EmployeeDtoCopyWith<$Res> {
  _$EmployeeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeesId = null,
    Object? surname = null,
    Object? name = null,
    Object? middleName = freezed,
    Object? role = null,
    Object? isBlocked = null,
  }) {
    return _then(
      _value.copyWith(
            employeesId: null == employeesId
                ? _value.employeesId
                : employeesId // ignore: cast_nullable_to_non_nullable
                      as int,
            surname: null == surname
                ? _value.surname
                : surname // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            middleName: freezed == middleName
                ? _value.middleName
                : middleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as WorkerRole,
            isBlocked: null == isBlocked
                ? _value.isBlocked
                : isBlocked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeDtoImplCopyWith<$Res>
    implements $EmployeeDtoCopyWith<$Res> {
  factory _$$EmployeeDtoImplCopyWith(
    _$EmployeeDtoImpl value,
    $Res Function(_$EmployeeDtoImpl) then,
  ) = __$$EmployeeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int employeesId,
    String surname,
    String name,
    String? middleName,
    WorkerRole role,
    bool isBlocked,
  });
}

/// @nodoc
class __$$EmployeeDtoImplCopyWithImpl<$Res>
    extends _$EmployeeDtoCopyWithImpl<$Res, _$EmployeeDtoImpl>
    implements _$$EmployeeDtoImplCopyWith<$Res> {
  __$$EmployeeDtoImplCopyWithImpl(
    _$EmployeeDtoImpl _value,
    $Res Function(_$EmployeeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeesId = null,
    Object? surname = null,
    Object? name = null,
    Object? middleName = freezed,
    Object? role = null,
    Object? isBlocked = null,
  }) {
    return _then(
      _$EmployeeDtoImpl(
        employeesId: null == employeesId
            ? _value.employeesId
            : employeesId // ignore: cast_nullable_to_non_nullable
                  as int,
        surname: null == surname
            ? _value.surname
            : surname // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        middleName: freezed == middleName
            ? _value.middleName
            : middleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as WorkerRole,
        isBlocked: null == isBlocked
            ? _value.isBlocked
            : isBlocked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeDtoImpl implements _EmployeeDto {
  const _$EmployeeDtoImpl({
    this.employeesId = 0,
    required this.surname,
    required this.name,
    this.middleName,
    this.role = WorkerRole.storekeeper,
    this.isBlocked = false,
  });

  factory _$EmployeeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeDtoImplFromJson(json);

  @override
  @JsonKey()
  final int employeesId;
  @override
  final String surname;
  @override
  final String name;
  @override
  final String? middleName;
  @override
  @JsonKey()
  final WorkerRole role;
  @override
  @JsonKey()
  final bool isBlocked;

  @override
  String toString() {
    return 'EmployeeDto(employeesId: $employeesId, surname: $surname, name: $name, middleName: $middleName, role: $role, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeDtoImpl &&
            (identical(other.employeesId, employeesId) ||
                other.employeesId == employeesId) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeesId,
    surname,
    name,
    middleName,
    role,
    isBlocked,
  );

  /// Create a copy of EmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeDtoImplCopyWith<_$EmployeeDtoImpl> get copyWith =>
      __$$EmployeeDtoImplCopyWithImpl<_$EmployeeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeDtoImplToJson(this);
  }
}

abstract class _EmployeeDto implements EmployeeDto {
  const factory _EmployeeDto({
    final int employeesId,
    required final String surname,
    required final String name,
    final String? middleName,
    final WorkerRole role,
    final bool isBlocked,
  }) = _$EmployeeDtoImpl;

  factory _EmployeeDto.fromJson(Map<String, dynamic> json) =
      _$EmployeeDtoImpl.fromJson;

  @override
  int get employeesId;
  @override
  String get surname;
  @override
  String get name;
  @override
  String? get middleName;
  @override
  WorkerRole get role;
  @override
  bool get isBlocked;

  /// Create a copy of EmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeDtoImplCopyWith<_$EmployeeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
