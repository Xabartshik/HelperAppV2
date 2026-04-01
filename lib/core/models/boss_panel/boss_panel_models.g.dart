// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'boss_panel_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BossPanelTaskCardDtoImpl _$$BossPanelTaskCardDtoImplFromJson(
  Map<String, dynamic> json,
) => _$BossPanelTaskCardDtoImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String? ?? '',
  taskType: json['taskType'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  expectedCompletionDate: json['expectedCompletionDate'] == null
      ? null
      : DateTime.parse(json['expectedCompletionDate'] as String),
  overallProgressPercentage:
      (json['overallProgressPercentage'] as num?)?.toInt() ?? 0,
  assignees:
      (json['assignees'] as List<dynamic>?)
          ?.map(
            (e) => TaskAssigneeProgressDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$BossPanelTaskCardDtoImplToJson(
  _$BossPanelTaskCardDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'taskType': instance.taskType,
  'createdAt': instance.createdAt.toIso8601String(),
  'expectedCompletionDate': instance.expectedCompletionDate?.toIso8601String(),
  'overallProgressPercentage': instance.overallProgressPercentage,
  'assignees': instance.assignees,
};

_$TaskAssigneeProgressDtoImpl _$$TaskAssigneeProgressDtoImplFromJson(
  Map<String, dynamic> json,
) => _$TaskAssigneeProgressDtoImpl(
  employeeId: (json['employeeId'] as num).toInt(),
  fullName: json['fullName'] as String? ?? '',
  assignedVolume: (json['assignedVolume'] as num?)?.toInt() ?? 0,
  completedVolume: (json['completedVolume'] as num?)?.toInt() ?? 0,
  status: json['status'] as String? ?? '',
);

Map<String, dynamic> _$$TaskAssigneeProgressDtoImplToJson(
  _$TaskAssigneeProgressDtoImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'fullName': instance.fullName,
  'assignedVolume': instance.assignedVolume,
  'completedVolume': instance.completedVolume,
  'status': instance.status,
};

_$EmployeeWorkloadDtoImpl _$$EmployeeWorkloadDtoImplFromJson(
  Map<String, dynamic> json,
) => _$EmployeeWorkloadDtoImpl(
  employeeId: (json['employeeId'] as num).toInt(),
  fullName: json['fullName'] as String? ?? '',
  isAtWork: json['isAtWork'] as bool? ?? false,
  activeTasksCount: (json['activeTasksCount'] as num?)?.toInt() ?? 0,
  activeTasks:
      (json['activeTasks'] as List<dynamic>?)
          ?.map((e) => ActiveTaskBriefDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$EmployeeWorkloadDtoImplToJson(
  _$EmployeeWorkloadDtoImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'fullName': instance.fullName,
  'isAtWork': instance.isAtWork,
  'activeTasksCount': instance.activeTasksCount,
  'activeTasks': instance.activeTasks,
};

_$ActiveTaskBriefDtoImpl _$$ActiveTaskBriefDtoImplFromJson(
  Map<String, dynamic> json,
) => _$ActiveTaskBriefDtoImpl(
  taskId: (json['taskId'] as num).toInt(),
  title: json['title'] as String? ?? '',
  taskType: json['taskType'] as String? ?? '',
  status: json['status'] as String? ?? '',
);

Map<String, dynamic> _$$ActiveTaskBriefDtoImplToJson(
  _$ActiveTaskBriefDtoImpl instance,
) => <String, dynamic>{
  'taskId': instance.taskId,
  'title': instance.title,
  'taskType': instance.taskType,
  'status': instance.status,
};

_$AvailableEmployeeDtoImpl _$$AvailableEmployeeDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableEmployeeDtoImpl(
  employeeId: (json['employeeId'] as num).toInt(),
  fullName: json['fullName'] as String? ?? '',
  isAtWork: json['isAtWork'] as bool? ?? false,
  activeTasksCount: (json['activeTasksCount'] as num?)?.toInt() ?? 0,
  isRecommended: json['isRecommended'] as bool? ?? false,
);

Map<String, dynamic> _$$AvailableEmployeeDtoImplToJson(
  _$AvailableEmployeeDtoImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'fullName': instance.fullName,
  'isAtWork': instance.isAtWork,
  'activeTasksCount': instance.activeTasksCount,
  'isRecommended': instance.isRecommended,
};

_$CreateInventoryByZoneDtoImpl _$$CreateInventoryByZoneDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateInventoryByZoneDtoImpl(
  zonePrefixes:
      (json['zonePrefixes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  priority: (json['priority'] as num?)?.toInt() ?? 3,
  workerCount: (json['workerCount'] as num?)?.toInt() ?? 1,
  workerIds: (json['workerIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  description: json['description'] as String?,
  deadlineDate: json['deadlineDate'] == null
      ? null
      : DateTime.parse(json['deadlineDate'] as String),
);

Map<String, dynamic> _$$CreateInventoryByZoneDtoImplToJson(
  _$CreateInventoryByZoneDtoImpl instance,
) => <String, dynamic>{
  'zonePrefixes': instance.zonePrefixes,
  'priority': instance.priority,
  'workerCount': instance.workerCount,
  'workerIds': instance.workerIds,
  'description': instance.description,
  'deadlineDate': instance.deadlineDate?.toIso8601String(),
};

_$PositionCellDtoImpl _$$PositionCellDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PositionCellDtoImpl(
  positionId: (json['positionId'] as num).toInt(),
  branchId: (json['branchId'] as num).toInt(),
  status: json['status'] as String? ?? "Active",
  zoneCode: json['zoneCode'] as String? ?? '',
  firstLevelStorageType: json['firstLevelStorageType'] as String? ?? '',
  flsNumber: json['flsNumber'] as String? ?? '',
  secondLevelStorage: json['secondLevelStorage'] as String?,
  thirdLevelStorage: json['thirdLevelStorage'] as String?,
);

Map<String, dynamic> _$$PositionCellDtoImplToJson(
  _$PositionCellDtoImpl instance,
) => <String, dynamic>{
  'positionId': instance.positionId,
  'branchId': instance.branchId,
  'status': instance.status,
  'zoneCode': instance.zoneCode,
  'firstLevelStorageType': instance.firstLevelStorageType,
  'flsNumber': instance.flsNumber,
  'secondLevelStorage': instance.secondLevelStorage,
  'thirdLevelStorage': instance.thirdLevelStorage,
};

_$AvailableOrderDtoImpl _$$AvailableOrderDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableOrderDtoImpl(
  orderId: (json['orderId'] as num).toInt(),
  customerName: json['customerName'] as String? ?? '',
  deliveryDate: json['deliveryDate'] == null
      ? null
      : DateTime.parse(json['deliveryDate'] as String),
  type: json['type'] as String? ?? '',
  itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$AvailableOrderDtoImplToJson(
  _$AvailableOrderDtoImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'customerName': instance.customerName,
  'deliveryDate': instance.deliveryDate?.toIso8601String(),
  'type': instance.type,
  'itemsCount': instance.itemsCount,
};

_$CreateOrderAssemblyTaskDtoImpl _$$CreateOrderAssemblyTaskDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateOrderAssemblyTaskDtoImpl(
  orderId: (json['orderId'] as num).toInt(),
  assignedUserId: (json['assignedUserId'] as num).toInt(),
  priority: (json['priority'] as num?)?.toInt() ?? 7,
  description: json['description'] as String?,
);

Map<String, dynamic> _$$CreateOrderAssemblyTaskDtoImplToJson(
  _$CreateOrderAssemblyTaskDtoImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'assignedUserId': instance.assignedUserId,
  'priority': instance.priority,
  'description': instance.description,
};
