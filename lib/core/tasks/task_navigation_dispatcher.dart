import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/models/tasks/task_card_vm.dart';
import 'package:helper_app/core/tasks/task_registry.dart';

class TaskNavigationDispatcher {
  const TaskNavigationDispatcher();

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
