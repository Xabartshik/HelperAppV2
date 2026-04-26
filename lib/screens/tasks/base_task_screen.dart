import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/tasks/task_models.dart';
import '../../core/services/task_service.dart';
import '../home/main_viewmodel.dart';

class BaseTaskScreenArgs {
  final int taskId;
  final int workerId;
  final int? taskStatusIndex;
  final int? assignmentStatusIndex;

  const BaseTaskScreenArgs({
    required this.taskId,
    required this.workerId,
    this.taskStatusIndex,
    this.assignmentStatusIndex,
  });
}

mixin BaseTaskScreenMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool _isTaskStarted = false;

  @protected
  BaseTaskScreenArgs get baseTaskArgs;

  @protected
  bool get isTaskStarted => _isTaskStarted;

  @protected
  AssignmentStatus? get initialStatus {
    final idx = baseTaskArgs.assignmentStatusIndex;
    if (idx == null || idx < 0 || idx >= AssignmentStatus.values.length) return null;
    return AssignmentStatus.values[idx];
  }

  @protected
  bool get canEditTask {
    final status = initialStatus;
    if (status == null) return false;
    if (status == AssignmentStatus.inProgress || status == AssignmentStatus.completed) return true;
    return _isTaskStarted;
  }

  @protected
  void initializeTaskStartState() {
    final status = initialStatus;
    _isTaskStarted = status == AssignmentStatus.inProgress || status == AssignmentStatus.completed;
  }

  @protected
  Future<void> onTaskStarted() async {}

  @protected
  Future<void> startTask() async {
    final args = baseTaskArgs;
    if (args.taskId <= 0 || args.workerId <= 0) return;

    final success = await ref.read(taskServiceProvider).startTaskAsync(args.taskId, args.workerId);
    if (!mounted || !success) return;

    setState(() => _isTaskStarted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Задача переведена в работу')),
    );

    await onTaskStarted();
    await ref.read(mainViewModelProvider.notifier).refreshTasks();
  }

  @protected
  Widget buildTaskNotStartedBanner({
    Color backgroundColor = const Color(0xFF2C2C2E),
    Color borderColor = Colors.orangeAccent,
    Color actionColor = const Color(0xFF7C3AED),
    EdgeInsetsGeometry margin = const EdgeInsets.fromLTRB(12, 8, 12, 8),
    String subtitle = 'Доступен только просмотр деталей.',
  }) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_clock, color: Colors.orangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Задача не запущена. $subtitle',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          ElevatedButton(
            onPressed: startTask,
            style: ElevatedButton.styleFrom(backgroundColor: actionColor),
            child: const Text('Начать', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
