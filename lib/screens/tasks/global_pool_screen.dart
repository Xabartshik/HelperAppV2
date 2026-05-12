import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';
import '../widgets/pool_summary_widget.dart'; // Импорт провайдера из предыдущего шага
import '../home/main_viewmodel.dart'; // Для обновления главного экрана

class GlobalPoolScreen extends ConsumerWidget {
  const GlobalPoolScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(globalPoolTasksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Общий пул склада'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(globalPoolTasksProvider),
          )
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
        error: (e, _) => Center(child: Text('Ошибка: $e', style: const TextStyle(color: Colors.redAccent))),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('Нет доступных задач', style: TextStyle(color: Colors.white54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                color: const Color(0xFF2C2C2E),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Приоритет: ${task.priority}', style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (task.description != null) 
                        Text(task.description!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C3AED),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () async {
                            final workerId = ref.read(currentUserProvider)?.employeeId;
                            if (workerId == null) return;

                            try {
                              // Забираем задачу
                              await ref.read(apiClientProvider).claimTaskFromPoolAsync(task.taskId, workerId);
                              
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Задача успешно взята!'), backgroundColor: Colors.green)
                                );
                                // Обновляем "Мои задачи" на главном экране
                                ref.read(mainViewModelProvider.notifier).refreshTasks();
                                // Возвращаемся назад
                                context.pop();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.redAccent)
                                );
                              }
                            }
                          },
                          child: const Text('ВЗЯТЬ СЕБЕ', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}