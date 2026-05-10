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

String assignmentStatusToRussian(AssignmentStatus status) {
  switch (status) {
    case AssignmentStatus.assigned:
      return 'Назначена';
    case AssignmentStatus.inProgress:
      return 'В работе';
    case AssignmentStatus.paused:
      return 'На паузе';
    case AssignmentStatus.completed:
      return 'Завершена';
    case AssignmentStatus.cancelled:
      return 'Отменена';
  }
}

String taskTypeToRussian(TaskType type) {
  switch (type) {
    case TaskType.inventory:
      return 'Инвентаризация';
    case TaskType.orderAssembly:
      return 'Подготовка заказа к выдаче';
    case TaskType.orderHandover: // <-- ДОБАВЛЕНО
      return 'Выдача / Передача заказа';
    case TaskType.returnToStock: // <-- ДОБАВЛЕНО
      return 'Возврат на полку';
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
    if (task is OrderHandoverTaskItem) { 
      return _mapOrderHandoverTaskToCard(task);
    }
    if (task is ReturnToStockTaskItem) {
      return _mapReturnToStockTaskToCard(task);
    }
    return _mapGenericTaskToCard(task);
  }

static TaskCardVm _mapReturnToStockTaskToCard(ReturnToStockTaskItem task) {
    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: assignmentStatusToRussian(task.assignmentStatus),
      priority: task.priority,
      deadline: task.deadline?.toLocal(),
      completedSteps: task.completedLinesCount,
      totalSteps: task.totalLines,
      primaryMetric: task.totalLines > 0 ? '${task.completedLinesCount}/${task.totalLines} позиций' : 'Ждет выполнения',
      createdAt: task.createdAt,
      badges: {
        'Тип': 'Складской возврат',
        'Статус': assignmentStatusToRussian(task.assignmentStatus),
        if (task.isCooperative) 'Напарник': task.partnerName ?? 'Ожидание',
      },
      rawTask: task,
    );
  }
  
static TaskCardVm _mapOrderHandoverTaskToCard(OrderHandoverTaskItem task) {
    final isCourier = task.handoverType == 'ToCourier';
    
    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description ?? (isCourier ? 'Передача курьеру' : 'Выдача клиенту'),
      status: task.status,
      statusText: assignmentStatusToRussian(task.assignmentStatus),
      priority: task.priority,
      deadline: task.deadline?.toLocal(),
      completedSteps: task.completedLinesCount,
      totalSteps: task.totalLines,
      primaryMetric: task.totalLines > 0 ? '${task.completedLinesCount}/${task.totalLines} товаров' : 'Нет товаров',
      createdAt: task.createdAt,
      badges: {
        'Тип': 'Выдача',
        'Заказ': '#${task.orderId}',
        'Кому': isCourier ? 'Курьер' : 'Клиент',
      },
      rawTask: task,
    );
  }

  static TaskCardVm _mapInventoryTaskToCard(InventoryTaskItem task) {
    final lines = task.lines;

    final totalCount = lines.isNotEmpty ? lines.length : task.totalLinesCount;
    final completedCount = lines.isNotEmpty 
        ? lines.where((l) => l.actualQuantity != null).length 
        : task.completedLinesCount;
    
    final varianceCount = lines.isNotEmpty 
        ? lines.where((l) => l.actualQuantity != null && l.actualQuantity != l.expectedQuantity).length
        : 0; // Расхождения на уровне списка не так важны, можно оставить 0

    final primaryMetric = totalCount > 0 ? '$completedCount/$totalCount позиций' : 'Нет позиций';

    final firstPosition = lines.isNotEmpty ? lines.first.positionCode : null;
    final positionText = firstPosition?.shortDescription ?? firstPosition?.fullDescription ?? '—';

    final badges = <String, String>{
      'Позиция': positionText,
      'Статус': assignmentStatusToRussian(task.assignmentStatus),
      'Расхождения': varianceCount.toString(),
    };

    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: assignmentStatusToRussian(task.assignmentStatus),
      priority: task.priority,
      deadline: task.deadline?.toLocal(),
      completedSteps: completedCount,
      totalSteps: totalCount,
      primaryMetric: primaryMetric,
      createdAt: task.createdAt,
      badges: badges,
      rawTask: task,
    );
  }

  static TaskCardVm _mapOrderAssemblyTaskToCard(OrderAssemblyTaskItem task) {
    final totalItems = task.totalLines;
    
    // Если массив ячеек пуст, используем счетчик с бэкенда
    final placedCount = task.cellPlacements.isNotEmpty
        ? task.cellPlacements.expand((c) => c.items).where((i) => i.status.toLowerCase() == 'placed').length
        : task.completedLinesCount;

    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      status: task.status,
      statusText: assignmentStatusToRussian(task.assignmentStatus),
      priority: task.priority,
      deadline: task.deadline?.toLocal(),
      completedSteps: placedCount,
      totalSteps: totalItems,
      primaryMetric: totalItems > 0 ? '$placedCount/$totalItems позиций' : 'Нет позиций',
      createdAt: task.createdAt,
      badges: {
        'Тип': 'Подготовка заказа',
        'Заказ': '#${task.orderId}',
        'Статус': assignmentStatusToRussian(task.assignmentStatus),
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
      statusText: assignmentStatusToRussian(task.assignmentStatus),
      priority: task.priority,
      deadline: task.deadline?.toLocal(),
      completedSteps: 0,
      totalSteps: 0,
      primaryMetric: 'Приоритет: ${task.priority}',
      createdAt: task.createdAt,
      badges: {
        'Тип': taskTypeToRussian(task.type),
        'Статус': assignmentStatusToRussian(task.assignmentStatus),
      },
      rawTask: task,
    );
  }
}
