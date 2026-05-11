import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'boss_panel_viewmodel.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';

class ActiveTasksPage extends ConsumerWidget {
  const ActiveTasksPage({super.key});

  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _accentColor = Color(0xFF7C3AED);
  static const Color _cardColor = Color(0xFF1C1C1E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bossPanelViewModelProvider);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: const Text(
          "Активные задачи",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        backgroundColor: _bgOffBlack,
        elevation: 0,
        centerTitle: true,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: _accentColor))
          : state.activeTasks.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => ref.read(bossPanelViewModelProvider.notifier).loadDataAsync(),
                  color: _accentColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: state.activeTasks.length,
                    itemBuilder: (context, index) => _TaskExpansionCard(task: state.activeTasks[index]),
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          const Text("Активных задач пока нет", style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
}

class _TaskExpansionCard extends StatelessWidget {
  final BossPanelTaskCardDto task;

  const _TaskExpansionCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Убираем стандартные рамки ExpansionTile
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconColor: const Color(0xFF7C3AED),
          collapsedIconColor: Colors.white54,
          title: Row(
            children: [
              _TypeBadge(type: task.taskType),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _ProgressBar(percentage: task.overallProgressPercentage),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white10, height: 24),
                  
                  // Инфо-блок: Время и Дедлайн
                  _buildDetailInfo(
                    Icons.history_toggle_off_rounded,
                    "Создана",
                    DateFormat('HH:mm (dd.MM.yy)').format(task.createdAt),
                  ),
                  
                  if (task.expectedCompletionDate != null)
                    _buildDetailInfo(
                      Icons.event_available_outlined,
                      "Ожидается до",
                      DateFormat('HH:mm (dd.MM.yy)').format(task.expectedCompletionDate!),
                    ),

                  const SizedBox(height: 16),
                  const Text(
                    "НАЗНАЧЕННЫЕ ИСПОЛНИТЕЛИ",
                    style: TextStyle(
                      color: Color(0xFF7C3AED),
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Список сотрудников
                  ...task.assignees.map((a) => _AssigneeDetailRow(assignee: a)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white38),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(color: Colors.white38, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int percentage;
  const _ProgressBar({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Общий прогресс", style: TextStyle(color: Colors.white54, fontSize: 12)),
            Text("$percentage%", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.white10,
            color: const Color(0xFF7C3AED),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _AssigneeDetailRow extends StatelessWidget {
  final TaskAssigneeProgressDto assignee;
  const _AssigneeDetailRow({required this.assignee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFF7C3AED).withOpacity(0.2),
            child: Text(
              assignee.fullName.isNotEmpty ? assignee.fullName[0].toUpperCase() : "?",
              style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assignee.fullName, style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text(
                  _translateStatus(assignee.status),
                  style: TextStyle(color: _getStatusColor(assignee.status), fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${assignee.completedVolume} / ${assignee.assignedVolume}",
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const Text("ед. товара", style: TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'InProgress': return 'В процессе';
      case 'Completed': return 'Завершено';
      case 'Paused': return 'На паузе';
      default: return 'Ожидание';
    }
  }

  Color _getStatusColor(String status) {
    if (status == 'InProgress') return Colors.blueAccent;
    if (status == 'Completed') return Colors.greenAccent;
    return Colors.white38;
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF7C3AED).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF7C3AED).withOpacity(0.3)),
      ),
      child: Text(
        type.toUpperCase(),
        style: const TextStyle(color: Color(0xFF7C3AED), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}