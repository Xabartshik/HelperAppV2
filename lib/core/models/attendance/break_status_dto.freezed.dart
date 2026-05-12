// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'break_status_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BreakStatusDto _$BreakStatusDtoFromJson(Map<String, dynamic> json) {
  return _BreakStatusDto.fromJson(json);
}

/// @nodoc
mixin _$BreakStatusDto {
  bool get isOnBreak => throw _privateConstructorUsedError;
  int get accumulatedMinutes => throw _privateConstructorUsedError;
  bool get canStartBreak => throw _privateConstructorUsedError;
  bool get isLimitReached => throw _privateConstructorUsedError;
  bool get hasActiveTasks => throw _privateConstructorUsedError;

  /// Serializes this BreakStatusDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BreakStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BreakStatusDtoCopyWith<BreakStatusDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakStatusDtoCopyWith<$Res> {
  factory $BreakStatusDtoCopyWith(
    BreakStatusDto value,
    $Res Function(BreakStatusDto) then,
  ) = _$BreakStatusDtoCopyWithImpl<$Res, BreakStatusDto>;
  @useResult
  $Res call({
    bool isOnBreak,
    int accumulatedMinutes,
    bool canStartBreak,
    bool isLimitReached,
    bool hasActiveTasks,
  });
}

/// @nodoc
class _$BreakStatusDtoCopyWithImpl<$Res, $Val extends BreakStatusDto>
    implements $BreakStatusDtoCopyWith<$Res> {
  _$BreakStatusDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BreakStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnBreak = null,
    Object? accumulatedMinutes = null,
    Object? canStartBreak = null,
    Object? isLimitReached = null,
    Object? hasActiveTasks = null,
  }) {
    return _then(
      _value.copyWith(
            isOnBreak: null == isOnBreak
                ? _value.isOnBreak
                : isOnBreak // ignore: cast_nullable_to_non_nullable
                      as bool,
            accumulatedMinutes: null == accumulatedMinutes
                ? _value.accumulatedMinutes
                : accumulatedMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            canStartBreak: null == canStartBreak
                ? _value.canStartBreak
                : canStartBreak // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLimitReached: null == isLimitReached
                ? _value.isLimitReached
                : isLimitReached // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasActiveTasks: null == hasActiveTasks
                ? _value.hasActiveTasks
                : hasActiveTasks // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BreakStatusDtoImplCopyWith<$Res>
    implements $BreakStatusDtoCopyWith<$Res> {
  factory _$$BreakStatusDtoImplCopyWith(
    _$BreakStatusDtoImpl value,
    $Res Function(_$BreakStatusDtoImpl) then,
  ) = __$$BreakStatusDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isOnBreak,
    int accumulatedMinutes,
    bool canStartBreak,
    bool isLimitReached,
    bool hasActiveTasks,
  });
}

/// @nodoc
class __$$BreakStatusDtoImplCopyWithImpl<$Res>
    extends _$BreakStatusDtoCopyWithImpl<$Res, _$BreakStatusDtoImpl>
    implements _$$BreakStatusDtoImplCopyWith<$Res> {
  __$$BreakStatusDtoImplCopyWithImpl(
    _$BreakStatusDtoImpl _value,
    $Res Function(_$BreakStatusDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BreakStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOnBreak = null,
    Object? accumulatedMinutes = null,
    Object? canStartBreak = null,
    Object? isLimitReached = null,
    Object? hasActiveTasks = null,
  }) {
    return _then(
      _$BreakStatusDtoImpl(
        isOnBreak: null == isOnBreak
            ? _value.isOnBreak
            : isOnBreak // ignore: cast_nullable_to_non_nullable
                  as bool,
        accumulatedMinutes: null == accumulatedMinutes
            ? _value.accumulatedMinutes
            : accumulatedMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        canStartBreak: null == canStartBreak
            ? _value.canStartBreak
            : canStartBreak // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLimitReached: null == isLimitReached
            ? _value.isLimitReached
            : isLimitReached // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasActiveTasks: null == hasActiveTasks
            ? _value.hasActiveTasks
            : hasActiveTasks // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakStatusDtoImpl implements _BreakStatusDto {
  const _$BreakStatusDtoImpl({
    this.isOnBreak = false,
    this.accumulatedMinutes = 0,
    this.canStartBreak = false,
    this.isLimitReached = false,
    this.hasActiveTasks = false,
  });

  factory _$BreakStatusDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakStatusDtoImplFromJson(json);

  @override
  @JsonKey()
  final bool isOnBreak;
  @override
  @JsonKey()
  final int accumulatedMinutes;
  @override
  @JsonKey()
  final bool canStartBreak;
  @override
  @JsonKey()
  final bool isLimitReached;
  @override
  @JsonKey()
  final bool hasActiveTasks;

  @override
  String toString() {
    return 'BreakStatusDto(isOnBreak: $isOnBreak, accumulatedMinutes: $accumulatedMinutes, canStartBreak: $canStartBreak, isLimitReached: $isLimitReached, hasActiveTasks: $hasActiveTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakStatusDtoImpl &&
            (identical(other.isOnBreak, isOnBreak) ||
                other.isOnBreak == isOnBreak) &&
            (identical(other.accumulatedMinutes, accumulatedMinutes) ||
                other.accumulatedMinutes == accumulatedMinutes) &&
            (identical(other.canStartBreak, canStartBreak) ||
                other.canStartBreak == canStartBreak) &&
            (identical(other.isLimitReached, isLimitReached) ||
                other.isLimitReached == isLimitReached) &&
            (identical(other.hasActiveTasks, hasActiveTasks) ||
                other.hasActiveTasks == hasActiveTasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isOnBreak,
    accumulatedMinutes,
    canStartBreak,
    isLimitReached,
    hasActiveTasks,
  );

  /// Create a copy of BreakStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakStatusDtoImplCopyWith<_$BreakStatusDtoImpl> get copyWith =>
      __$$BreakStatusDtoImplCopyWithImpl<_$BreakStatusDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakStatusDtoImplToJson(this);
  }
}

abstract class _BreakStatusDto implements BreakStatusDto {
  const factory _BreakStatusDto({
    final bool isOnBreak,
    final int accumulatedMinutes,
    final bool canStartBreak,
    final bool isLimitReached,
    final bool hasActiveTasks,
  }) = _$BreakStatusDtoImpl;

  factory _BreakStatusDto.fromJson(Map<String, dynamic> json) =
      _$BreakStatusDtoImpl.fromJson;

  @override
  bool get isOnBreak;
  @override
  int get accumulatedMinutes;
  @override
  bool get canStartBreak;
  @override
  bool get isLimitReached;
  @override
  bool get hasActiveTasks;

  /// Create a copy of BreakStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BreakStatusDtoImplCopyWith<_$BreakStatusDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
