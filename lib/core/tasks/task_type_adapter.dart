import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';

class TaskNavigationPayload {
  final String route;
  final Map<String, dynamic> extra;

  const TaskNavigationPayload({
    required this.route,
    required this.extra,
  });
}

abstract class TaskTypeAdapter {
  String get taskType;

  TaskItemBase? parseListItem(MobileBaseTaskDto dto, int employeeId);

  TaskItemBase? parseDetails(MobileBaseTaskDto dto, int employeeId);

  TaskNavigationPayload buildNavigationPayload(TaskCardVm taskCard, int employeeId);
}
