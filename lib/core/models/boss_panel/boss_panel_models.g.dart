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
  totalComplexity: (json['totalComplexity'] as num?)?.toDouble() ?? 0.0,
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
  'totalComplexity': instance.totalComplexity,
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
  maxWeightKg: (json['maxWeightKg'] as num?)?.toDouble(),
  vehicleName: json['vehicleName'] as String?,
  isOnRoute: json['isOnRoute'] as bool? ?? false,
);

Map<String, dynamic> _$$AvailableEmployeeDtoImplToJson(
  _$AvailableEmployeeDtoImpl instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'fullName': instance.fullName,
  'isAtWork': instance.isAtWork,
  'activeTasksCount': instance.activeTasksCount,
  'isRecommended': instance.isRecommended,
  'maxWeightKg': instance.maxWeightKg,
  'vehicleName': instance.vehicleName,
  'isOnRoute': instance.isOnRoute,
};

_$CreateInventoryByZoneDtoImpl _$$CreateInventoryByZoneDtoImplFromJson(
  Map<String, dynamic> json,
) => _$CreateInventoryByZoneDtoImpl(
  zonePrefixes:
      (json['zonePrefixes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  priorityLevel: (json['priorityLevel'] as num?)?.toInt() ?? 3,
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
  'priorityLevel': instance.priorityLevel,
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

_$OrderItemDetailDtoImpl _$$OrderItemDetailDtoImplFromJson(
  Map<String, dynamic> json,
) => _$OrderItemDetailDtoImpl(
  itemId: (json['itemId'] as num).toInt(),
  name: json['name'] as String? ?? '',
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$OrderItemDetailDtoImplToJson(
  _$OrderItemDetailDtoImpl instance,
) => <String, dynamic>{
  'itemId': instance.itemId,
  'name': instance.name,
  'quantity': instance.quantity,
  'weightKg': instance.weightKg,
};

_$AvailableOrderDtoImpl _$$AvailableOrderDtoImplFromJson(
  Map<String, dynamic> json,
) => _$AvailableOrderDtoImpl(
  orderId: (json['orderId'] as num).toInt(),
  orderNumber: json['orderNumber'] as String? ?? '',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  status: json['status'] as String? ?? '',
  deliveryType: json['deliveryType'] as String? ?? '',
  paymentType: json['paymentType'] as String? ?? '',
  deliveryDate: json['deliveryDate'] == null
      ? null
      : DateTime.parse(json['deliveryDate'] as String),
  destinationAddress: json['destinationAddress'] as String?,
  postamatAddress: json['postamatAddress'] as String?,
  postamatCellNumber: json['postamatCellNumber'] as String?,
  postamatCellSize: json['postamatCellSize'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItemDetailDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$AvailableOrderDtoImplToJson(
  _$AvailableOrderDtoImpl instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'orderNumber': instance.orderNumber,
  'createdAt': instance.createdAt?.toIso8601String(),
  'status': instance.status,
  'deliveryType': instance.deliveryType,
  'paymentType': instance.paymentType,
  'deliveryDate': instance.deliveryDate?.toIso8601String(),
  'destinationAddress': instance.destinationAddress,
  'postamatAddress': instance.postamatAddress,
  'postamatCellNumber': instance.postamatCellNumber,
  'postamatCellSize': instance.postamatCellSize,
  'items': instance.items,
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
