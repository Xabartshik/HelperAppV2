// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boss_panel_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BossPanelTaskCardDto _$BossPanelTaskCardDtoFromJson(Map<String, dynamic> json) {
  return _BossPanelTaskCardDto.fromJson(json);
}

/// @nodoc
mixin _$BossPanelTaskCardDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get taskType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expectedCompletionDate => throw _privateConstructorUsedError;
  int get overallProgressPercentage => throw _privateConstructorUsedError;
  List<TaskAssigneeProgressDto> get assignees =>
      throw _privateConstructorUsedError;

  /// Serializes this BossPanelTaskCardDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BossPanelTaskCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BossPanelTaskCardDtoCopyWith<BossPanelTaskCardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BossPanelTaskCardDtoCopyWith<$Res> {
  factory $BossPanelTaskCardDtoCopyWith(
    BossPanelTaskCardDto value,
    $Res Function(BossPanelTaskCardDto) then,
  ) = _$BossPanelTaskCardDtoCopyWithImpl<$Res, BossPanelTaskCardDto>;
  @useResult
  $Res call({
    int id,
    String title,
    String taskType,
    DateTime createdAt,
    DateTime? expectedCompletionDate,
    int overallProgressPercentage,
    List<TaskAssigneeProgressDto> assignees,
  });
}

/// @nodoc
class _$BossPanelTaskCardDtoCopyWithImpl<
  $Res,
  $Val extends BossPanelTaskCardDto
>
    implements $BossPanelTaskCardDtoCopyWith<$Res> {
  _$BossPanelTaskCardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BossPanelTaskCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? taskType = null,
    Object? createdAt = null,
    Object? expectedCompletionDate = freezed,
    Object? overallProgressPercentage = null,
    Object? assignees = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expectedCompletionDate: freezed == expectedCompletionDate
                ? _value.expectedCompletionDate
                : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            overallProgressPercentage: null == overallProgressPercentage
                ? _value.overallProgressPercentage
                : overallProgressPercentage // ignore: cast_nullable_to_non_nullable
                      as int,
            assignees: null == assignees
                ? _value.assignees
                : assignees // ignore: cast_nullable_to_non_nullable
                      as List<TaskAssigneeProgressDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BossPanelTaskCardDtoImplCopyWith<$Res>
    implements $BossPanelTaskCardDtoCopyWith<$Res> {
  factory _$$BossPanelTaskCardDtoImplCopyWith(
    _$BossPanelTaskCardDtoImpl value,
    $Res Function(_$BossPanelTaskCardDtoImpl) then,
  ) = __$$BossPanelTaskCardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String title,
    String taskType,
    DateTime createdAt,
    DateTime? expectedCompletionDate,
    int overallProgressPercentage,
    List<TaskAssigneeProgressDto> assignees,
  });
}

/// @nodoc
class __$$BossPanelTaskCardDtoImplCopyWithImpl<$Res>
    extends _$BossPanelTaskCardDtoCopyWithImpl<$Res, _$BossPanelTaskCardDtoImpl>
    implements _$$BossPanelTaskCardDtoImplCopyWith<$Res> {
  __$$BossPanelTaskCardDtoImplCopyWithImpl(
    _$BossPanelTaskCardDtoImpl _value,
    $Res Function(_$BossPanelTaskCardDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BossPanelTaskCardDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? taskType = null,
    Object? createdAt = null,
    Object? expectedCompletionDate = freezed,
    Object? overallProgressPercentage = null,
    Object? assignees = null,
  }) {
    return _then(
      _$BossPanelTaskCardDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expectedCompletionDate: freezed == expectedCompletionDate
            ? _value.expectedCompletionDate
            : expectedCompletionDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        overallProgressPercentage: null == overallProgressPercentage
            ? _value.overallProgressPercentage
            : overallProgressPercentage // ignore: cast_nullable_to_non_nullable
                  as int,
        assignees: null == assignees
            ? _value._assignees
            : assignees // ignore: cast_nullable_to_non_nullable
                  as List<TaskAssigneeProgressDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BossPanelTaskCardDtoImpl extends _BossPanelTaskCardDto {
  const _$BossPanelTaskCardDtoImpl({
    required this.id,
    this.title = '',
    this.taskType = '',
    required this.createdAt,
    this.expectedCompletionDate,
    this.overallProgressPercentage = 0,
    final List<TaskAssigneeProgressDto> assignees = const [],
  }) : _assignees = assignees,
       super._();

  factory _$BossPanelTaskCardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BossPanelTaskCardDtoImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String taskType;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expectedCompletionDate;
  @override
  @JsonKey()
  final int overallProgressPercentage;
  final List<TaskAssigneeProgressDto> _assignees;
  @override
  @JsonKey()
  List<TaskAssigneeProgressDto> get assignees {
    if (_assignees is EqualUnmodifiableListView) return _assignees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignees);
  }

  @override
  String toString() {
    return 'BossPanelTaskCardDto(id: $id, title: $title, taskType: $taskType, createdAt: $createdAt, expectedCompletionDate: $expectedCompletionDate, overallProgressPercentage: $overallProgressPercentage, assignees: $assignees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BossPanelTaskCardDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expectedCompletionDate, expectedCompletionDate) ||
                other.expectedCompletionDate == expectedCompletionDate) &&
            (identical(
                  other.overallProgressPercentage,
                  overallProgressPercentage,
                ) ||
                other.overallProgressPercentage == overallProgressPercentage) &&
            const DeepCollectionEquality().equals(
              other._assignees,
              _assignees,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    taskType,
    createdAt,
    expectedCompletionDate,
    overallProgressPercentage,
    const DeepCollectionEquality().hash(_assignees),
  );

  /// Create a copy of BossPanelTaskCardDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BossPanelTaskCardDtoImplCopyWith<_$BossPanelTaskCardDtoImpl>
  get copyWith =>
      __$$BossPanelTaskCardDtoImplCopyWithImpl<_$BossPanelTaskCardDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BossPanelTaskCardDtoImplToJson(this);
  }
}

abstract class _BossPanelTaskCardDto extends BossPanelTaskCardDto {
  const factory _BossPanelTaskCardDto({
    required final int id,
    final String title,
    final String taskType,
    required final DateTime createdAt,
    final DateTime? expectedCompletionDate,
    final int overallProgressPercentage,
    final List<TaskAssigneeProgressDto> assignees,
  }) = _$BossPanelTaskCardDtoImpl;
  const _BossPanelTaskCardDto._() : super._();

  factory _BossPanelTaskCardDto.fromJson(Map<String, dynamic> json) =
      _$BossPanelTaskCardDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get taskType;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expectedCompletionDate;
  @override
  int get overallProgressPercentage;
  @override
  List<TaskAssigneeProgressDto> get assignees;

  /// Create a copy of BossPanelTaskCardDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BossPanelTaskCardDtoImplCopyWith<_$BossPanelTaskCardDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TaskAssigneeProgressDto _$TaskAssigneeProgressDtoFromJson(
  Map<String, dynamic> json,
) {
  return _TaskAssigneeProgressDto.fromJson(json);
}

/// @nodoc
mixin _$TaskAssigneeProgressDto {
  int get employeeId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  int get assignedVolume => throw _privateConstructorUsedError;
  int get completedVolume => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this TaskAssigneeProgressDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskAssigneeProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskAssigneeProgressDtoCopyWith<TaskAssigneeProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskAssigneeProgressDtoCopyWith<$Res> {
  factory $TaskAssigneeProgressDtoCopyWith(
    TaskAssigneeProgressDto value,
    $Res Function(TaskAssigneeProgressDto) then,
  ) = _$TaskAssigneeProgressDtoCopyWithImpl<$Res, TaskAssigneeProgressDto>;
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    int assignedVolume,
    int completedVolume,
    String status,
  });
}

/// @nodoc
class _$TaskAssigneeProgressDtoCopyWithImpl<
  $Res,
  $Val extends TaskAssigneeProgressDto
>
    implements $TaskAssigneeProgressDtoCopyWith<$Res> {
  _$TaskAssigneeProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskAssigneeProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? assignedVolume = null,
    Object? completedVolume = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedVolume: null == assignedVolume
                ? _value.assignedVolume
                : assignedVolume // ignore: cast_nullable_to_non_nullable
                      as int,
            completedVolume: null == completedVolume
                ? _value.completedVolume
                : completedVolume // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$TaskAssigneeProgressDtoImplCopyWith<$Res>
    implements $TaskAssigneeProgressDtoCopyWith<$Res> {
  factory _$$TaskAssigneeProgressDtoImplCopyWith(
    _$TaskAssigneeProgressDtoImpl value,
    $Res Function(_$TaskAssigneeProgressDtoImpl) then,
  ) = __$$TaskAssigneeProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    int assignedVolume,
    int completedVolume,
    String status,
  });
}

/// @nodoc
class __$$TaskAssigneeProgressDtoImplCopyWithImpl<$Res>
    extends
        _$TaskAssigneeProgressDtoCopyWithImpl<
          $Res,
          _$TaskAssigneeProgressDtoImpl
        >
    implements _$$TaskAssigneeProgressDtoImplCopyWith<$Res> {
  __$$TaskAssigneeProgressDtoImplCopyWithImpl(
    _$TaskAssigneeProgressDtoImpl _value,
    $Res Function(_$TaskAssigneeProgressDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskAssigneeProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? assignedVolume = null,
    Object? completedVolume = null,
    Object? status = null,
  }) {
    return _then(
      _$TaskAssigneeProgressDtoImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedVolume: null == assignedVolume
            ? _value.assignedVolume
            : assignedVolume // ignore: cast_nullable_to_non_nullable
                  as int,
        completedVolume: null == completedVolume
            ? _value.completedVolume
            : completedVolume // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$TaskAssigneeProgressDtoImpl implements _TaskAssigneeProgressDto {
  const _$TaskAssigneeProgressDtoImpl({
    required this.employeeId,
    this.fullName = '',
    this.assignedVolume = 0,
    this.completedVolume = 0,
    this.status = '',
  });

  factory _$TaskAssigneeProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskAssigneeProgressDtoImplFromJson(json);

  @override
  final int employeeId;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final int assignedVolume;
  @override
  @JsonKey()
  final int completedVolume;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'TaskAssigneeProgressDto(employeeId: $employeeId, fullName: $fullName, assignedVolume: $assignedVolume, completedVolume: $completedVolume, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskAssigneeProgressDtoImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.assignedVolume, assignedVolume) ||
                other.assignedVolume == assignedVolume) &&
            (identical(other.completedVolume, completedVolume) ||
                other.completedVolume == completedVolume) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    fullName,
    assignedVolume,
    completedVolume,
    status,
  );

  /// Create a copy of TaskAssigneeProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskAssigneeProgressDtoImplCopyWith<_$TaskAssigneeProgressDtoImpl>
  get copyWith =>
      __$$TaskAssigneeProgressDtoImplCopyWithImpl<
        _$TaskAssigneeProgressDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskAssigneeProgressDtoImplToJson(this);
  }
}

abstract class _TaskAssigneeProgressDto implements TaskAssigneeProgressDto {
  const factory _TaskAssigneeProgressDto({
    required final int employeeId,
    final String fullName,
    final int assignedVolume,
    final int completedVolume,
    final String status,
  }) = _$TaskAssigneeProgressDtoImpl;

  factory _TaskAssigneeProgressDto.fromJson(Map<String, dynamic> json) =
      _$TaskAssigneeProgressDtoImpl.fromJson;

  @override
  int get employeeId;
  @override
  String get fullName;
  @override
  int get assignedVolume;
  @override
  int get completedVolume;
  @override
  String get status;

  /// Create a copy of TaskAssigneeProgressDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskAssigneeProgressDtoImplCopyWith<_$TaskAssigneeProgressDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

EmployeeWorkloadDto _$EmployeeWorkloadDtoFromJson(Map<String, dynamic> json) {
  return _EmployeeWorkloadDto.fromJson(json);
}

/// @nodoc
mixin _$EmployeeWorkloadDto {
  int get employeeId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  bool get isAtWork => throw _privateConstructorUsedError;
  int get activeTasksCount => throw _privateConstructorUsedError;
  List<ActiveTaskBriefDto> get activeTasks =>
      throw _privateConstructorUsedError;

  /// Serializes this EmployeeWorkloadDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeWorkloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeWorkloadDtoCopyWith<EmployeeWorkloadDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeWorkloadDtoCopyWith<$Res> {
  factory $EmployeeWorkloadDtoCopyWith(
    EmployeeWorkloadDto value,
    $Res Function(EmployeeWorkloadDto) then,
  ) = _$EmployeeWorkloadDtoCopyWithImpl<$Res, EmployeeWorkloadDto>;
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    bool isAtWork,
    int activeTasksCount,
    List<ActiveTaskBriefDto> activeTasks,
  });
}

/// @nodoc
class _$EmployeeWorkloadDtoCopyWithImpl<$Res, $Val extends EmployeeWorkloadDto>
    implements $EmployeeWorkloadDtoCopyWith<$Res> {
  _$EmployeeWorkloadDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeWorkloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? isAtWork = null,
    Object? activeTasksCount = null,
    Object? activeTasks = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            isAtWork: null == isAtWork
                ? _value.isAtWork
                : isAtWork // ignore: cast_nullable_to_non_nullable
                      as bool,
            activeTasksCount: null == activeTasksCount
                ? _value.activeTasksCount
                : activeTasksCount // ignore: cast_nullable_to_non_nullable
                      as int,
            activeTasks: null == activeTasks
                ? _value.activeTasks
                : activeTasks // ignore: cast_nullable_to_non_nullable
                      as List<ActiveTaskBriefDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeWorkloadDtoImplCopyWith<$Res>
    implements $EmployeeWorkloadDtoCopyWith<$Res> {
  factory _$$EmployeeWorkloadDtoImplCopyWith(
    _$EmployeeWorkloadDtoImpl value,
    $Res Function(_$EmployeeWorkloadDtoImpl) then,
  ) = __$$EmployeeWorkloadDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    bool isAtWork,
    int activeTasksCount,
    List<ActiveTaskBriefDto> activeTasks,
  });
}

/// @nodoc
class __$$EmployeeWorkloadDtoImplCopyWithImpl<$Res>
    extends _$EmployeeWorkloadDtoCopyWithImpl<$Res, _$EmployeeWorkloadDtoImpl>
    implements _$$EmployeeWorkloadDtoImplCopyWith<$Res> {
  __$$EmployeeWorkloadDtoImplCopyWithImpl(
    _$EmployeeWorkloadDtoImpl _value,
    $Res Function(_$EmployeeWorkloadDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeWorkloadDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? isAtWork = null,
    Object? activeTasksCount = null,
    Object? activeTasks = null,
  }) {
    return _then(
      _$EmployeeWorkloadDtoImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        isAtWork: null == isAtWork
            ? _value.isAtWork
            : isAtWork // ignore: cast_nullable_to_non_nullable
                  as bool,
        activeTasksCount: null == activeTasksCount
            ? _value.activeTasksCount
            : activeTasksCount // ignore: cast_nullable_to_non_nullable
                  as int,
        activeTasks: null == activeTasks
            ? _value._activeTasks
            : activeTasks // ignore: cast_nullable_to_non_nullable
                  as List<ActiveTaskBriefDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeWorkloadDtoImpl extends _EmployeeWorkloadDto {
  const _$EmployeeWorkloadDtoImpl({
    required this.employeeId,
    this.fullName = '',
    this.isAtWork = false,
    this.activeTasksCount = 0,
    final List<ActiveTaskBriefDto> activeTasks = const [],
  }) : _activeTasks = activeTasks,
       super._();

  factory _$EmployeeWorkloadDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeWorkloadDtoImplFromJson(json);

  @override
  final int employeeId;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final bool isAtWork;
  @override
  @JsonKey()
  final int activeTasksCount;
  final List<ActiveTaskBriefDto> _activeTasks;
  @override
  @JsonKey()
  List<ActiveTaskBriefDto> get activeTasks {
    if (_activeTasks is EqualUnmodifiableListView) return _activeTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeTasks);
  }

  @override
  String toString() {
    return 'EmployeeWorkloadDto(employeeId: $employeeId, fullName: $fullName, isAtWork: $isAtWork, activeTasksCount: $activeTasksCount, activeTasks: $activeTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeWorkloadDtoImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.isAtWork, isAtWork) ||
                other.isAtWork == isAtWork) &&
            (identical(other.activeTasksCount, activeTasksCount) ||
                other.activeTasksCount == activeTasksCount) &&
            const DeepCollectionEquality().equals(
              other._activeTasks,
              _activeTasks,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    fullName,
    isAtWork,
    activeTasksCount,
    const DeepCollectionEquality().hash(_activeTasks),
  );

  /// Create a copy of EmployeeWorkloadDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeWorkloadDtoImplCopyWith<_$EmployeeWorkloadDtoImpl> get copyWith =>
      __$$EmployeeWorkloadDtoImplCopyWithImpl<_$EmployeeWorkloadDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeWorkloadDtoImplToJson(this);
  }
}

abstract class _EmployeeWorkloadDto extends EmployeeWorkloadDto {
  const factory _EmployeeWorkloadDto({
    required final int employeeId,
    final String fullName,
    final bool isAtWork,
    final int activeTasksCount,
    final List<ActiveTaskBriefDto> activeTasks,
  }) = _$EmployeeWorkloadDtoImpl;
  const _EmployeeWorkloadDto._() : super._();

  factory _EmployeeWorkloadDto.fromJson(Map<String, dynamic> json) =
      _$EmployeeWorkloadDtoImpl.fromJson;

  @override
  int get employeeId;
  @override
  String get fullName;
  @override
  bool get isAtWork;
  @override
  int get activeTasksCount;
  @override
  List<ActiveTaskBriefDto> get activeTasks;

  /// Create a copy of EmployeeWorkloadDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeWorkloadDtoImplCopyWith<_$EmployeeWorkloadDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActiveTaskBriefDto _$ActiveTaskBriefDtoFromJson(Map<String, dynamic> json) {
  return _ActiveTaskBriefDto.fromJson(json);
}

/// @nodoc
mixin _$ActiveTaskBriefDto {
  int get taskId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get taskType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this ActiveTaskBriefDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActiveTaskBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActiveTaskBriefDtoCopyWith<ActiveTaskBriefDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActiveTaskBriefDtoCopyWith<$Res> {
  factory $ActiveTaskBriefDtoCopyWith(
    ActiveTaskBriefDto value,
    $Res Function(ActiveTaskBriefDto) then,
  ) = _$ActiveTaskBriefDtoCopyWithImpl<$Res, ActiveTaskBriefDto>;
  @useResult
  $Res call({int taskId, String title, String taskType, String status});
}

/// @nodoc
class _$ActiveTaskBriefDtoCopyWithImpl<$Res, $Val extends ActiveTaskBriefDto>
    implements $ActiveTaskBriefDtoCopyWith<$Res> {
  _$ActiveTaskBriefDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActiveTaskBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? title = null,
    Object? taskType = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as int,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            taskType: null == taskType
                ? _value.taskType
                : taskType // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ActiveTaskBriefDtoImplCopyWith<$Res>
    implements $ActiveTaskBriefDtoCopyWith<$Res> {
  factory _$$ActiveTaskBriefDtoImplCopyWith(
    _$ActiveTaskBriefDtoImpl value,
    $Res Function(_$ActiveTaskBriefDtoImpl) then,
  ) = __$$ActiveTaskBriefDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int taskId, String title, String taskType, String status});
}

/// @nodoc
class __$$ActiveTaskBriefDtoImplCopyWithImpl<$Res>
    extends _$ActiveTaskBriefDtoCopyWithImpl<$Res, _$ActiveTaskBriefDtoImpl>
    implements _$$ActiveTaskBriefDtoImplCopyWith<$Res> {
  __$$ActiveTaskBriefDtoImplCopyWithImpl(
    _$ActiveTaskBriefDtoImpl _value,
    $Res Function(_$ActiveTaskBriefDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActiveTaskBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskId = null,
    Object? title = null,
    Object? taskType = null,
    Object? status = null,
  }) {
    return _then(
      _$ActiveTaskBriefDtoImpl(
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as int,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        taskType: null == taskType
            ? _value.taskType
            : taskType // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ActiveTaskBriefDtoImpl implements _ActiveTaskBriefDto {
  const _$ActiveTaskBriefDtoImpl({
    required this.taskId,
    this.title = '',
    this.taskType = '',
    this.status = '',
  });

  factory _$ActiveTaskBriefDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActiveTaskBriefDtoImplFromJson(json);

  @override
  final int taskId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String taskType;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'ActiveTaskBriefDto(taskId: $taskId, title: $title, taskType: $taskType, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActiveTaskBriefDtoImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, taskId, title, taskType, status);

  /// Create a copy of ActiveTaskBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActiveTaskBriefDtoImplCopyWith<_$ActiveTaskBriefDtoImpl> get copyWith =>
      __$$ActiveTaskBriefDtoImplCopyWithImpl<_$ActiveTaskBriefDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActiveTaskBriefDtoImplToJson(this);
  }
}

abstract class _ActiveTaskBriefDto implements ActiveTaskBriefDto {
  const factory _ActiveTaskBriefDto({
    required final int taskId,
    final String title,
    final String taskType,
    final String status,
  }) = _$ActiveTaskBriefDtoImpl;

  factory _ActiveTaskBriefDto.fromJson(Map<String, dynamic> json) =
      _$ActiveTaskBriefDtoImpl.fromJson;

  @override
  int get taskId;
  @override
  String get title;
  @override
  String get taskType;
  @override
  String get status;

  /// Create a copy of ActiveTaskBriefDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActiveTaskBriefDtoImplCopyWith<_$ActiveTaskBriefDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableEmployeeDto _$AvailableEmployeeDtoFromJson(Map<String, dynamic> json) {
  return _AvailableEmployeeDto.fromJson(json);
}

/// @nodoc
mixin _$AvailableEmployeeDto {
  int get employeeId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  bool get isAtWork => throw _privateConstructorUsedError;
  int get activeTasksCount => throw _privateConstructorUsedError;
  bool get isRecommended => throw _privateConstructorUsedError;

  /// Serializes this AvailableEmployeeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableEmployeeDtoCopyWith<AvailableEmployeeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableEmployeeDtoCopyWith<$Res> {
  factory $AvailableEmployeeDtoCopyWith(
    AvailableEmployeeDto value,
    $Res Function(AvailableEmployeeDto) then,
  ) = _$AvailableEmployeeDtoCopyWithImpl<$Res, AvailableEmployeeDto>;
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    bool isAtWork,
    int activeTasksCount,
    bool isRecommended,
  });
}

/// @nodoc
class _$AvailableEmployeeDtoCopyWithImpl<
  $Res,
  $Val extends AvailableEmployeeDto
>
    implements $AvailableEmployeeDtoCopyWith<$Res> {
  _$AvailableEmployeeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? isAtWork = null,
    Object? activeTasksCount = null,
    Object? isRecommended = null,
  }) {
    return _then(
      _value.copyWith(
            employeeId: null == employeeId
                ? _value.employeeId
                : employeeId // ignore: cast_nullable_to_non_nullable
                      as int,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            isAtWork: null == isAtWork
                ? _value.isAtWork
                : isAtWork // ignore: cast_nullable_to_non_nullable
                      as bool,
            activeTasksCount: null == activeTasksCount
                ? _value.activeTasksCount
                : activeTasksCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isRecommended: null == isRecommended
                ? _value.isRecommended
                : isRecommended // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableEmployeeDtoImplCopyWith<$Res>
    implements $AvailableEmployeeDtoCopyWith<$Res> {
  factory _$$AvailableEmployeeDtoImplCopyWith(
    _$AvailableEmployeeDtoImpl value,
    $Res Function(_$AvailableEmployeeDtoImpl) then,
  ) = __$$AvailableEmployeeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int employeeId,
    String fullName,
    bool isAtWork,
    int activeTasksCount,
    bool isRecommended,
  });
}

/// @nodoc
class __$$AvailableEmployeeDtoImplCopyWithImpl<$Res>
    extends _$AvailableEmployeeDtoCopyWithImpl<$Res, _$AvailableEmployeeDtoImpl>
    implements _$$AvailableEmployeeDtoImplCopyWith<$Res> {
  __$$AvailableEmployeeDtoImplCopyWithImpl(
    _$AvailableEmployeeDtoImpl _value,
    $Res Function(_$AvailableEmployeeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeId = null,
    Object? fullName = null,
    Object? isAtWork = null,
    Object? activeTasksCount = null,
    Object? isRecommended = null,
  }) {
    return _then(
      _$AvailableEmployeeDtoImpl(
        employeeId: null == employeeId
            ? _value.employeeId
            : employeeId // ignore: cast_nullable_to_non_nullable
                  as int,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        isAtWork: null == isAtWork
            ? _value.isAtWork
            : isAtWork // ignore: cast_nullable_to_non_nullable
                  as bool,
        activeTasksCount: null == activeTasksCount
            ? _value.activeTasksCount
            : activeTasksCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isRecommended: null == isRecommended
            ? _value.isRecommended
            : isRecommended // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableEmployeeDtoImpl implements _AvailableEmployeeDto {
  const _$AvailableEmployeeDtoImpl({
    required this.employeeId,
    this.fullName = '',
    this.isAtWork = false,
    this.activeTasksCount = 0,
    this.isRecommended = false,
  });

  factory _$AvailableEmployeeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableEmployeeDtoImplFromJson(json);

  @override
  final int employeeId;
  @override
  @JsonKey()
  final String fullName;
  @override
  @JsonKey()
  final bool isAtWork;
  @override
  @JsonKey()
  final int activeTasksCount;
  @override
  @JsonKey()
  final bool isRecommended;

  @override
  String toString() {
    return 'AvailableEmployeeDto(employeeId: $employeeId, fullName: $fullName, isAtWork: $isAtWork, activeTasksCount: $activeTasksCount, isRecommended: $isRecommended)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableEmployeeDtoImpl &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.isAtWork, isAtWork) ||
                other.isAtWork == isAtWork) &&
            (identical(other.activeTasksCount, activeTasksCount) ||
                other.activeTasksCount == activeTasksCount) &&
            (identical(other.isRecommended, isRecommended) ||
                other.isRecommended == isRecommended));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    employeeId,
    fullName,
    isAtWork,
    activeTasksCount,
    isRecommended,
  );

  /// Create a copy of AvailableEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableEmployeeDtoImplCopyWith<_$AvailableEmployeeDtoImpl>
  get copyWith =>
      __$$AvailableEmployeeDtoImplCopyWithImpl<_$AvailableEmployeeDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableEmployeeDtoImplToJson(this);
  }
}

abstract class _AvailableEmployeeDto implements AvailableEmployeeDto {
  const factory _AvailableEmployeeDto({
    required final int employeeId,
    final String fullName,
    final bool isAtWork,
    final int activeTasksCount,
    final bool isRecommended,
  }) = _$AvailableEmployeeDtoImpl;

  factory _AvailableEmployeeDto.fromJson(Map<String, dynamic> json) =
      _$AvailableEmployeeDtoImpl.fromJson;

  @override
  int get employeeId;
  @override
  String get fullName;
  @override
  bool get isAtWork;
  @override
  int get activeTasksCount;
  @override
  bool get isRecommended;

  /// Create a copy of AvailableEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableEmployeeDtoImplCopyWith<_$AvailableEmployeeDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateInventoryByZoneDto _$CreateInventoryByZoneDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CreateInventoryByZoneDto.fromJson(json);
}

/// @nodoc
mixin _$CreateInventoryByZoneDto {
  List<String> get zonePrefixes => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  int get workerCount => throw _privateConstructorUsedError;
  List<int>? get workerIds => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime? get deadlineDate => throw _privateConstructorUsedError;

  /// Serializes this CreateInventoryByZoneDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateInventoryByZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateInventoryByZoneDtoCopyWith<CreateInventoryByZoneDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateInventoryByZoneDtoCopyWith<$Res> {
  factory $CreateInventoryByZoneDtoCopyWith(
    CreateInventoryByZoneDto value,
    $Res Function(CreateInventoryByZoneDto) then,
  ) = _$CreateInventoryByZoneDtoCopyWithImpl<$Res, CreateInventoryByZoneDto>;
  @useResult
  $Res call({
    List<String> zonePrefixes,
    int priority,
    int workerCount,
    List<int>? workerIds,
    String? description,
    DateTime? deadlineDate,
  });
}

/// @nodoc
class _$CreateInventoryByZoneDtoCopyWithImpl<
  $Res,
  $Val extends CreateInventoryByZoneDto
>
    implements $CreateInventoryByZoneDtoCopyWith<$Res> {
  _$CreateInventoryByZoneDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateInventoryByZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zonePrefixes = null,
    Object? priority = null,
    Object? workerCount = null,
    Object? workerIds = freezed,
    Object? description = freezed,
    Object? deadlineDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            zonePrefixes: null == zonePrefixes
                ? _value.zonePrefixes
                : zonePrefixes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            workerCount: null == workerCount
                ? _value.workerCount
                : workerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            workerIds: freezed == workerIds
                ? _value.workerIds
                : workerIds // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            deadlineDate: freezed == deadlineDate
                ? _value.deadlineDate
                : deadlineDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateInventoryByZoneDtoImplCopyWith<$Res>
    implements $CreateInventoryByZoneDtoCopyWith<$Res> {
  factory _$$CreateInventoryByZoneDtoImplCopyWith(
    _$CreateInventoryByZoneDtoImpl value,
    $Res Function(_$CreateInventoryByZoneDtoImpl) then,
  ) = __$$CreateInventoryByZoneDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> zonePrefixes,
    int priority,
    int workerCount,
    List<int>? workerIds,
    String? description,
    DateTime? deadlineDate,
  });
}

/// @nodoc
class __$$CreateInventoryByZoneDtoImplCopyWithImpl<$Res>
    extends
        _$CreateInventoryByZoneDtoCopyWithImpl<
          $Res,
          _$CreateInventoryByZoneDtoImpl
        >
    implements _$$CreateInventoryByZoneDtoImplCopyWith<$Res> {
  __$$CreateInventoryByZoneDtoImplCopyWithImpl(
    _$CreateInventoryByZoneDtoImpl _value,
    $Res Function(_$CreateInventoryByZoneDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateInventoryByZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zonePrefixes = null,
    Object? priority = null,
    Object? workerCount = null,
    Object? workerIds = freezed,
    Object? description = freezed,
    Object? deadlineDate = freezed,
  }) {
    return _then(
      _$CreateInventoryByZoneDtoImpl(
        zonePrefixes: null == zonePrefixes
            ? _value._zonePrefixes
            : zonePrefixes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        workerCount: null == workerCount
            ? _value.workerCount
            : workerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        workerIds: freezed == workerIds
            ? _value._workerIds
            : workerIds // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        deadlineDate: freezed == deadlineDate
            ? _value.deadlineDate
            : deadlineDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateInventoryByZoneDtoImpl implements _CreateInventoryByZoneDto {
  const _$CreateInventoryByZoneDtoImpl({
    final List<String> zonePrefixes = const [],
    this.priority = 3,
    this.workerCount = 1,
    final List<int>? workerIds,
    this.description,
    this.deadlineDate,
  }) : _zonePrefixes = zonePrefixes,
       _workerIds = workerIds;

  factory _$CreateInventoryByZoneDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateInventoryByZoneDtoImplFromJson(json);

  final List<String> _zonePrefixes;
  @override
  @JsonKey()
  List<String> get zonePrefixes {
    if (_zonePrefixes is EqualUnmodifiableListView) return _zonePrefixes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_zonePrefixes);
  }

  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final int workerCount;
  final List<int>? _workerIds;
  @override
  List<int>? get workerIds {
    final value = _workerIds;
    if (value == null) return null;
    if (_workerIds is EqualUnmodifiableListView) return _workerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;
  @override
  final DateTime? deadlineDate;

  @override
  String toString() {
    return 'CreateInventoryByZoneDto(zonePrefixes: $zonePrefixes, priority: $priority, workerCount: $workerCount, workerIds: $workerIds, description: $description, deadlineDate: $deadlineDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateInventoryByZoneDtoImpl &&
            const DeepCollectionEquality().equals(
              other._zonePrefixes,
              _zonePrefixes,
            ) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.workerCount, workerCount) ||
                other.workerCount == workerCount) &&
            const DeepCollectionEquality().equals(
              other._workerIds,
              _workerIds,
            ) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deadlineDate, deadlineDate) ||
                other.deadlineDate == deadlineDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_zonePrefixes),
    priority,
    workerCount,
    const DeepCollectionEquality().hash(_workerIds),
    description,
    deadlineDate,
  );

  /// Create a copy of CreateInventoryByZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateInventoryByZoneDtoImplCopyWith<_$CreateInventoryByZoneDtoImpl>
  get copyWith =>
      __$$CreateInventoryByZoneDtoImplCopyWithImpl<
        _$CreateInventoryByZoneDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateInventoryByZoneDtoImplToJson(this);
  }
}

abstract class _CreateInventoryByZoneDto implements CreateInventoryByZoneDto {
  const factory _CreateInventoryByZoneDto({
    final List<String> zonePrefixes,
    final int priority,
    final int workerCount,
    final List<int>? workerIds,
    final String? description,
    final DateTime? deadlineDate,
  }) = _$CreateInventoryByZoneDtoImpl;

  factory _CreateInventoryByZoneDto.fromJson(Map<String, dynamic> json) =
      _$CreateInventoryByZoneDtoImpl.fromJson;

  @override
  List<String> get zonePrefixes;
  @override
  int get priority;
  @override
  int get workerCount;
  @override
  List<int>? get workerIds;
  @override
  String? get description;
  @override
  DateTime? get deadlineDate;

  /// Create a copy of CreateInventoryByZoneDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateInventoryByZoneDtoImplCopyWith<_$CreateInventoryByZoneDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionCellDtoImpl implements _PositionCellDto {
  const _$PositionCellDtoImpl({
    required this.positionId,
    required this.branchId,
    this.status = "Active",
    this.zoneCode = '',
    this.firstLevelStorageType = '',
    this.flsNumber = '',
    this.secondLevelStorage,
    this.thirdLevelStorage,
  });

  factory _$PositionCellDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionCellDtoImplFromJson(json);

  @override
  final int positionId;
  @override
  final int branchId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String zoneCode;
  @override
  @JsonKey()
  final String firstLevelStorageType;
  @override
  @JsonKey()
  final String flsNumber;
  @override
  final String? secondLevelStorage;
  @override
  final String? thirdLevelStorage;

  @override
  String toString() {
    return 'PositionCellDto(positionId: $positionId, branchId: $branchId, status: $status, zoneCode: $zoneCode, firstLevelStorageType: $firstLevelStorageType, flsNumber: $flsNumber, secondLevelStorage: $secondLevelStorage, thirdLevelStorage: $thirdLevelStorage)';
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
                other.thirdLevelStorage == thirdLevelStorage));
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

abstract class _PositionCellDto implements PositionCellDto {
  const factory _PositionCellDto({
    required final int positionId,
    required final int branchId,
    final String status,
    final String zoneCode,
    final String firstLevelStorageType,
    final String flsNumber,
    final String? secondLevelStorage,
    final String? thirdLevelStorage,
  }) = _$PositionCellDtoImpl;

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

  /// Create a copy of PositionCellDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionCellDtoImplCopyWith<_$PositionCellDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
