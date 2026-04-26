import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'main_viewmodel.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/tasks/task_card_vm.dart';
import '../../core/models/tasks/task_models.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final viewModel = ref.read(mainViewModelProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    final isBoss = currentUser?.role == 'Admin' || currentUser?.role == 'Supervisor';

    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: _bgGray950,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser?.fullName ?? 'Пользователь',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Должность: ${currentUser?.role ?? ''}',
                          style: const TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (isBoss)
                        ElevatedButton(
                          onPressed: () => context.push('/boss-panel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Панель\nруководителя', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => viewModel.logout(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Выход', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!state.hasNetwork)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: const Color(0xFFFF6B6B),
                child: const Text(
                  '⚠️ Нет подключения к сети',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            Container(
              color: _bgGray950,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Мои задачи',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: state.isBusy ? null : () => viewModel.refreshTasks(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        ),
                        child: const Text('Обновить', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _sortChip(
                        label: 'По приоритету',
                        selected: state.sortMode == TaskSortMode.byPriority,
                        onTap: () => viewModel.setSortMode(TaskSortMode.byPriority),
                      ),
                      _sortChip(
                        label: 'По дедлайну',
                        selected: state.sortMode == TaskSortMode.byDeadline,
                        onTap: () => viewModel.setSortMode(TaskSortMode.byDeadline),
                      ),
                      _sortChip(
                        label: 'По типу',
                        selected: state.sortMode == TaskSortMode.byType,
                        onTap: () => viewModel.setSortMode(TaskSortMode.byType),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (state.isBusy)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(color: _primaryColor),
              ),
            if (state.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Color(0xFFFF6B6B)),
                  textAlign: TextAlign.center,
                ),
              ),
            Expanded(
              child: state.taskCards.isEmpty && !state.isBusy
                  ? const Center(
                      child: Text(
                        'Задач не найдено',
                        style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.taskCards.length,
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemBuilder: (context, index) => _buildTaskCard(context, ref, state.taskCards[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortChip({required String label, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? _primaryColor.withValues(alpha: 0.2) : _bgGray900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? _primaryColor : Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _primaryColor : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskCardVm task) {
    final type = (task.rawTask?.type != null) ? taskTypeToRussian(task.rawTask!.type) : task.kind;
    final borderColor = _priorityBorderColor(task.priority);
    final deadlineInfo = _deadlineInfo(task.deadline, task.status);

    return GestureDetector(
      onTap: () async {
        final currentUser = ref.read(currentUserProvider);
        final status = task.status;
        final taskId = task.rawTask?.taskId ?? 0;

        if (task.kind.toLowerCase() == 'inventory') {
          await context.push('/inventory-details', extra: {
            'workerId': currentUser?.employeeId ?? 0,
            'assignmentId': task.navigationId,
            'taskId': taskId,
            'taskStatusIndex': task.rawTask?.assignmentStatus.index,
          });
        } else if (task.kind.toLowerCase() == 'orderassembly') {
          await context.push('/order-assembly/active', extra: {
            'assignmentId': task.navigationId,
            'taskId': taskId,
            'taskStatusIndex': task.rawTask?.assignmentStatus.index,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не реализована навигация для типа задачи: $type')),
          );
        }

        if (context.mounted) {
          ref.read(mainViewModelProvider.notifier).refreshTasks();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _bgGray900,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.6),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.25),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.white38),
              ],
            ),
            const SizedBox(height: 8),
            Text(type, style: const TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600)),
            if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(task.subtitle!, style: const TextStyle(fontSize: 12, color: Color(0xFFA1A1AA), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _metric(label: 'Статус', value: task.statusText, valueColor: _statusColor(task.status)),
                ),
                Expanded(
                  child: _metric(label: 'Приоритет', value: '${task.priority}', valueColor: borderColor),
                ),
                Expanded(
                  child: _metric(label: 'Прогресс', value: '${task.completedSteps}/${task.totalSteps}', valueColor: Colors.white),
                ),
              ],
            ),
            if (deadlineInfo != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: deadlineInfo.$2.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: deadlineInfo.$2.withValues(alpha: 0.65)),
                ),
                child: Text(
                  deadlineInfo.$1,
                  style: TextStyle(color: deadlineInfo.$2, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metric({required String label, required String value, required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        const SizedBox(height: 3),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }

  (String, Color)? _deadlineInfo(DateTime? deadlineUtc, TaskStatus status) {
    if (deadlineUtc == null) return null;
    final now = DateTime.now().toUtc();
    final left = deadlineUtc.difference(now);
    final dateText = _formatDate(deadlineUtc);

    if (status == TaskStatus.completed) {
      return ('Дедлайн: $dateText', Colors.white70);
    }
    if (left.isNegative) {
      return ('ПРОСРОЧЕНО • до $dateText', Colors.redAccent);
    }
    if (left.inHours < 6) {
      return ('СРОЧНО • осталось ${left.inHours} ч ${left.inMinutes.remainder(60)} мин (до $dateText)', Colors.orangeAccent);
    }
    if (left.inHours < 24) {
      return ('Сегодня дедлайн • до $dateText', const Color(0xFFF59E0B));
    }
    return ('Дедлайн: $dateText', Colors.white70);
  }

  Color _priorityBorderColor(int priority) {
    switch (priority) {
      case 5:
        return Colors.redAccent;
      case 4:
        return const Color(0xFFFF7A00);
      case 3:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFF38BDF8);
      case 1:
        return const Color(0xFF22C55E);
      case 0:
      default:
        return const Color(0xFFA1A1AA);
    }
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed:
        return const Color(0xFF22C55E);
      case TaskStatus.paused:
        return const Color(0xFFF59E0B);
      case TaskStatus.cancelled:
      case TaskStatus.blocked:
        return Colors.redAccent;
      default:
        return _primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
