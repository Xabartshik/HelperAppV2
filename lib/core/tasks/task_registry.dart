// Добавьте импорт нового файла
import 'package:helper_app/core/tasks/inventory_adapter.dart';
import 'package:helper_app/core/tasks/order_assembly_adapter.dart';
import 'package:helper_app/core/tasks/order_handover_adapter.dart';
import 'package:helper_app/core/tasks/return_to_stock_adapter.dart';
import 'package:helper_app/core/tasks/task_type_adapter.dart';

class TaskRegistry {
  TaskRegistry._();

  static final Map<String, TaskTypeAdapter> adapters = {
    'inventory': InventoryTaskAdapter(),
    'orderassembly': OrderAssemblyTaskAdapter(),
    'orderhandover': OrderHandoverTaskAdapter(),
    'returntostock': ReturnToStockAdapter(),
  };

  static TaskTypeAdapter? resolveByTaskType(String? taskType) {
    return adapters[taskType?.toLowerCase() ?? ''];
  }
}