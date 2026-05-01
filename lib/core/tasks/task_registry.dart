import 'package:helper_app/core/tasks/inventory_adapter.dart';
import 'package:helper_app/core/tasks/order_assembly_adapter.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';

class TaskRegistry {
  TaskRegistry._();

  static final Map<String, TaskTypeAdapter> adapters = {
    'inventory': InventoryTaskAdapter(),
    'orderassembly': OrderAssemblyTaskAdapter(),
  };

  static TaskTypeAdapter? resolveByTaskType(String? taskType) {
    return adapters[taskType?.toLowerCase() ?? ''];
  }
}
