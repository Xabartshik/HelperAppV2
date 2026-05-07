import 'dart:async'; // Обязательный импорт для таймера
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/tasks/mobile_base_task_dto.dart';
import '../../core/network/api_client.dart';
import '../../core/services/auth_service.dart';

// Провайдер, который скачивает ничейные задачи для филиала
final globalPoolTasksProvider = FutureProvider.autoDispose<List<MobileBaseTaskDto>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser?.branchId == null) return [];
  
  // Добавленный код Варианта 1: Настройка таймера автообновления раз в 5 минут
  final timer = Timer.periodic(const Duration(minutes: 5), (t) {
    ref.invalidateSelf(); // Заставляет провайдер перезагрузить данные
  });

  // Очистка таймера при уничтожении провайдера
  ref.onDispose(() => timer.cancel());

  final client = ref.watch(apiClientProvider);
  return await client.getGlobalPoolTasksAsync(currentUser!.branchId!);
});

class PoolSummaryWidget extends ConsumerWidget {
  const PoolSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(globalPoolTasksProvider);

    return tasksAsync.when(
      loading: () => const SizedBox(height: 60, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
      data: (tasks) {
        if (tasks.isEmpty) return const SizedBox.shrink(); // Прячем виджет, если пул пуст

        // Ищем задачи с высоким приоритетом или близким дедлайном (например, < 6 часов)
        final now = DateTime.now().toUtc();
        final hasUrgent = tasks.any((t) {
          if (t.priority >= 2) return true; // Высокий приоритет
          if (t.deadline != null) {
            final left = t.deadline!.difference(now);
            return left.inHours < 3; // Горящий дедлайн
          }
          return false;
        });

        // Если есть срочные - красим в оранжевый, иначе в нейтральный primary
        final bgColor = hasUrgent ? Colors.orange.shade900 : const Color(0xFF7C3AED).withOpacity(0.8);
        final iconColor = hasUrgent ? Colors.yellowAccent : Colors.white;

        return GestureDetector(
          onTap: () async {
            // Переходим на экран списка и ждем возврата (чтобы обновить)
            await context.push('/global-pool');
            ref.invalidate(globalPoolTasksProvider); // Обновляем индикатор
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: hasUrgent ? Colors.orange : Colors.transparent, width: 2),
              boxShadow: [
                BoxShadow(color: bgColor.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 3))
              ]
            ),
            child: Row(
              children: [
                Icon(hasUrgent ? Icons.warning_amber_rounded : Icons.list_alt, color: iconColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('ОБЩИЙ ПУЛ ЗАДАЧ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Доступно задач: ${tasks.length}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16)
              ],
            ),
          ),
        );
      },
    );
  }
}