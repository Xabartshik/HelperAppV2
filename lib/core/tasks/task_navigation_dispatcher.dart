import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/tasks/task_registry.dart';
// Добавляем импорт DTO для доступа к полям задачи
// Импорт экрана деталей выдачи заказа

class TaskNavigationDispatcher {
  const TaskNavigationDispatcher();

  /// Универсальный метод навигации через реестр
  Future<bool> navigate(BuildContext context, TaskCardVm task, int employeeId) async {
    final adapter = TaskRegistry.resolveByTaskType(task.kind);
    if (adapter == null) {
      return false;
    }

    final payload = adapter.buildNavigationPayload(task, employeeId);
    await context.push(payload.route, extra: payload.extra);
    return true;
  }
}

// /// Ручная диспетчеризация с поддержкой возврата результата
// Future<bool> dispatchTaskNavigation(BuildContext context, MobileBaseTaskDto task, int workerId) async {
//   switch (task.taskType) {
//     case 'OrderAssembly':
//       // Логика для сборки заказа[cite: 2]
//       return false; 

//     case 'OrderHandover': 
//           return await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ActiveHandoverScreen(
//                 // Передаем значения напрямую, так как в DTO это уже int
//                 assignmentId: task.taskDetails['AssignmentId'] ?? 0,
//                 taskId: task.taskId,
//                 taskStatusIndex: task.status, 
//                 assignmentStatusIndex: task.assignmentStatus,
//               ),
//             ),
//           ) ?? false;

//     default:
//       debugPrint('Неизвестный тип задачи: ${task.taskType}');
//       return false;
//   }
// }