import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_tasks_viewmodel.dart';
import 'employee_workload_tab.dart'; // Для переиспользования showAssigneeDetailsSheet
import '../../core/models/boss_panel/boss_panel_models.dart';

class ActiveTasksTab extends ConsumerWidget {
  const ActiveTasksTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeTasksProvider);
    final vm = ref.read(activeTasksProvider.notifier);

    if (state.isLoading) return const Center(child: CircularProgressIndicator(color: _primaryColor));

    // Если начальник нажал на задачу — показываем её назначения
    if (state.selectedTask != null) {
      return _TaskAssignmentsView(
        task: state.selectedTask!,
        onBack: vm.deselectTask,
      );
    }

    // Иначе показываем общий список задач
    return RefreshIndicator(
      onRefresh: vm.loadTasks,
      color: _primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.tasks.length,
        itemBuilder: (context, index) => _TaskMainCard(
          task: state.tasks[index],
          onTap: () => vm.selectTask(state.tasks[index]),
        ),
      ),
    );
  }
}
String _mapTaskType(String type) {
  switch (type) {
    case 'ReturnToStock': return 'Возврат на полку';
    case 'OrderAssembly': return 'Сборка товара';
    case 'OrderHandover': return 'Выдача товара';
    default: return type;
  }
}

class _TaskMainCard extends StatelessWidget {
  final BossPanelTaskCardDto task;
  final VoidCallback onTap;

  const _TaskMainCard({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isExpress = task.title.toLowerCase().contains('express');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExpress ? Colors.orangeAccent.withValues(alpha: 0.3) : Colors.white10,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isExpress)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text('EXPRESS — ПРЯМАЯ ВЫДАЧА', 
                              style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(_mapTaskType(task.taskType), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  _buildAssigneesCount(task.assignees.length),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: task.overallProgressPercentage / 100,
                  minHeight: 6,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(isExpress ? Colors.orangeAccent : const Color(0xFF7C3AED)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssigneesCount(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const Icon(Icons.people_outline, size: 14, color: Colors.white54),
          const SizedBox(width: 4),
          Text('$count', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TaskAssignmentsView extends StatelessWidget {
  final BossPanelTaskCardDto task;
  final VoidCallback onBack;

  const _TaskAssignmentsView({required this.task, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Заголовок с кнопкой назад
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: Colors.white)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('Список назначений', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: task.assignees.length,
            itemBuilder: (context, index) {
              final assignee = task.assignees[index];
              
              // Вычисляем процент выполнения для полоски прогресса
              final double progress = assignee.assignedVolume > 0 
                  ? (assignee.completedVolume / assignee.assignedVolume).clamp(0.0, 1.0) 
                  : 0.0;

              return Card(
                color: const Color(0xFF1C1C1E),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => showAssigneeDetailsSheet(context, task, assignee),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Color(0xFF7C3AED), 
                              child: Icon(Icons.person, color: Colors.white, size: 18)
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    assignee.fullName, 
                                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    assignee.status, 
                                    style: TextStyle(
                                      color: assignee.status.toLowerCase() == 'в процессе' || assignee.status.toLowerCase() == 'inprogress'
                                          ? Colors.greenAccent 
                                          : Colors.white70, 
                                      fontSize: 12
                                    )
                                  ),
                                ],
                              ),
                            ),
                            // Блок с цифрами объема
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${assignee.completedVolume} / ${assignee.assignedVolume}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Детальный прогресс-бар
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.white10,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}