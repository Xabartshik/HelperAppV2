import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'main_viewmodel.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/tasks/task_card_vm.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainViewModelProvider);
    final viewModel = ref.read(mainViewModelProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    final isBoss = currentUser?.role == 'Admin' || currentUser?.role == 'Supervisor';

    return Scaffold(
      backgroundColor: const Color(0xFF141414), // _bgOffBlack
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFF1C1C1E), // _bgGray950
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser?.fullName ?? 'Пользователь',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Должность: ${currentUser?.role ?? ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (isBoss)
                        ElevatedButton(
                          onPressed: () {
                            // Перейти в панель босса
                            context.push('/boss-panel');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Панель\nруководителя', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => viewModel.logout(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Выход', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // No Network Alert
            if (!state.hasNetwork)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: const Color(0xFFFF6B6B),
                child: const Text(
                  '⚠️ Нет подключения к сети',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

            // Refresh Button & Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: const Color(0xFF1C1C1E), // _bgGray950
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Мои задачи',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: state.isBusy ? null : () => viewModel.refreshTasks(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Обновить', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            // Loading Indicator
            if (state.isBusy)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
              ),

            // Error message 
            if (state.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Color(0xFFFF6B6B)),
                  textAlign: TextAlign.center,
                ),
              ),

            // Tasks List
            Expanded(
              child: state.taskCards.isEmpty && !state.isBusy
                  ? const Center(
                      child: Text(
                        'Задач не найдено',
                        style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.taskCards.length,
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemBuilder: (context, index) {
                        final task = state.taskCards[index];
                        return _buildTaskCard(context, ref, task);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskCardVm task) {
    return GestureDetector(
      onTap: () {
        if (task.kind.toLowerCase() == 'inventory') {
          // Передаем workerId и assignmentId через extra, как ожидает роутер
          final currentUser = ref.read(currentUserProvider);
          context.push('/inventory-details', extra: {
            'workerId': currentUser?.employeeId ?? 0,
            'assignmentId': task.navigationId,
          });
        } else if (task.kind.toLowerCase() == 'orderassembly') {
          // Переходим на экран сборки заказа
          context.push('/order-assembly/active', extra: {
            'assignmentId': task.navigationId,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не реализована навигация для типа задачи: ${task.kind}')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E), // _bgGray900
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
              Text(
                task.subtitle!,
                style: const TextStyle(fontSize: 12, color: Color(0xFFA1A1AA)),
              ),
              const SizedBox(height: 10),
            ],

            // Status / Metric / Date
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Статус: ${task.statusText}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF7C3AED)),
                  ),
                ),
                if (task.primaryMetric != null && task.primaryMetric!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      task.primaryMetric!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Text(
                  _formatDate(task.createdAt),
                  style: const TextStyle(fontSize: 11, color: Color(0xFFA1A1AA)),
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: task.badges.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414), // _bgOffBlack
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(fontSize: 10, color: Color(0xFFA1A1AA)),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
