import 'task_models.dart';

String taskStatusToRussian(TaskStatus status) {
  switch (status) {
    case TaskStatus.newStatus:
      return 'Новая';
    case TaskStatus.assigned:
      return 'Назначена';
    case TaskStatus.inProgress:
      return 'В работе';
    case TaskStatus.completed:
      return 'Завершена';
    case TaskStatus.cancelled:
      return 'Отменена';
    case TaskStatus.paused:
      return 'На паузе';
    case TaskStatus.blocked:
      return 'Заблокирована';
  }
}

String taskTypeToRussian(TaskType type) {
  switch (type) {
    case TaskType.inventory:
      return 'Инвентаризация';
    case TaskType.orderAssembly:
      return 'Подготовка заказа к выдаче';
    case TaskType.receipt:
      return 'Приёмка';
    case TaskType.movement:
      return 'Перемещение';
    case TaskType.shipping:
      return 'Отгрузка';
    case TaskType.packing:
      return 'Упаковка';
    case TaskType.audit:
      return 'Аудит';
    case TaskType.labeling:
      return 'Маркировка';
    case TaskType.loading:
      return 'Погрузка';
  }
}

class TaskCardVm {
  final String kind;
  final int navigationId;
  final String title;
  final String? subtitle;

  final TaskStatus status;
  final String statusText;
  final int priority;
  final DateTime? deadline;
  final int completedSteps;
  final int totalSteps;

  final String? primaryMetric;
  final DateTime createdAt;
  final Map<String, String> badges;
  final TaskItemBase? rawTask;

  TaskCardVm({
    required this.kind,
    required this.navigationId,
    required this.title,
    this.subtitle,
    required this.status,
    required this.statusText,
    required this.priority,
    this.deadline,
    this.completedSteps = 0,
    this.totalSteps = 0,
    this.primaryMetric,
    required this.createdAt,
    required this.badges,
    this.rawTask,
  });

  bool get isOverdue => deadline != null && deadline!.isBefore(DateTime.now().toUtc()) && status != TaskStatus.completed;

  double get progressFraction => totalSteps > 0 ? (completedSteps / totalSteps).clamp(0.0, 1.0) : 0.0;

  static TaskCardVm fromTask(TaskItemBase task) {
    if (task is InventoryTaskItem) {
      return _mapInventoryTaskToCard(task);
    }
    if (task is OrderAssemblyTaskItem) {
      return _mapOrderAssemblyTaskToCard(task);
    }
    return _mapGenericTaskToCard(task);
  }

  static TaskCardVm _mapInventoryTaskToCard(InventoryTaskItem task) {
    final lines = task.lines;
    final completedCount = lines.where((l) => l.actualQuantity != null).length;
    final totalCount = lines.length;
    final varianceCount = lines.where((l) => l.actualQuantity != null && l.actualQuantity != l.expectedQuantity).length;

    final primaryMetric = totalCount > 0 ? '$completedCount/$totalCount позиций' : 'Нет позиций';

    final firstPosition = lines.isNotEmpty ? lines.first.positionCode : null;
    final positionText = firstPosition?.shortDescription ?? firstPosition?.fullDescription ?? '—';

    final badges = <String, String>{
      'Позиция': positionText,
      'Статус': taskStatusToRussian(task.status),
      'Расхождения': varianceCount.toString(),
    };

    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: taskStatusToRussian(task.status),
      priority: task.priority,
      deadline: task.deadline,
      completedSteps: completedCount,
      totalSteps: totalCount,
      primaryMetric: primaryMetric,
      createdAt: task.createdAt,
      badges: badges,
      rawTask: task,
    );
  }

  static TaskCardVm _mapOrderAssemblyTaskToCard(OrderAssemblyTaskItem task) {
    final placedCount = task.cellPlacements.expand((c) => c.items).where((i) => i.status.toLowerCase() == 'placed').length;
    final totalItems = task.totalLines;

    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: taskStatusToRussian(task.status),
      priority: task.priority,
      deadline: task.deadline,
      completedSteps: placedCount,
      totalSteps: totalItems,
      primaryMetric: totalItems > 0 ? '$placedCount/$totalItems позиций' : 'Нет позиций',
      createdAt: task.createdAt,
      badges: {
        'Тип': 'Подготовка заказа',
        'Заказ': '#${task.orderId}',
        'Статус': taskStatusToRussian(task.status),
        'Ячейки': '${task.cellPlacements.length}',
      },
      rawTask: task,
    );
  }

  static TaskCardVm _mapGenericTaskToCard(TaskItemBase task) {
    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.taskId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: taskStatusToRussian(task.status),
      priority: task.priority,
      deadline: task.deadline,
      completedSteps: 0,
      totalSteps: 0,
      primaryMetric: 'Приоритет: ${task.priority}',
      createdAt: task.createdAt,
      badges: {
        'Тип': taskTypeToRussian(task.type),
        'Статус': taskStatusToRussian(task.status),
      },
      rawTask: task,
    );
  }
}
