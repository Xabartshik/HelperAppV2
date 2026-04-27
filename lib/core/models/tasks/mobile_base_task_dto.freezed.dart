// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mobile_base_task_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MobileBaseTaskDto _$MobileBaseTaskDtoFromJson(Map<String, dynamic> json) {
  return _MobileBaseTaskDto.fromJson(json);
}

/// @nodoc
mixin _$MobileBaseTaskDto {
  int get taskId => throw _privateConstructorUsedError;
  int get branchId => throw _privateConstructorUsedError;
  String get taskType => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  int get assignmentStatus => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'priorityLevel')
  int get priority => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get taskDetails => throw _privateConstructorUsedError;

  /// Serializes this MobileBaseTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MobileBaseTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileBaseTaskDtoCopyWith<MobileBaseTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MobileBaseTaskDtoCopyWith<$Res> {
  factory $MobileBaseTaskDtoCopyWith(
    MobileBaseTaskDto value,
    $Res Function(MobileBaseTaskDto) then,
  ) = _$MobileBaseTaskDtoCopyWithImpl<$Res, MobileBaseTaskDto>;
  @useResult
  $Res call({
    int taskId,
    int branchId,
    String taskType,
    int status,
    int assignmentStatus,
    DateTime? deadline,
    String title,
    String? description,
    @JsonKey(name: 'priorityLevel') int priority,
    DateTime? createdAt,
    Map<String, dynamic> taskDetails,
  });
}

/// @nodoc
class _$MobileBaseTaskDtoCopyWithImpl<$Res, $Val extends MobileBaseTaskDto>
    implements $MobileBaseTaskDtoCopyWith<$Res> {
  _$MobileBaseTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MobileBaseTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? branchId = null,
    Object? taskType = null,
    Object? status = null,
    Object? assignmentStatus = null,
    Object? deadline = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? createdAt = freezed,
    Object? taskDetails = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as int,
            branchId: null == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as int,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as int,
            assignmentStatus: null == assignmentStatus
                ? _value.assignmentStatus
                : assignmentStatus // ignore: cast_nullable_to_non_nullable
                      as int,
            deadline: freezed == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            taskDetails: null == taskDetails
                ? _value.taskDetails
                : taskDetails // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MobileBaseTaskDtoImplCopyWith<$Res>
    implements $MobileBaseTaskDtoCopyWith<$Res> {
  factory _$$MobileBaseTaskDtoImplCopyWith(
    _$MobileBaseTaskDtoImpl value,
    $Res Function(_$MobileBaseTaskDtoImpl) then,
  ) = __$$MobileBaseTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int taskId,
    int branchId,
    String taskType,
    int status,
    int assignmentStatus,
    DateTime? deadline,
    String title,
    String? description,
    @JsonKey(name: 'priorityLevel') int priority,
    DateTime? createdAt,
    Map<String, dynamic> taskDetails,
  });
}

/// @nodoc
class __$$MobileBaseTaskDtoImplCopyWithImpl<$Res>
    extends _$MobileBaseTaskDtoCopyWithImpl<$Res, _$MobileBaseTaskDtoImpl>
    implements _$$MobileBaseTaskDtoImplCopyWith<$Res> {
  __$$MobileBaseTaskDtoImplCopyWithImpl(
    _$MobileBaseTaskDtoImpl _value,
    $Res Function(_$MobileBaseTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MobileBaseTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? branchId = null,
    Object? taskType = null,
    Object? status = null,
    Object? assignmentStatus = null,
    Object? deadline = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? createdAt = freezed,
    Object? taskDetails = null,
  }) {
    return _then(
      _$MobileBaseTaskDtoImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as int,
        branchId: null == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as int,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as int,
        assignmentStatus: null == assignmentStatus
            ? _value.assignmentStatus
            : assignmentStatus // ignore: cast_nullable_to_non_nullable
                  as int,
        deadline: freezed == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        taskDetails: null == taskDetails
            ? _value._taskDetails
            : taskDetails // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MobileBaseTaskDtoImpl implements _MobileBaseTaskDto {
  const _$MobileBaseTaskDtoImpl({
    this.taskId = 0,
    this.branchId = 0,
    this.taskType = '',
    this.status = 0,
    this.assignmentStatus = 0,
    this.deadline,
    this.title = 'Без названия',
    this.description,
    @JsonKey(name: 'priorityLevel') this.priority = 5,
    this.createdAt,
    final Map<String, dynamic> taskDetails = const <String, dynamic>{},
  }) : _taskDetails = taskDetails;

  factory _$MobileBaseTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MobileBaseTaskDtoImplFromJson(json);

  @override
  @JsonKey()
  final int taskId;
  @override
  @JsonKey()
  final int branchId;
  @override
  @JsonKey()
  final String taskType;
  @override
  @JsonKey()
  final int status;
  @override
  @JsonKey()
  final int assignmentStatus;
  @override
  final DateTime? deadline;
  @override
  @JsonKey()
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'priorityLevel')
  final int priority;
  @override
  final DateTime? createdAt;
  final Map<String, dynamic> _taskDetails;
  @override
  @JsonKey()
  Map<String, dynamic> get taskDetails {
    if (_taskDetails is EqualUnmodifiableMapView) return _taskDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_taskDetails);
  }

  @override
  String toString() {
    return 'MobileBaseTaskDto(taskId: $taskId, branchId: $branchId, taskType: $taskType, status: $status, assignmentStatus: $assignmentStatus, deadline: $deadline, title: $title, description: $description, priority: $priority, createdAt: $createdAt, taskDetails: $taskDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileBaseTaskDtoImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignmentStatus, assignmentStatus) ||
                other.assignmentStatus == assignmentStatus) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._taskDetails,
              _taskDetails,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    branchId,
    taskType,
    status,
    assignmentStatus,
    deadline,
    title,
    description,
    priority,
    createdAt,
    const DeepCollectionEquality().hash(_taskDetails),
  );

  /// Create a copy of MobileBaseTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MobileBaseTaskDtoImplCopyWith<_$MobileBaseTaskDtoImpl> get copyWith =>
      __$$MobileBaseTaskDtoImplCopyWithImpl<_$MobileBaseTaskDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MobileBaseTaskDtoImplToJson(this);
  }
}

abstract class _MobileBaseTaskDto implements MobileBaseTaskDto {
  const factory _MobileBaseTaskDto({
    final int taskId,
    final int branchId,
    final String taskType,
    final int status,
    final int assignmentStatus,
    final DateTime? deadline,
    final String title,
    final String? description,
    @JsonKey(name: 'priorityLevel') final int priority,
    final DateTime? createdAt,
    final Map<String, dynamic> taskDetails,
  }) = _$MobileBaseTaskDtoImpl;

  factory _MobileBaseTaskDto.fromJson(Map<String, dynamic> json) =
      _$MobileBaseTaskDtoImpl.fromJson;

  @override
  int get taskId;
  @override
  int get branchId;
  @override
  String get taskType;
  @override
  int get status;
  @override
  int get assignmentStatus;
  @override
  DateTime? get deadline;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'priorityLevel')
  int get priority;
  @override
  DateTime? get createdAt;
  @override
  Map<String, dynamic> get taskDetails;

  /// Create a copy of MobileBaseTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileBaseTaskDtoImplCopyWith<_$MobileBaseTaskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
