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
            ? const Center(child: Text("Нет сотрудников на смене", style: TextStyle(color: Colors.white54)))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: state.employees.length,
                itemBuilder: (context, index) => _EmployeeExpansionCard(emp: state.employees[index]),
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
          const Text("На смене", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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

class _EmployeeExpansionCard extends StatelessWidget {
  final EmployeeWorkloadDto emp;
  const _EmployeeExpansionCard({required this.emp});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: _buildAvatar(),
          title: Text(emp.fullName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: _buildSubtitles(),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: const Color(0xFF7C3AED),
          collapsedIconColor: Colors.white54,
          children: [
            const Divider(color: Colors.white10, height: 20),
            if (emp.activeTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Нет активных задач", style: TextStyle(color: Colors.white30, fontSize: 13)),
              )
            else
              ...emp.activeTasks.map((t) => _buildEnhancedTaskItem(t)),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(color: Color(0xFF141414), shape: BoxShape.circle),
      child: Center(
        child: Text(
          emp.fullName.isNotEmpty ? emp.fullName[0] : "?",
          style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSubtitles() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          _buildBadge(Icons.assignment_outlined, "${emp.activeTasksCount} задач"),
          const SizedBox(width: 12),
          _buildBadge(Icons.bolt, "${emp.totalComplexity.toStringAsFixed(1)} ед."),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white54),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildEnhancedTaskItem(ActiveTaskBriefDto task) {
    final statusColor = _getStatusColor(task.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Сбалансированные отступы
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withOpacity(0.1), 
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(_getTaskIcon(task.taskType), color: const Color(0xFF7C3AED), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Убираем лишнее пространство сверху/снизу
              children: [
                // ТЕПЕРЬ ТИП ЗАДАЧИ — ГЛАВНЫЙ И КРУПНЫЙ
                Text(
                  _mapTaskType(task.taskType), 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 15, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 1), // Минимальный зазор между строками
                // TITLE СТАЛ ПОДЗАГОЛОВКОМ
                Text(
                  task.title, 
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _mapStatus(task.status),
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 45,
                height: 3,
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
}