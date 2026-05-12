import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/tasks/mobile_base_task_dto.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import 'global_pool_tab_viewmodel.dart';

class GlobalPoolTab extends ConsumerWidget {
  const GlobalPoolTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(globalPoolTabViewModelProvider);
    final vm = ref.read(globalPoolTabViewModelProvider.notifier);

    if (state.isLoading && state.poolTasks.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor));
    }

    if (state.poolTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            const Text('Пул задач пуст', style: TextStyle(color: Colors.white54, fontSize: 16)),
            TextButton(
              onPressed: () => vm.loadDataAsync(),
              child: const Text('Обновить', style: TextStyle(color: _primaryColor)),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => vm.loadDataAsync(),
      color: _primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.poolTasks.length,
        itemBuilder: (context, index) {
          final task = state.poolTasks[index];
          return _PoolTaskCard(
            task: task,
            employees: state.availableEmployees,
            onAssign: (employeeId) async {
              final success = await vm.assignTaskToEmployee(task.taskId, employeeId);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Задача успешно назначена!'), backgroundColor: Colors.green),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _PoolTaskCard extends StatelessWidget {
  final MobileBaseTaskDto task;
  final List<AvailableEmployeeDto> employees;
  final Function(int employeeId) onAssign;

  const _PoolTaskCard({required this.task, required this.employees, required this.onAssign});

  @override
  Widget build(BuildContext context) {
    final deadlineText = task.deadline != null 
        ? DateFormat('HH:mm').format(task.deadline!.toLocal()) 
        : 'Без дедлайна';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.priority > 5 ? Colors.orange : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title, 
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  deadlineText, 
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(task.taskType, style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 13)),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(task.description!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.person_add_alt_1, size: 18),
              label: const Text('Назначить сотрудника'),
              onPressed: () => _showAssignmentBottomSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showAssignmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        if (employees.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('Нет сотрудников на смене', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Выберите исполнителя', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final emp = employees[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF7C3AED).withOpacity(0.2),
                      child: Text(emp.fullName[0], style: const TextStyle(color: Color(0xFF7C3AED))),
                    ),
                    title: Text(emp.fullName, style: const TextStyle(color: Colors.white)),
                    subtitle: Text('Активных задач: ${emp.activeTasksCount}', style: const TextStyle(color: Colors.white54)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                    onTap: () {
                      Navigator.pop(context);
                      onAssign(emp.employeeId);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}