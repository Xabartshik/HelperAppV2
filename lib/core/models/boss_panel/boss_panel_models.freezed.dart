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
  double get totalComplexity => throw _privateConstructorUsedError;
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
    double totalComplexity,
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
    Object? totalComplexity = null,
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
            totalComplexity: null == totalComplexity
                ? _value.totalComplexity
                : totalComplexity // ignore: cast_nullable_to_non_nullable
                      as double,
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
    double totalComplexity,
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
    Object? totalComplexity = null,
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
        totalComplexity: null == totalComplexity
            ? _value.totalComplexity
            : totalComplexity // ignore: cast_nullable_to_non_nullable
                  as double,
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
    this.totalComplexity = 0.0,
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
  @override
  @JsonKey()
  final double totalComplexity;
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
    return 'EmployeeWorkloadDto(employeeId: $employeeId, fullName: $fullName, isAtWork: $isAtWork, activeTasksCount: $activeTasksCount, totalComplexity: $totalComplexity, activeTasks: $activeTasks)';
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
            (identical(other.totalComplexity, totalComplexity) ||
                other.totalComplexity == totalComplexity) &&
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
    totalComplexity,
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
    final double totalComplexity,
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
  double get totalComplexity;
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
  double? get maxWeightKg => throw _privateConstructorUsedError;
  String? get vehicleName => throw _privateConstructorUsedError;
  bool get isOnRoute => throw _privateConstructorUsedError;

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
    double? maxWeightKg,
    String? vehicleName,
    bool isOnRoute,
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
    Object? maxWeightKg = freezed,
    Object? vehicleName = freezed,
    Object? isOnRoute = null,
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
            maxWeightKg: freezed == maxWeightKg
                ? _value.maxWeightKg
                : maxWeightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            vehicleName: freezed == vehicleName
                ? _value.vehicleName
                : vehicleName // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOnRoute: null == isOnRoute
                ? _value.isOnRoute
                : isOnRoute // ignore: cast_nullable_to_non_nullable
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
    double? maxWeightKg,
    String? vehicleName,
    bool isOnRoute,
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
    Object? maxWeightKg = freezed,
    Object? vehicleName = freezed,
    Object? isOnRoute = null,
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
        maxWeightKg: freezed == maxWeightKg
            ? _value.maxWeightKg
            : maxWeightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        vehicleName: freezed == vehicleName
            ? _value.vehicleName
            : vehicleName // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOnRoute: null == isOnRoute
            ? _value.isOnRoute
            : isOnRoute // ignore: cast_nullable_to_non_nullable
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
    this.maxWeightKg,
    this.vehicleName,
    this.isOnRoute = false,
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
  final double? maxWeightKg;
  @override
  final String? vehicleName;
  @override
  @JsonKey()
  final bool isOnRoute;

  @override
  String toString() {
    return 'AvailableEmployeeDto(employeeId: $employeeId, fullName: $fullName, isAtWork: $isAtWork, activeTasksCount: $activeTasksCount, isRecommended: $isRecommended, maxWeightKg: $maxWeightKg, vehicleName: $vehicleName, isOnRoute: $isOnRoute)';
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
                other.isRecommended == isRecommended) &&
            (identical(other.maxWeightKg, maxWeightKg) ||
                other.maxWeightKg == maxWeightKg) &&
            (identical(other.vehicleName, vehicleName) ||
                other.vehicleName == vehicleName) &&
            (identical(other.isOnRoute, isOnRoute) ||
                other.isOnRoute == isOnRoute));
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
    maxWeightKg,
    vehicleName,
    isOnRoute,
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
    final double? maxWeightKg,
    final String? vehicleName,
    final bool isOnRoute,
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
  @override
  double? get maxWeightKg;
  @override
  String? get vehicleName;
  @override
  bool get isOnRoute;

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
  int get priorityLevel => throw _privateConstructorUsedError;
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
    int priorityLevel,
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
    Object? priorityLevel = null,
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
            priorityLevel: null == priorityLevel
                ? _value.priorityLevel
                : priorityLevel // ignore: cast_nullable_to_non_nullable
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
    int priorityLevel,
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
    Object? priorityLevel = null,
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
        priorityLevel: null == priorityLevel
            ? _value.priorityLevel
            : priorityLevel // ignore: cast_nullable_to_non_nullable
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
    this.priorityLevel = 3,
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
  final int priorityLevel;
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
    return 'CreateInventoryByZoneDto(zonePrefixes: $zonePrefixes, priorityLevel: $priorityLevel, workerCount: $workerCount, workerIds: $workerIds, description: $description, deadlineDate: $deadlineDate)';
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
            (identical(other.priorityLevel, priorityLevel) ||
                other.priorityLevel == priorityLevel) &&
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
    priorityLevel,
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
    final int priorityLevel,
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
  int get priorityLevel;
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

OrderItemDetailDto _$OrderItemDetailDtoFromJson(Map<String, dynamic> json) {
  return _OrderItemDetailDto.fromJson(json);
}

/// @nodoc
mixin _$OrderItemDetailDto {
  int get itemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get weightKg => throw _privateConstructorUsedError;

  /// Serializes this OrderItemDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemDetailDtoCopyWith<OrderItemDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemDetailDtoCopyWith<$Res> {
  factory $OrderItemDetailDtoCopyWith(
    OrderItemDetailDto value,
    $Res Function(OrderItemDetailDto) then,
  ) = _$OrderItemDetailDtoCopyWithImpl<$Res, OrderItemDetailDto>;
  @useResult
  $Res call({int itemId, String name, int quantity, double weightKg});
}

/// @nodoc
class _$OrderItemDetailDtoCopyWithImpl<$Res, $Val extends OrderItemDetailDto>
    implements $OrderItemDetailDtoCopyWith<$Res> {
  _$OrderItemDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? weightKg = null,
  }) {
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
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            weightKg: null == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderItemDetailDtoImplCopyWith<$Res>
    implements $OrderItemDetailDtoCopyWith<$Res> {
  factory _$$OrderItemDetailDtoImplCopyWith(
    _$OrderItemDetailDtoImpl value,
    $Res Function(_$OrderItemDetailDtoImpl) then,
  ) = __$$OrderItemDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int itemId, String name, int quantity, double weightKg});
}

/// @nodoc
class __$$OrderItemDetailDtoImplCopyWithImpl<$Res>
    extends _$OrderItemDetailDtoCopyWithImpl<$Res, _$OrderItemDetailDtoImpl>
    implements _$$OrderItemDetailDtoImplCopyWith<$Res> {
  __$$OrderItemDetailDtoImplCopyWithImpl(
    _$OrderItemDetailDtoImpl _value,
    $Res Function(_$OrderItemDetailDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemId = null,
    Object? name = null,
    Object? quantity = null,
    Object? weightKg = null,
  }) {
    return _then(
      _$OrderItemDetailDtoImpl(
        itemId: null == itemId
            ? _value.itemId
            : itemId // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        weightKg: null == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemDetailDtoImpl implements _OrderItemDetailDto {
  const _$OrderItemDetailDtoImpl({
    required this.itemId,
    this.name = '',
    this.quantity = 0,
    this.weightKg = 0.0,
  });

  factory _$OrderItemDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemDetailDtoImplFromJson(json);

  @override
  final int itemId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final double weightKg;

  @override
  String toString() {
    return 'OrderItemDetailDto(itemId: $itemId, name: $name, quantity: $quantity, weightKg: $weightKg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemDetailDtoImpl &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, itemId, name, quantity, weightKg);

  /// Create a copy of OrderItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemDetailDtoImplCopyWith<_$OrderItemDetailDtoImpl> get copyWith =>
      __$$OrderItemDetailDtoImplCopyWithImpl<_$OrderItemDetailDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemDetailDtoImplToJson(this);
  }
}

abstract class _OrderItemDetailDto implements OrderItemDetailDto {
  const factory _OrderItemDetailDto({
    required final int itemId,
    final String name,
    final int quantity,
    final double weightKg,
  }) = _$OrderItemDetailDtoImpl;

  factory _OrderItemDetailDto.fromJson(Map<String, dynamic> json) =
      _$OrderItemDetailDtoImpl.fromJson;

  @override
  int get itemId;
  @override
  String get name;
  @override
  int get quantity;
  @override
  double get weightKg;

  /// Create a copy of OrderItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemDetailDtoImplCopyWith<_$OrderItemDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AvailableOrderDto _$AvailableOrderDtoFromJson(Map<String, dynamic> json) {
  return _AvailableOrderDto.fromJson(json);
}

/// @nodoc
mixin _$AvailableOrderDto {
  int get orderId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get deliveryType => throw _privateConstructorUsedError;
  String get paymentType => throw _privateConstructorUsedError;
  DateTime? get deliveryDate => throw _privateConstructorUsedError;
  String? get destinationAddress => throw _privateConstructorUsedError;
  String? get postamatAddress => throw _privateConstructorUsedError;
  String? get postamatCellNumber => throw _privateConstructorUsedError;
  String? get postamatCellSize => throw _privateConstructorUsedError;
  List<OrderItemDetailDto> get items => throw _privateConstructorUsedError;

  /// Serializes this AvailableOrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableOrderDtoCopyWith<AvailableOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableOrderDtoCopyWith<$Res> {
  factory $AvailableOrderDtoCopyWith(
    AvailableOrderDto value,
    $Res Function(AvailableOrderDto) then,
  ) = _$AvailableOrderDtoCopyWithImpl<$Res, AvailableOrderDto>;
  @useResult
  $Res call({
    int orderId,
    String orderNumber,
    DateTime? createdAt,
    String status,
    String deliveryType,
    String paymentType,
    DateTime? deliveryDate,
    String? destinationAddress,
    String? postamatAddress,
    String? postamatCellNumber,
    String? postamatCellSize,
    List<OrderItemDetailDto> items,
  });
}

/// @nodoc
class _$AvailableOrderDtoCopyWithImpl<$Res, $Val extends AvailableOrderDto>
    implements $AvailableOrderDtoCopyWith<$Res> {
  _$AvailableOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? createdAt = freezed,
    Object? status = null,
    Object? deliveryType = null,
    Object? paymentType = null,
    Object? deliveryDate = freezed,
    Object? destinationAddress = freezed,
    Object? postamatAddress = freezed,
    Object? postamatCellNumber = freezed,
    Object? postamatCellSize = freezed,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            orderNumber: null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryType: null == deliveryType
                ? _value.deliveryType
                : deliveryType // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentType: null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryDate: freezed == deliveryDate
                ? _value.deliveryDate
                : deliveryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            destinationAddress: freezed == destinationAddress
                ? _value.destinationAddress
                : destinationAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            postamatAddress: freezed == postamatAddress
                ? _value.postamatAddress
                : postamatAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            postamatCellNumber: freezed == postamatCellNumber
                ? _value.postamatCellNumber
                : postamatCellNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            postamatCellSize: freezed == postamatCellSize
                ? _value.postamatCellSize
                : postamatCellSize // ignore: cast_nullable_to_non_nullable
                      as String?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItemDetailDto>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableOrderDtoImplCopyWith<$Res>
    implements $AvailableOrderDtoCopyWith<$Res> {
  factory _$$AvailableOrderDtoImplCopyWith(
    _$AvailableOrderDtoImpl value,
    $Res Function(_$AvailableOrderDtoImpl) then,
  ) = __$$AvailableOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int orderId,
    String orderNumber,
    DateTime? createdAt,
    String status,
    String deliveryType,
    String paymentType,
    DateTime? deliveryDate,
    String? destinationAddress,
    String? postamatAddress,
    String? postamatCellNumber,
    String? postamatCellSize,
    List<OrderItemDetailDto> items,
  });
}

/// @nodoc
class __$$AvailableOrderDtoImplCopyWithImpl<$Res>
    extends _$AvailableOrderDtoCopyWithImpl<$Res, _$AvailableOrderDtoImpl>
    implements _$$AvailableOrderDtoImplCopyWith<$Res> {
  __$$AvailableOrderDtoImplCopyWithImpl(
    _$AvailableOrderDtoImpl _value,
    $Res Function(_$AvailableOrderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? orderNumber = null,
    Object? createdAt = freezed,
    Object? status = null,
    Object? deliveryType = null,
    Object? paymentType = null,
    Object? deliveryDate = freezed,
    Object? destinationAddress = freezed,
    Object? postamatAddress = freezed,
    Object? postamatCellNumber = freezed,
    Object? postamatCellSize = freezed,
    Object? items = null,
  }) {
    return _then(
      _$AvailableOrderDtoImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        orderNumber: null == orderNumber
            ? _value.orderNumber
            : orderNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryType: null == deliveryType
            ? _value.deliveryType
            : deliveryType // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentType: null == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryDate: freezed == deliveryDate
            ? _value.deliveryDate
            : deliveryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        destinationAddress: freezed == destinationAddress
            ? _value.destinationAddress
            : destinationAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        postamatAddress: freezed == postamatAddress
            ? _value.postamatAddress
            : postamatAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        postamatCellNumber: freezed == postamatCellNumber
            ? _value.postamatCellNumber
            : postamatCellNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        postamatCellSize: freezed == postamatCellSize
            ? _value.postamatCellSize
            : postamatCellSize // ignore: cast_nullable_to_non_nullable
                  as String?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItemDetailDto>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableOrderDtoImpl implements _AvailableOrderDto {
  const _$AvailableOrderDtoImpl({
    required this.orderId,
    this.orderNumber = '',
    this.createdAt,
    this.status = '',
    this.deliveryType = '',
    this.paymentType = '',
    this.deliveryDate,
    this.destinationAddress,
    this.postamatAddress,
    this.postamatCellNumber,
    this.postamatCellSize,
    final List<OrderItemDetailDto> items = const [],
  }) : _items = items;

  factory _$AvailableOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableOrderDtoImplFromJson(json);

  @override
  final int orderId;
  @override
  @JsonKey()
  final String orderNumber;
  @override
  final DateTime? createdAt;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String deliveryType;
  @override
  @JsonKey()
  final String paymentType;
  @override
  final DateTime? deliveryDate;
  @override
  final String? destinationAddress;
  @override
  final String? postamatAddress;
  @override
  final String? postamatCellNumber;
  @override
  final String? postamatCellSize;
  final List<OrderItemDetailDto> _items;
  @override
  @JsonKey()
  List<OrderItemDetailDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'AvailableOrderDto(orderId: $orderId, orderNumber: $orderNumber, createdAt: $createdAt, status: $status, deliveryType: $deliveryType, paymentType: $paymentType, deliveryDate: $deliveryDate, destinationAddress: $destinationAddress, postamatAddress: $postamatAddress, postamatCellNumber: $postamatCellNumber, postamatCellSize: $postamatCellSize, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableOrderDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deliveryType, deliveryType) ||
                other.deliveryType == deliveryType) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.deliveryDate, deliveryDate) ||
                other.deliveryDate == deliveryDate) &&
            (identical(other.destinationAddress, destinationAddress) ||
                other.destinationAddress == destinationAddress) &&
            (identical(other.postamatAddress, postamatAddress) ||
                other.postamatAddress == postamatAddress) &&
            (identical(other.postamatCellNumber, postamatCellNumber) ||
                other.postamatCellNumber == postamatCellNumber) &&
            (identical(other.postamatCellSize, postamatCellSize) ||
                other.postamatCellSize == postamatCellSize) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    orderId,
    orderNumber,
    createdAt,
    status,
    deliveryType,
    paymentType,
    deliveryDate,
    destinationAddress,
    postamatAddress,
    postamatCellNumber,
    postamatCellSize,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of AvailableOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableOrderDtoImplCopyWith<_$AvailableOrderDtoImpl> get copyWith =>
      __$$AvailableOrderDtoImplCopyWithImpl<_$AvailableOrderDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableOrderDtoImplToJson(this);
  }
}

abstract class _AvailableOrderDto implements AvailableOrderDto {
  const factory _AvailableOrderDto({
    required final int orderId,
    final String orderNumber,
    final DateTime? createdAt,
    final String status,
    final String deliveryType,
    final String paymentType,
    final DateTime? deliveryDate,
    final String? destinationAddress,
    final String? postamatAddress,
    final String? postamatCellNumber,
    final String? postamatCellSize,
    final List<OrderItemDetailDto> items,
  }) = _$AvailableOrderDtoImpl;

  factory _AvailableOrderDto.fromJson(Map<String, dynamic> json) =
      _$AvailableOrderDtoImpl.fromJson;

  @override
  int get orderId;
  @override
  String get orderNumber;
  @override
  DateTime? get createdAt;
  @override
  String get status;
  @override
  String get deliveryType;
  @override
  String get paymentType;
  @override
  DateTime? get deliveryDate;
  @override
  String? get destinationAddress;
  @override
  String? get postamatAddress;
  @override
  String? get postamatCellNumber;
  @override
  String? get postamatCellSize;
  @override
  List<OrderItemDetailDto> get items;

  /// Create a copy of AvailableOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableOrderDtoImplCopyWith<_$AvailableOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateOrderAssemblyTaskDto _$CreateOrderAssemblyTaskDtoFromJson(
  Map<String, dynamic> json,
) {
  return _CreateOrderAssemblyTaskDto.fromJson(json);
}

/// @nodoc
mixin _$CreateOrderAssemblyTaskDto {
  int get orderId => throw _privateConstructorUsedError;
  int get assignedUserId => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this CreateOrderAssemblyTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrderAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrderAssemblyTaskDtoCopyWith<CreateOrderAssemblyTaskDto>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrderAssemblyTaskDtoCopyWith<$Res> {
  factory $CreateOrderAssemblyTaskDtoCopyWith(
    CreateOrderAssemblyTaskDto value,
    $Res Function(CreateOrderAssemblyTaskDto) then,
  ) =
      _$CreateOrderAssemblyTaskDtoCopyWithImpl<
        $Res,
        CreateOrderAssemblyTaskDto
      >;
  @useResult
  $Res call({
    int orderId,
    int assignedUserId,
    int priority,
    String? description,
  });
}

/// @nodoc
class _$CreateOrderAssemblyTaskDtoCopyWithImpl<
  $Res,
  $Val extends CreateOrderAssemblyTaskDto
>
    implements $CreateOrderAssemblyTaskDtoCopyWith<$Res> {
  _$CreateOrderAssemblyTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrderAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? assignedUserId = null,
    Object? priority = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            assignedUserId: null == assignedUserId
                ? _value.assignedUserId
                : assignedUserId // ignore: cast_nullable_to_non_nullable
                      as int,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateOrderAssemblyTaskDtoImplCopyWith<$Res>
    implements $CreateOrderAssemblyTaskDtoCopyWith<$Res> {
  factory _$$CreateOrderAssemblyTaskDtoImplCopyWith(
    _$CreateOrderAssemblyTaskDtoImpl value,
    $Res Function(_$CreateOrderAssemblyTaskDtoImpl) then,
  ) = __$$CreateOrderAssemblyTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int orderId,
    int assignedUserId,
    int priority,
    String? description,
  });
}

/// @nodoc
class __$$CreateOrderAssemblyTaskDtoImplCopyWithImpl<$Res>
    extends
        _$CreateOrderAssemblyTaskDtoCopyWithImpl<
          $Res,
          _$CreateOrderAssemblyTaskDtoImpl
        >
    implements _$$CreateOrderAssemblyTaskDtoImplCopyWith<$Res> {
  __$$CreateOrderAssemblyTaskDtoImplCopyWithImpl(
    _$CreateOrderAssemblyTaskDtoImpl _value,
    $Res Function(_$CreateOrderAssemblyTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateOrderAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? assignedUserId = null,
    Object? priority = null,
    Object? description = freezed,
  }) {
    return _then(
      _$CreateOrderAssemblyTaskDtoImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        assignedUserId: null == assignedUserId
            ? _value.assignedUserId
            : assignedUserId // ignore: cast_nullable_to_non_nullable
                  as int,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrderAssemblyTaskDtoImpl implements _CreateOrderAssemblyTaskDto {
  const _$CreateOrderAssemblyTaskDtoImpl({
    required this.orderId,
    required this.assignedUserId,
    this.priority = 7,
    this.description,
  });

  factory _$CreateOrderAssemblyTaskDtoImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateOrderAssemblyTaskDtoImplFromJson(json);

  @override
  final int orderId;
  @override
  final int assignedUserId;
  @override
  @JsonKey()
  final int priority;
  @override
  final String? description;

  @override
  String toString() {
    return 'CreateOrderAssemblyTaskDto(orderId: $orderId, assignedUserId: $assignedUserId, priority: $priority, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrderAssemblyTaskDtoImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.assignedUserId, assignedUserId) ||
                other.assignedUserId == assignedUserId) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, assignedUserId, priority, description);

  /// Create a copy of CreateOrderAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrderAssemblyTaskDtoImplCopyWith<_$CreateOrderAssemblyTaskDtoImpl>
  get copyWith =>
      __$$CreateOrderAssemblyTaskDtoImplCopyWithImpl<
        _$CreateOrderAssemblyTaskDtoImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrderAssemblyTaskDtoImplToJson(this);
  }
}

abstract class _CreateOrderAssemblyTaskDto
    implements CreateOrderAssemblyTaskDto {
  const factory _CreateOrderAssemblyTaskDto({
    required final int orderId,
    required final int assignedUserId,
    final int priority,
    final String? description,
  }) = _$CreateOrderAssemblyTaskDtoImpl;

  factory _CreateOrderAssemblyTaskDto.fromJson(Map<String, dynamic> json) =
      _$CreateOrderAssemblyTaskDtoImpl.fromJson;

  @override
  int get orderId;
  @override
  int get assignedUserId;
  @override
  int get priority;
  @override
  String? get description;

  /// Create a copy of CreateOrderAssemblyTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrderAssemblyTaskDtoImplCopyWith<_$CreateOrderAssemblyTaskDtoImpl>
  get copyWith => throw _privateConstructorUsedError;
}
