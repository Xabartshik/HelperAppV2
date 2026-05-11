import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'employee_workload_viewmodel.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class EmployeeWorkloadTab extends ConsumerWidget {
  const EmployeeWorkloadTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _cardBg = Color(0xFF2C2C2E);
  static const Color _accentBg = Color(0xFF1C1C1E);

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
                            toY: e.value.totalComplexity,
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
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Индикатор статуса
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: emp.isAtWork ? Colors.greenAccent : Colors.grey,
                    shape: BoxShape.circle,
                    boxShadow: emp.isAtWork 
                        ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 8)]
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                        style: const TextStyle(
                          color: _primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'задач',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
              ],
            ),
            
            // Список задач только для тех, кто на смене
            if (emp.isAtWork && emp.activeTasks.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 12),
              ...emp.activeTasks.map((t) => _buildEnhancedTaskItem(t)),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedTaskItem(ActiveTaskBriefDto task) {
    final statusColor = _getStatusColor(task.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1), 
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
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 14, 
                    fontWeight: FontWeight.bold,
                  ),
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
                  widthFactor: task.status == 'InProgress' ? 0.7 : (task.status == 'Completed' ? 1.0 : 0.1),
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
    switch (status) {
      case 'Assigned': return 'Назначена';
      case 'InProgress': return 'В процессе';
      case 'Paused': return 'На паузе';
      case 'Completed': return 'Завершена';
      case 'Cancelled': return 'Отменена';
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
    switch (status) {
      case 'InProgress': return Colors.blueAccent;
      case 'Paused': return Colors.orangeAccent;
      case 'Completed': return Colors.greenAccent;
      case 'Cancelled': return Colors.redAccent;
      default: return Colors.white38;
    }
  }
}