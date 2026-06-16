import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_tasks_viewmodel.dart';
import 'employee_workload_tab.dart'; // Для переиспользования showAssigneeDetailsSheet
import 'package:go_router/go_router.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class ActiveTasksTab extends ConsumerWidget {
  const ActiveTasksTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeTasksProvider);
    final vm = ref.read(activeTasksProvider.notifier);

    if (state.isLoading && state.tasks.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor));
    }

    // Если начальник нажал на задачу — показываем её назначения
    if (state.selectedTask != null) {
      return _TaskAssignmentsView(
        task: state.selectedTask!,
        onBack: vm.deselectTask,
      );
    }

    // Иначе показываем общий список задач с заголовком и кнопкой обновления
    return Column(
      children: [
        _buildHeader(context, state, vm),
        Expanded(
          child: state.tasks.isEmpty
              ? _EmptyTasksState(onRefresh: vm.loadTasks)
              : RefreshIndicator(
                  onRefresh: vm.loadTasks,
                  color: _primaryColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) => _TaskMainCard(
                      task: state.tasks[index],
                      onTap: () => vm.selectTask(state.tasks[index]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ActiveTasksState state, ActiveTasksViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Активные задачи",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: _primaryColor,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: _primaryColor),
              onPressed: () => vm.loadTasks(),
              tooltip: 'Обновить задачи',
            ),
        ],
      ),
    );
  }
}

class _EmptyTasksState extends StatelessWidget {
  final VoidCallback onRefresh;
  
  const _EmptyTasksState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_turned_in_outlined,
                size: 64,
                color: Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Нет активных задач',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'В данный момент все задачи выполнены или отсутствуют на вашей точке.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Проверить снова', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
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
                  onTap: () {
                    context.pushNamed(
                      'boss_panel_assignment_details', 
                      extra: {
                        'workerId': assignee.employeeId, 
                        'taskId': task.id,
                      }
                    );
                  },
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