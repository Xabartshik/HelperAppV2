import 'task_models.dart';

class TaskCardVm {
  final String kind;
  final int navigationId;
  final String title;
  final String? subtitle;
  final String statusText;
  final String? primaryMetric;
  final DateTime createdAt;
  final Map<String, String> badges;
  final TaskItemBase? rawTask;

  TaskCardVm({
    required this.kind,
    required this.navigationId,
    required this.title,
    this.subtitle,
    required this.statusText,
    this.primaryMetric,
    required this.createdAt,
    required this.badges,
    this.rawTask,
  });

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

    // В Dart enum.name выдает имя значения в camelCase. Можно улучшить отображение при желании.
    final badges = <String, String>{
      'Позиция': positionText,
      'Статус задачи': task.status.name, 
      'Расхождений': varianceCount.toString(),
    };

    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description,
      statusText: task.status.name,
      primaryMetric: primaryMetric,
      createdAt: task.createdAt,
      badges: badges,
      rawTask: task,
    );
  }

  static TaskCardVm _mapGenericTaskToCard(TaskItemBase task) {
    return TaskCardVm(
      kind: task.type.name,
      navigationId: task.taskId,
      title: task.title,
      subtitle: task.description,
      statusText: task.status.name,
      primaryMetric: 'Приоритет: ${task.priority}',
      createdAt: task.createdAt,
      badges: {
        'Тип': task.type.name,
        'Статус': task.status.name,
      },
      rawTask: task,
    );
  }

  static TaskCardVm _mapOrderAssemblyTaskToCard(OrderAssemblyTaskItem task) {
    // Подсчитываем количество уже размещённых товаров
    final placedCount = task.cellPlacements
        .expand((c) => c.items)
        .where((i) => i.status.toLowerCase() == 'placed')
        .length;
    final totalItems = task.totalLines;

    return TaskCardVm(
      kind: task.type.name,          // 'orderAssembly'
      navigationId: task.assignmentId,
      title: task.title,
      subtitle: task.description ?? 'Сборка заказа #${task.orderId}',
      statusText: task.status.name,
      primaryMetric: totalItems > 0 ? '$placedCount/$totalItems позиций' : 'Нет позиций',
      createdAt: task.createdAt,
      badges: {
        'Тип': 'Сборка',
        'Заказ': '#${task.orderId}',
        'Статус': task.status.name,
        'Ячеек': '${task.cellPlacements.length}',
      },
      rawTask: task,
    );
  }
}
