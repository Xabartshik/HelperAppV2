import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'all_tasks_viewmodel.dart';
import '../../../core/models/boss_panel/boss_panel_models.dart';

class AllTasksTab extends ConsumerWidget {
  const AllTasksTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(allTasksViewModelProvider);
    final vm = ref.read(allTasksViewModelProvider.notifier);

    return Column(
      children: [
        _buildFilters(context, state, vm),
        Expanded(
          child: state.isLoading && state.filteredTasks.isEmpty
              ? const Center(child: CircularProgressIndicator(color: _primaryColor))
              : RefreshIndicator(
                  onRefresh: vm.loadTasks,
                  color: _primaryColor,
                  child: state.filteredTasks.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 100),
                            Center(child: Text("Задачи не найдены", style: TextStyle(color: Colors.white54, fontSize: 16))),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: state.filteredTasks.length,
                          itemBuilder: (context, index) {
                            return _TaskMainCard(task: state.filteredTasks[index]);
                          },
                        ),
                ),
        ),
      ],
    );
  }

  // Строит панель фильтров и сортировки для руководителя
  Widget _buildFilters(BuildContext context, AllTasksState state, AllTasksViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1C1C1E),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2027),
                      builder: (context, child) => Theme(
                        data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: _primaryColor)),
                        child: child!,
                      ),
                    );
                    vm.updateDateRange(range);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: _primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.dateRange == null 
                              ? "Период: Все" 
                              : "${DateFormat('dd.MM').format(state.dateRange!.start)} - ${DateFormat('dd.MM').format(state.dateRange!.end)}",
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (state.dateRange != null)
                          GestureDetector(
                            onTap: () => vm.updateDateRange(null),
                            child: const Icon(Icons.close, size: 16, color: Colors.white54),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: _primaryColor, strokeWidth: 2)),
                )
              else
                IconButton(icon: const Icon(Icons.refresh, color: _primaryColor), onPressed: vm.loadTasks),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2C2C2E),
                      value: state.selectedEmployeeId,
                      hint: const Text('Все сотрудники', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      icon: const Icon(Icons.person_search, color: _primaryColor, size: 18),
                      items: [
                        const DropdownMenuItem<int?>(value: null, child: Text('Все сотрудники', style: TextStyle(color: Colors.white, fontSize: 13))),
                        ...state.branchEmployees.map((e) => DropdownMenuItem<int?>(
                          value: e.employeeId,
                          child: Text(e.fullName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ))
                      ],
                      onChanged: vm.updateEmployee,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TaskFilterStatus>(
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2C2C2E),
                      value: state.filterStatus,
                      icon: const Icon(Icons.filter_list, color: _primaryColor, size: 18),
                      items: const [
                        DropdownMenuItem(value: TaskFilterStatus.all, child: Text('Все статусы', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskFilterStatus.notStarted, child: Text('Не начатые', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskFilterStatus.uncompleted, child: Text('В процессе', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskFilterStatus.completed, child: Text('Завершенные', style: TextStyle(color: Colors.white, fontSize: 13))),
                      ],
                      onChanged: (val) {
                        if (val != null) vm.updateFilterStatus(val);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<TaskSortType>(
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2C2C2E),
                      value: state.sortType,
                      icon: const Icon(Icons.sort, color: _primaryColor, size: 18),
                      items: const [
                        DropdownMenuItem(value: TaskSortType.newest, child: Text('Сначала новые', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskSortType.oldest, child: Text('Сначала старые', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskSortType.progressDesc, child: Text('По прогрессу (макс)', style: TextStyle(color: Colors.white, fontSize: 13))),
                        DropdownMenuItem(value: TaskSortType.progressAsc, child: Text('По прогрессу (мин)', style: TextStyle(color: Colors.white, fontSize: 13))),
                      ],
                      onChanged: (val) {
                        if (val != null) vm.updateSortType(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskMainCard extends StatelessWidget {
  final BossPanelTaskCardDto task;

  const _TaskMainCard({required this.task});

  String _mapTaskType(String type) {
    switch (type) {
      case 'ReturnToStock': return 'Возврат на полку';
      case 'OrderAssembly': return 'Сборка товара';
      case 'OrderHandover': return 'Выдача товара';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final isCompleted = task.overallProgressPercentage == 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(_mapTaskType(task.taskType), style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2), 
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Text(
                  isCompleted ? 'Завершена' : 'В работе', 
                  style: TextStyle(
                    color: isCompleted ? Colors.greenAccent : Colors.orangeAccent, 
                    fontSize: 12, 
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.white54),
              const SizedBox(width: 4),
              Text('Старт: ${dateFormat.format(task.createdAt)}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          if (task.expectedCompletionDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, size: 14, color: Colors.white54),
                  const SizedBox(width: 4),
                  Text('Завершено: ${dateFormat.format(task.expectedCompletionDate!)}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: task.overallProgressPercentage / 100,
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? Colors.green : const Color(0xFF7C3AED)),
            ),
          ),
          const SizedBox(height: 12),
          if (task.assignees.isNotEmpty) ...[
            const Divider(color: Colors.white10),
            const SizedBox(height: 8),
            const Text('Назначения:', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...task.assignees.map((a) => InkWell(
              onTap: () {
                context.pushNamed(
                  'boss_panel_assignment_details',
                  extra: {'workerId': a.employeeId, 'taskId': task.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Color(0xFF7C3AED)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(a.fullName, style: const TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.underline))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(4)),
                      child: Text('${a.completedVolume}/${a.assignedVolume}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }
}
