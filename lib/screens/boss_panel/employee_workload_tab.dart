import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'employee_workload_viewmodel.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class EmployeeWorkloadTab extends ConsumerWidget {
  const EmployeeWorkloadTab({super.key});

  // Константы дизайна для единства стиля
  static const Color _primaryColor = Color(0xFF8B5CF6); // Чуть более яркий фиолетовый
  static const Color _bgDark = Color(0xFF0F0F12);
  static const Color _cardBg = Color(0xFF1C1C1E);
  static const Color _accentBg = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeWorkloadProvider);
    final vm = ref.read(employeeWorkloadProvider.notifier);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor, strokeWidth: 3));
    }

    return Container(
      color: _bgDark,
      child: Column(
        children: [
          _buildHeader(context, state, vm),
          if (state.employees.any((e) => e.totalComplexity > 0)) 
            _buildModernChart(state, vm),
          Expanded(
            child: state.employees.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) => _EmployeeCard(emp: state.employees[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WorkloadState state, EmployeeWorkloadViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      child: Row(
        children: [
          const Text(
            "Команда",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: _accentBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<WorkloadSortType>(
              icon: const Icon(Icons.tune_rounded, color: _primaryColor),
              offset: const Offset(0, 45),
              color: _cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: vm.changeSort,
              itemBuilder: (context) => [
                _buildSortItem(WorkloadSortType.complexity, Icons.speed, "По нагрузке"),
                _buildSortItem(WorkloadSortType.tasks, Icons.list_alt, "По задачам"),
                _buildSortItem(WorkloadSortType.name, Icons.sort_by_alpha, "По алфавиту"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<WorkloadSortType> _buildSortItem(WorkloadSortType value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white60),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildModernChart(WorkloadState state, EmployeeWorkloadViewModel vm) {
    final chartData = state.employees.where((e) => e.totalComplexity > 0).toList();
    final double chartContentWidth = chartData.length * 70.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_cardBg, _cardBg.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: const Text("РАСПРЕДЕЛЕНИЕ НАГРУЗКИ", 
              style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            trailing: Icon(
              state.isChartExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, 
              color: _primaryColor
            ),
            onTap: vm.toggleChart,
          ),
          if (state.isChartExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: chartContentWidth < 320 ? 320 : chartContentWidth,
                  height: 160,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BarChart(
                    BarChartData(
                      barGroups: chartData.asMap().entries.map((e) {
                        return BarChartGroupData(x: e.key, barRods: [
                          BarChartRodData(
                            toY: e.value.totalComplexity,
                            gradient: const LinearGradient(
                              colors: [_primaryColor, Color(0xFFA78BFA)],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                            width: 14,
                            borderRadius: BorderRadius.circular(4),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 10, // Max complexity baseline
                              color: Colors.white.withOpacity(0.03),
                            ),
                          )
                        ]);
                      }).toList(),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= chartData.length) return const SizedBox();
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  chartData[value.toInt()].fullName.split(' ').first,
                                  style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off_rounded, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text("Нет сотрудников на смене", style: TextStyle(color: Colors.white38, fontSize: 16)),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeWorkloadDto emp;
  const _EmployeeCard({required this.emp});

  static const Color _primaryColor = Color(0xFF8B5CF6);
  static const Color _cardBg = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: emp.isAtWork ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: emp.isAtWork ? Colors.white.withOpacity(0.08) : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildAdvancedAvatar(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emp.fullName,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          _buildStatusIndicator(),
                        ],
                      ),
                    ),
                    if (emp.isAtWork) _buildComplexityBadge(),
                  ],
                ),
              ),
              if (emp.isAtWork && emp.activeTasks.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      ...emp.activeTasks.map((t) => _buildTaskTile(t)),
                    ],
                  ),
                )
              ] else if (emp.isAtWork)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Свободен для новых задач", 
                    style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w500)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedAvatar() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: emp.isAtWork 
            ? [_primaryColor.withOpacity(0.2), _primaryColor.withOpacity(0.05)]
            : [Colors.white10, Colors.transparent],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: emp.isAtWork ? _primaryColor.withOpacity(0.3) : Colors.white10,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          emp.fullName.isNotEmpty ? emp.fullName[0].toUpperCase() : "?",
          style: TextStyle(
            color: emp.isAtWork ? _primaryColor : Colors.white24,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: emp.isAtWork ? Colors.greenAccent : Colors.white24,
            shape: BoxShape.circle,
            boxShadow: emp.isAtWork ? [
              BoxShadow(color: Colors.greenAccent.withOpacity(0.4), blurRadius: 4, spreadRadius: 1)
            ] : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          emp.isAtWork ? 'На смене' : 'Вне смены',
          style: TextStyle(
            color: emp.isAtWork ? Colors.white60 : Colors.white24,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildComplexityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            emp.totalComplexity.toStringAsFixed(1),
            style: const TextStyle(color: _primaryColor, fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const Text("LOAD", style: TextStyle(color: _primaryColor, fontSize: 8, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildTaskTile(ActiveTaskBriefDto task) {
    final statusColor = _getStatusColor(task.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _buildTaskIcon(task.taskType),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _mapTaskType(task.taskType),
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
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
          _buildTaskStatus(task.status, statusColor),
        ],
      ),
    );
  }

  Widget _buildTaskIcon(String type) {
    IconData icon;
    switch (type) {
      case 'ReturnToStock': icon = Icons.assignment_return_rounded; break;
      case 'OrderAssembly': icon = Icons.inventory_2_rounded; break;
      case 'OrderHandover': icon = Icons.front_hand_rounded; break;
      default: icon = Icons.task_alt_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: Colors.white70, size: 18),
    );
  }

  Widget _buildTaskStatus(String status, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _mapStatus(status).toUpperCase(),
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 3,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
          child: LinearProgressIndicator(
            value: status == 'InProgress' ? 0.6 : (status == 'Completed' ? 1.0 : 0.2),
            backgroundColor: Colors.transparent,
            color: color,
          ),
        )
      ],
    );
  }

  // Вспомогательные методы маппинга
  String _mapTaskType(String type) {
    final Map<String, String> types = {
      'ReturnToStock': 'Возврат',
      'OrderAssembly': 'Сборка заказа',
      'OrderHandover': 'Выдача',
    };
    return types[type] ?? type;
  }

  String _mapStatus(String status) {
    final Map<String, String> statuses = {
      'InProgress': 'В деле',
      'Paused': 'Пауза',
      'Completed': 'Готово',
      'Assigned': 'Ждет',
    };
    return statuses[status] ?? status;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'InProgress': return const Color(0xFF60A5FA);
      case 'Paused': return const Color(0xFFFBBF24);
      case 'Completed': return const Color(0xFF34D399);
      default: return Colors.white30;
    }
  }
}