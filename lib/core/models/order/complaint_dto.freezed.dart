// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complaint_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ComplaintDto _$ComplaintDtoFromJson(Map<String, dynamic> json) {
  return _ComplaintDto.fromJson(json);
}

/// @nodoc
mixin _$ComplaintDto {
  int get orderId => throw _privateConstructorUsedError;
  String get reason =>
      throw _privateConstructorUsedError; // Выбранная причина (например: "Брак", "Недовоз")
  String? get comment =>
      throw _privateConstructorUsedError; // Свободный комментарий пользователя
  Map<int, int> get problemItemIds =>
      throw _privateConstructorUsedError; // ID товаров, к которым относится жалоба
  List<String> get photoPaths => throw _privateConstructorUsedError;

  /// Serializes this ComplaintDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ComplaintDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ComplaintDtoCopyWith<ComplaintDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ComplaintDtoCopyWith<$Res> {
  factory $ComplaintDtoCopyWith(
    ComplaintDto value,
    $Res Function(ComplaintDto) then,
  ) = _$ComplaintDtoCopyWithImpl<$Res, ComplaintDto>;
  @useResult
  $Res call({
    int orderId,
    String reason,
    String? comment,
    Map<int, int> problemItemIds,
    List<String> photoPaths,
  });
}

/// @nodoc
class _$ComplaintDtoCopyWithImpl<$Res, $Val extends ComplaintDto>
    implements $ComplaintDtoCopyWith<$Res> {
  _$ComplaintDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ComplaintDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? reason = null,
    Object? comment = freezed,
    Object? problemItemIds = null,
    Object? photoPaths = null,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            problemItemIds: null == problemItemIds
                ? _value.problemItemIds
                : problemItemIds // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            photoPaths: null == photoPaths
                ? _value.photoPaths
                : photoPaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ComplaintDtoImplCopyWith<$Res>
    implements $ComplaintDtoCopyWith<$Res> {
  factory _$$ComplaintDtoImplCopyWith(
    _$ComplaintDtoImpl value,
    $Res Function(_$ComplaintDtoImpl) then,
  ) = __$$ComplaintDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int orderId,
    String reason,
    String? comment,
    Map<int, int> problemItemIds,
    List<String> photoPaths,
  });
}

/// @nodoc
class __$$ComplaintDtoImplCopyWithImpl<$Res>
    extends _$ComplaintDtoCopyWithImpl<$Res, _$ComplaintDtoImpl>
    implements _$$ComplaintDtoImplCopyWith<$Res> {
  __$$ComplaintDtoImplCopyWithImpl(
    _$ComplaintDtoImpl _value,
    $Res Function(_$ComplaintDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ComplaintDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? reason = null,
    Object? comment = freezed,
    Object? problemItemIds = null,
    Object? photoPaths = null,
  }) {
    return _then(
      _$ComplaintDtoImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        problemItemIds: null == problemItemIds
            ? _value._problemItemIds
            : problemItemIds // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        photoPaths: null == photoPaths
            ? _value._photoPaths
            : photoPaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ComplaintDtoImpl implements _ComplaintDto {
  const _$ComplaintDtoImpl({
    required this.orderId,
    required this.reason,
    this.comment,
    final Map<int, int> problemItemIds = const {},
    final List<String> photoPaths = const [],
  }) : _problemItemIds = problemItemIds,
       _photoPaths = photoPaths;

  factory _$ComplaintDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ComplaintDtoImplFromJson(json);

  @override
  final int orderId;
  @override
  final String reason;
  // Выбранная причина (например: "Брак", "Недовоз")
  @override
  final String? comment;
  // Свободный комментарий пользователя
  final Map<int, int> _problemItemIds;
  // Свободный комментарий пользователя
  @override
  @JsonKey()
  Map<int, int> get problemItemIds {
    if (_problemItemIds is EqualUnmodifiableMapView) return _problemItemIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_problemItemIds);
  }

  // ID товаров, к которым относится жалоба
  final List<String> _photoPaths;
  // ID товаров, к которым относится жалоба
  @override
  @JsonKey()
  List<String> get photoPaths {
    if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoPaths);
  }

  @override
  String toString() {
    return 'ComplaintDto(orderId: $orderId, reason: $reason, comment: $comment, problemItemIds: $problemItemIds, photoPaths: $photoPaths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ComplaintDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(
              other._problemItemIds,
              _problemItemIds,
            ) &&
            const DeepCollectionEquality().equals(
              other._photoPaths,
              _photoPaths,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    reason,
    comment,
    const DeepCollectionEquality().hash(_problemItemIds),
    const DeepCollectionEquality().hash(_photoPaths),
  );

  /// Create a copy of ComplaintDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ComplaintDtoImplCopyWith<_$ComplaintDtoImpl> get copyWith =>
      __$$ComplaintDtoImplCopyWithImpl<_$ComplaintDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ComplaintDtoImplToJson(this);
  }
}

abstract class _ComplaintDto implements ComplaintDto {
  const factory _ComplaintDto({
    required final int orderId,
    required final String reason,
    final String? comment,
    final Map<int, int> problemItemIds,
    final List<String> photoPaths,
  }) = _$ComplaintDtoImpl;

  factory _ComplaintDto.fromJson(Map<String, dynamic> json) =
      _$ComplaintDtoImpl.fromJson;

  @override
  int get orderId;
  @override
  String get reason; // Выбранная причина (например: "Брак", "Недовоз")
  @override
  String? get comment; // Свободный комментарий пользователя
  @override
  Map<int, int> get problemItemIds; // ID товаров, к которым относится жалоба
  @override
  List<String> get photoPaths;

  /// Create a copy of ComplaintDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ComplaintDtoImplCopyWith<_$ComplaintDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
