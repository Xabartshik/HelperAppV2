  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:fl_chart/fl_chart.dart';
  import 'employee_workload_viewmodel.dart';
  import '../../core/models/boss_panel/boss_panel_models.dart';

  class EmployeeWorkloadTab extends ConsumerWidget {
    const EmployeeWorkloadTab({super.key});

    static const Color _primaryColor = Color(0xFF7C3AED);
    static const Color _cardBg = Color(0xFF2C2C2E);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final state = ref.watch(employeeWorkloadProvider);
      final vm = ref.read(employeeWorkloadProvider.notifier);

      if (state.isLoading) {
        return const Center(child: CircularProgressIndicator(color: _primaryColor));
      }

      return Column(
        children: [
          _buildHeader(context, state, vm),
          if (state.employees.any((e) => e.totalComplexity > 0)) 
            _buildScrollableChart(state, vm),
          Expanded(
            child: state.employees.isEmpty 
              ? const Center(child: Text("Нет сотрудников", style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) => _EmployeeCard(emp: state.employees[index]),
                ),
          ),
        ],
      );
    }

    Widget _buildHeader(BuildContext context, WorkloadState state, EmployeeWorkloadViewModel vm) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Сотрудники", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            PopupMenuButton<WorkloadSortType>(
              icon: const Icon(Icons.sort, color: _primaryColor),
              color: _cardBg,
              onSelected: vm.changeSort,
              itemBuilder: (context) => [
                const PopupMenuItem(value: WorkloadSortType.complexity, child: Text("По нагрузке", style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: WorkloadSortType.tasks, child: Text("По числу задач", style: TextStyle(color: Colors.white))),
                const PopupMenuItem(value: WorkloadSortType.name, child: Text("По алфавиту", style: TextStyle(color: Colors.white))),
              ],
            ),
          ],
        ),
      );
    }

    Widget _buildScrollableChart(WorkloadState state, EmployeeWorkloadViewModel vm) {
      final chartData = state.employees.where((e) => e.totalComplexity > 0).toList();
      final double chartContentWidth = chartData.length * 80.0;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              dense: true,
              title: const Text("Распределение нагрузки", style: TextStyle(color: Colors.white70, fontSize: 13)),
              trailing: Icon(state.isChartExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54),
              onTap: vm.toggleChart,
            ),
            if (state.isChartExpanded)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: chartContentWidth < 300 ? 300 : chartContentWidth,
                    height: 180,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: BarChart(
                      BarChartData(
                        barGroups: chartData.asMap().entries.map((e) {
                          return BarChartGroupData(x: e.key, barRods: [
                            BarChartRodData(
                              toY: e.value.totalComplexity.toDouble(),
                              color: _primaryColor,
                              width: 20,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            )
                          ]);
                        }).toList(),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                if (value.toInt() >= chartData.length) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    chartData[value.toInt()].fullName.split(' ').first,
                                    style: const TextStyle(color: Colors.white54, fontSize: 10),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  class _EmployeeCard extends StatelessWidget {
    final EmployeeWorkloadDto emp;
    const _EmployeeCard({required this.emp});

    static const Color _primaryColor = Color(0xFF7C3AED);
    static const Color _cardBg = Color(0xFF2C2C2E);

    @override
    Widget build(BuildContext context) {
      return Opacity(
        opacity: emp.isAtWork ? 1.0 : 0.4,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: emp.isAtWork ? Colors.white10 : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: emp.isAtWork ? Colors.greenAccent : Colors.grey,
                      shape: BoxShape.circle,
                      boxShadow: emp.isAtWork 
                          ? [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.5), blurRadius: 8)]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emp.fullName,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emp.isAtWork ? 'На смене' : 'Отдыхает / Вне смены',
                          style: TextStyle(
                            color: emp.isAtWork ? Colors.white70 : Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (emp.isAtWork)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${emp.activeTasksCount}',
                          style: const TextStyle(color: _primaryColor, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text('задач', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                ],
              ),
              
 if (emp.isAtWork && emp.activeTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),
              // Оборачиваем элементы задач в InkWell
              ...emp.activeTasks.map((task) {
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // 1. Создаем DTO для попапа, так как Brief-модель не содержит всех деталей
                    final taskDto = BossPanelTaskCardDto(
                      id: task.taskId,
                      title: task.title,
                      taskType: task.taskType,
                      createdAt: DateTime.now(), // Заглушка, у Brief-модели нет этого поля
                    );

                    // 2. Создаем прогресс сотрудника (объемы ставим 1 к 1 или 0 к 1)
                    final assigneeDto = TaskAssigneeProgressDto(
                      employeeId: emp.employeeId,
                      fullName: emp.fullName,
                      status: task.status,
                      assignedVolume: 1, 
                      completedVolume: task.status.toLowerCase() == 'completed' ? 1 : 0,
                    );

                    showAssigneeDetailsSheet(context, taskDto, assigneeDto);
                  },
                  // Передаем саму ActiveTaskBriefDto в метод отрисовки UI
                  child: _buildEnhancedTaskItem(task),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }

  // Принимаем ActiveTaskBriefDto вместо BossPanelTaskCardDto
  Widget _buildEnhancedTaskItem(ActiveTaskBriefDto task) {
    final statusColor = _getStatusColor(task.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.1), 
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(_getTaskIcon(task.taskType), color: _primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _mapTaskType(task.taskType), 
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  task.title, 
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _mapStatus(task.status),
                style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: task.status.toLowerCase() == 'inprogress' 
                      ? 0.7 
                      : (task.status.toLowerCase() == 'completed' ? 1.0 : 0.1),
                  child: Container(decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(2))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

    String _mapTaskType(String type) {
      switch (type) {
        case 'ReturnToStock': return 'Возврат на полку';
        case 'OrderAssembly': return 'Сборка товара';
        case 'OrderHandover': return 'Выдача товара';
        default: return type;
      }
    }

    String _mapStatus(String status) {
      switch (status.toLowerCase()) {
        case 'assigned': return 'Назначена';
        case 'inprogress': return 'В процессе';
        case 'paused': return 'На паузе';
        case 'completed': return 'Завершена';
        case 'cancelled': return 'Отменена';
        default: return status;
      }
    }

    IconData _getTaskIcon(String type) {
      switch (type) {
        case 'ReturnToStock': return Icons.assignment_return_outlined;
        case 'OrderAssembly': return Icons.inventory_2_outlined;
        case 'OrderHandover': return Icons.handyman_outlined;
        default: return Icons.task_outlined;
      }
    }

    Color _getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'inprogress': return Colors.blueAccent;
        case 'paused': return Colors.orangeAccent;
        case 'completed': return Colors.greenAccent;
        case 'cancelled': return Colors.redAccent;
        default: return Colors.white38;
      }
    }
  }

  // Метод вызова модального окна вынесен в глобальную область
  void showAssigneeDetailsSheet(
    BuildContext context,
    BossPanelTaskCardDto task,
    TaskAssigneeProgressDto assignee,
  ) {
    const Color primaryColor = Color(0xFF7C3AED);
    const Color bgGray900 = Color(0xFF2C2C2E);

    final bool isExpress = task.title.toLowerCase().contains('express') ||
        task.taskType.toLowerCase().contains('express');

    final double progress = assignee.assignedVolume > 0
        ? (assignee.completedVolume / assignee.assignedVolume).clamp(0.0, 1.0)
        : 0.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: bgGray900,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (isExpress)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orangeAccent),
                      ),
                      child: const Text(
                        'EXPRESS\nпрямая выдача',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Тип: ${task.taskType}', style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 20,
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                assignee.fullName,
                                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Статус: ${assignee.status}',
                                style: TextStyle(
                                  color: assignee.status.toLowerCase() == 'inprogress' ? Colors.greenAccent : Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Прогресс сборки/выдачи:', style: TextStyle(color: Colors.white54, fontSize: 13)),
                        Text('${assignee.completedVolume} / ${assignee.assignedVolume}', 
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Закрыть', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }