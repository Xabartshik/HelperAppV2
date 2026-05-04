import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/screens/boss_panel/courier_route_builder_screen.dart';
import 'boss_panel_viewmodel.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class BossPanelPage extends ConsumerWidget {
  const BossPanelPage({super.key});

  // Константы дизайна[cite: 1]
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bossPanelViewModelProvider);
    final vm = ref.read(bossPanelViewModelProvider.notifier);

    // Список разделов для Drawer[cite: 1]
// Список разделов для Drawer
    final List<Map<String, dynamic>> destinations = [
      {'title': 'Активные задачи', 'icon': Icons.assignment_outlined},
      {'title': 'Активные сотрудники', 'icon': Icons.people_outline},
      {'title': 'Маршруты курьеров', 'icon': Icons.local_shipping_outlined}, // <-- ДОБАВЛЕНО
      {'title': 'Аналитика (WIP)', 'icon': Icons.bar_chart_rounded},
    ];

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: Text(destinations[state.currentTabIndex]['title']),
        backgroundColor: _bgGray950,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildNavigationDrawer(context, state, vm, destinations),
      body: state.isLoading && state.activeTasks.isEmpty && state.employeeWorkloads.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : RefreshIndicator(
              onRefresh: () => vm.loadDataAsync(),
              color: _primaryColor,
              child: _buildBody(state, vm),
            ),
    );
  }

  /// Боковое меню[cite: 1]
  Widget _buildNavigationDrawer(
    BuildContext context, 
    BossPanelState state, 
    BossPanelViewModel vm, 
    List<Map<String, dynamic>> destinations
  ) {
    return Drawer(
      backgroundColor: _bgGray950,
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: _bgOffBlack),
            child: Center(
              child: Text(
                'TaskControl\nManagement',
                textAlign: TextAlign.center,
                style: TextStyle(color: _primaryColor, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: destinations.length,
              itemBuilder: (context, i) {
                final bool isSelected = state.currentTabIndex == i;
                return ListTile(
                  leading: Icon(
                    destinations[i]['icon'], 
                    color: isSelected ? _primaryColor : Colors.white54
                  ),
                  title: Text(
                    destinations[i]['title'],
                    style: TextStyle(color: isSelected ? Colors.white : Colors.white54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  selected: isSelected,
                  selectedTileColor: _bgGray900,
                  onTap: () {
                    vm.setTabIndex(i);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BossPanelState state, BossPanelViewModel vm) {
    switch (state.currentTabIndex) {
      case 0:
        return _buildTasksList(state.activeTasks);
      case 1:
        return _buildEmployeesList(state.employeeWorkloads);
      case 2:
        return const CourierRouteBuilderScreen(); 
      default:
        return const Center(
          child: Text('Раздел находится в разработке', style: TextStyle(color: Colors.white54)),
        );
    }
  }

  Widget _buildTasksList(List<BossPanelTaskCardDto> tasks) {
    if (tasks.isEmpty) return const _EmptyState(message: 'Нет активных задач');
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _TaskCard(task: tasks[index]),
    );
  }

  Widget _buildEmployeesList(List<EmployeeWorkloadDto> workloads) {
    if (workloads.isEmpty) return const _EmptyState(message: 'Сотрудники не найдены');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: workloads.length,
      itemBuilder: (context, index) => _EmployeeCard(emp: workloads[index]),
    );
  }
}

/// Компонент карточки задачи[cite: 1]
class _TaskCard extends StatelessWidget {
  final BossPanelTaskCardDto task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
              Text('${task.overallProgressPercentage}%', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(task.taskType, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: task.progressValue,
            color: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFF141414),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 12),
          ...task.assignees.map((a) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                const Icon(Icons.person_pin_rounded, size: 14, color: Color(0xFF7C3AED)),
                const SizedBox(width: 6),
                Text(a.fullName, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const Spacer(),
                Text(a.status, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

/// Компонент карточки сотрудника[cite: 1]
class _EmployeeCard extends StatelessWidget {
  final EmployeeWorkloadDto emp;
  const _EmployeeCard({required this.emp});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: emp.isAtWork ? Colors.green : Colors.grey, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.fullName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(emp.isAtWork ? 'На смене' : 'Отсутствует', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            children: [
              Text('${emp.activeTasksCount}', style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('задач', style: TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: const TextStyle(color: Colors.white54)));
  }
}