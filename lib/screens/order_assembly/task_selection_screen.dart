import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order_assembly/order_assembly_dtos.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';

// ---------------------------------------------------------------------------
// Провайдер для загрузки списка задач
// ---------------------------------------------------------------------------

/// Провайдер для получения задач сборки по userId
final orderAssemblyTasksProvider =
    FutureProvider.autoDispose.family<List<WorkerAssemblyTaskDto>, int>((ref, userId) async {
  final client = ref.watch(apiClientProvider);
  Logger.i('TaskSelectionScreen: загрузка задач для userId=$userId');
  return await client.getOrderAssemblyTasksAsync(userId);
});

// ---------------------------------------------------------------------------
// Экран выбора задачи сборки
// ---------------------------------------------------------------------------

/// DEPRECATED: экран больше не используется как entry-point.
/// Единая точка входа в задачи — общий pending-список на MainPage.
class TaskSelectionScreen extends ConsumerWidget {
  const TaskSelectionScreen({super.key});

  // Цвета в стиле приложения
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем текущего пользователя
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.employeeId ?? 0;

    // Загружаем список задач
    final tasksAsync = ref.watch(orderAssemblyTasksProvider(userId));

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: const Text('Сборка заказов'),
        backgroundColor: _bgGray950,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Кнопка обновления списка
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(orderAssemblyTasksProvider(userId)),
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: tasksAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: _primaryColor),
        ),
        error: (error, _) => _buildErrorState(context, ref, userId, error),
        data: (tasks) => tasks.isEmpty
            ? _buildEmptyState(context, ref, userId)
            : _buildTaskList(context, ref, userId, tasks),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Состояние ошибки
  // ---------------------------------------------------------------------------

  Widget _buildErrorState(BuildContext context, WidgetRef ref, int userId, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Ошибка загрузки задач',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.white54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(orderAssemblyTasksProvider(userId)),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Повторить', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Пустой список задач
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState(BuildContext context, WidgetRef ref, int userId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, color: Colors.white24, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Нет активных задач',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Новые задачи сборки появятся здесь',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(orderAssemblyTasksProvider(userId)),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Обновить', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Список задач
  // ---------------------------------------------------------------------------

  Widget _buildTaskList(BuildContext context, WidgetRef ref, int userId, List<WorkerAssemblyTaskDto> tasks) {
    return RefreshIndicator(
      color: _primaryColor,
      backgroundColor: _bgGray900,
      onRefresh: () async {
        // При pull-to-refresh GO Router сам обновит через invalidate
        // (обрабатывается выше через кнопку обновления в AppBar)
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) => _buildTaskCard(context, ref, userId, tasks[index]),
      ),
    );
  }

Widget _buildTaskCard(BuildContext context, WidgetRef ref, int userId, WorkerAssemblyTaskDto task) {
    // Подсчёт статистики задачи
    final totalItems = task.cellPlacements.fold(0, (s, c) => s + c.items.length);
    final totalCells = task.cellPlacements.length;

    // Форматируем дату
    final createdDate = _formatDate(task.createdDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withValues(alpha: 0.3), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // ВНЕДРЕНИЕ: Вызываем ваш метод обработки нажатия
        onTap: () => _onTaskTapped(context, ref, task, userId),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок задачи
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (task.taskNumber != null && task.taskNumber!.isNotEmpty) 
                          ? task.taskNumber! 
                          : '# ${task.assignmentId}',
                      style: const TextStyle(
                        color: _primaryColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
              const SizedBox(height: 12),
              // Статистика
              Row(
                children: [
                  _buildStatChip(Icons.inventory_2_outlined, '$totalItems товаров'),
                  const SizedBox(width: 10),
                  _buildStatChip(Icons.grid_view_outlined, '$totalCells ячеек'),
                ],
              ),
              const SizedBox(height: 10),
              // Дата создания
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white38, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    createdDate,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Внедренные методы логики
  // ---------------------------------------------------------------------------

  /// Ваш метод с небольшим дополнением (передаем userId для обновления списка)
  void _onTaskTapped(BuildContext context, WidgetRef ref, WorkerAssemblyTaskDto task, int userId) {
    // Предполагается, что в вашей версии WorkerAssemblyTaskDto есть поля isCooperative и partnerName
    if (task.isCooperative == true) { 
      // Показываем предупреждение о тяжелом грузе
      showDialog(
        context: context,
        barrierDismissible: false, // Чтобы не закрыли случайно
        builder: (ctx) => AlertDialog(
          backgroundColor: _bgGray950, // стилизуем под приложение
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
          title: const Text('⚠️ Тяжелый груз!'),
          content: Text(
              'Это кооперативная задача. Вам потребуется тележка.\n\n'
              'Ваш напарник: ${task.partnerName ?? "Неизвестен"}.'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _startTaskWithPartnerSync(context, ref, task, userId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              child: const Text('Я готов (Начать)', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      // Обычная задача - стартуем как раньше
      _startTask(context, ref, task, userId);
    }
  }

  /// Стандартный запуск задачи (перенесено из старого onTap)
  Future<void> _startTask(BuildContext context, WidgetRef ref, WorkerAssemblyTaskDto task, int userId) async {
    Logger.i('TaskSelectionScreen: обычная задача ${task.assignmentId}');
    final result = await context.push('/order-assembly/active', extra: {
      'assignmentId': task.assignmentId,
      'taskId': task.taskId,
      'taskStatusIndex': task.status,
    });
    if (result == true) {
      ref.refresh(orderAssemblyTasksProvider(userId));
    }
  }

  /// Запуск кооперативной задачи (аналогично обычной, но можно добавить extra-параметры)
  Future<void> _startTaskWithPartnerSync(BuildContext context, WidgetRef ref, WorkerAssemblyTaskDto task, int userId) async {
    Logger.i('TaskSelectionScreen: кооперативная задача ${task.assignmentId}');
    
    // Здесь можно вызвать предварительный API-метод для подтверждения готовности напарника,
    // если это требуется бизнес-логикой. Пока просто переходим:
    final result = await context.push('/order-assembly/active', extra: {
      'assignmentId': task.assignmentId,
      'taskId': task.taskId,
      'taskStatusIndex': task.status,
      'isCooperative': true, // передаем флаг на экран выполнения
    });
    
    if (result == true) {
      ref.refresh(orderAssemblyTasksProvider(userId));
    }
  }
  Widget _buildStatChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white54, size: 15),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')}.${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}
