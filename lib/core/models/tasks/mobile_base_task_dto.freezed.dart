// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint

part of 'mobile_base_task_dto.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.',
);

MobileBaseTaskDto _$MobileBaseTaskDtoFromJson(Map<String, dynamic> json) {
  return _MobileBaseTaskDto.fromJson(json);
}

mixin _$MobileBaseTaskDto {
  int get taskId => throw _privateConstructorUsedError;
  int get branchId => throw _privateConstructorUsedError;
  String get taskType => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  DateTime? get deadline => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'priorityLevel')
  int get priority => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get taskDetails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  $MobileBaseTaskDtoCopyWith<MobileBaseTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

abstract class $MobileBaseTaskDtoCopyWith<$Res> {
  factory $MobileBaseTaskDtoCopyWith(
    MobileBaseTaskDto value,
    $Res Function(MobileBaseTaskDto) then,
  ) = _$MobileBaseTaskDtoCopyWithImpl<$Res, MobileBaseTaskDto>;

  $Res call({
    int taskId,
    int branchId,
    String taskType,
    int status,
    DateTime? deadline,
    String title,
    String? description,
    @JsonKey(name: 'priorityLevel') int priority,
    DateTime? createdAt,
    Map<String, dynamic> taskDetails,
  });
}

class _$MobileBaseTaskDtoCopyWithImpl<$Res, $Val extends MobileBaseTaskDto>
    implements $MobileBaseTaskDtoCopyWith<$Res> {
  _$MobileBaseTaskDtoCopyWithImpl(this._value, this._then);

  final $Val _value;
  final $Res Function($Val) _then;

  @override
  $Res call({
    Object? taskId = null,
    Object? branchId = null,
    Object? taskType = null,
    Object? status = null,
    Object? deadline = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? priority = null,
    Object? createdAt = freezed,
    Object? taskDetails = null,
  }) {
    return _then(
      _value.copyWith(
            taskId: null == taskId ? _value.taskId : taskId as int,
            branchId: null == branchId ? _value.branchId : branchId as int,
            taskType: null == taskType ? _value.taskType : taskType as String,
            status: null == status ? _value.status : status as int,
            deadline: freezed == deadline ? _value.deadline : deadline as DateTime?,
            title: null == title ? _value.title : title as String,
            description: freezed == description ? _value.description : description as String?,
            priority: null == priority ? _value.priority : priority as int,
            createdAt: freezed == createdAt ? _value.createdAt : createdAt as DateTime?,
            taskDetails: null == taskDetails
                ? _value.taskDetails
                : taskDetails as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

abstract class _$$MobileBaseTaskDtoImplCopyWith<$Res>
    implements $MobileBaseTaskDtoCopyWith<$Res> {
  factory _$$MobileBaseTaskDtoImplCopyWith(
    _$MobileBaseTaskDtoImpl value,
    $Res Function(_$MobileBaseTaskDtoImpl) then,
  ) = __$$MobileBaseTaskDtoImplCopyWithImpl<$Res>;

  @override
  $Res call({
    int taskId,
    int branchId,
    String taskType,
    int status,
    DateTime? deadline,
    String title,
    String? description,
    @JsonKey(name: 'priorityLevel') int priority,
    DateTime? createdAt,
    Map<String, dynamic> taskDetails,
  });
}

class __$$MobileBaseTaskDtoImplCopyWithImpl<$Res>
    extends _$MobileBaseTaskDtoCopyWithImpl<$Res, _$MobileBaseTaskDtoImpl>
    implements _$$MobileBaseTaskDtoImplCopyWith<$Res> {
  __$$MobileBaseTaskDtoImplCopyWithImpl(
    _$MobileBaseTaskDtoImpl _value,
    $Res Function(_$MobileBaseTaskDtoImpl) _then,
  ) : super(_value, _then);
}

@JsonSerializable()
class _$MobileBaseTaskDtoImpl implements _MobileBaseTaskDto {
  const _$MobileBaseTaskDtoImpl({
    this.taskId = 0,
    this.branchId = 0,
    this.taskType = '',
    this.status = 0,
    this.deadline,
    this.title = 'Без названия',
    this.description,
    @JsonKey(name: 'priorityLevel') this.priority = 5,
    this.createdAt,
    this.taskDetails = const <String, dynamic>{},
  });

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
  @override
  @JsonKey()
  final Map<String, dynamic> taskDetails;

  @override
  String toString() =>
      'MobileBaseTaskDto(taskId: $taskId, branchId: $branchId, taskType: $taskType, status: $status, deadline: $deadline, title: $title, description: $description, priority: $priority, createdAt: $createdAt, taskDetails: $taskDetails)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MobileBaseTaskDtoImpl &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.branchId, branchId) || other.branchId == branchId) &&
            (identical(other.taskType, taskType) || other.taskType == taskType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.deadline, deadline) || other.deadline == deadline) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.priority, priority) || other.priority == priority) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.taskDetails, taskDetails));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    taskId,
    branchId,
    taskType,
    status,
    deadline,
    title,
    description,
    priority,
    createdAt,
    const DeepCollectionEquality().hash(taskDetails),
  );

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileBaseTaskDtoImplCopyWith<_$MobileBaseTaskDtoImpl> get copyWith =>
      __$$MobileBaseTaskDtoImplCopyWithImpl<_$MobileBaseTaskDtoImpl>(this, _$identity);

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
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MobileBaseTaskDtoImplCopyWith<_$MobileBaseTaskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
