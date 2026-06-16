import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/boss_panel/boss_panel_models.dart';
import 'branch_orders_viewmodel.dart';

class BranchOrdersTab extends ConsumerWidget {
  const BranchOrdersTab({super.key});

  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _cardBg = Color(0xFF2C2C2E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(branchOrdersViewModelProvider);
    final vm = ref.read(branchOrdersViewModelProvider.notifier);

    if (state.isLoading && state.allOrders.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: _primaryColor));
    }

    return Column(
      children: [
        _buildControlPanel(context, state, vm),
        Expanded(
          child: state.filteredOrders.isEmpty
              ? _EmptyOrdersState(onRefresh: vm.loadData)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: state.filteredOrders.length,
                  itemBuilder: (context, index) => _OrderExpansionCard(order: state.filteredOrders[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildControlPanel(BuildContext context, BranchOrdersState state, BranchOrdersViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1C1C1E),
      child: Row(
        children: [
          // Фильтр дат
          Expanded(
            child: InkWell(
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2027),
                  builder: (context, child) => Theme(
                    data: ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: _primaryColor)),
                    child: child!,
                  ),
                );
                vm.updateDateRange(range);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: _primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      state.dateRange == null 
                        ? "Период: Все" 
                        : "${DateFormat('dd.MM').format(state.dateRange!.start)} - ${DateFormat('dd.MM').format(state.dateRange!.end)}",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: _primaryColor, strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh, color: _primaryColor),
              onPressed: () => vm.loadData(),
              tooltip: 'Обновить',
            ),
          const SizedBox(width: 8),
          // Сортировка
          PopupMenuButton<OrderSortType>(
            icon: const Icon(Icons.sort, color: _primaryColor),
            color: _cardBg,
            onSelected: vm.updateSort,
            itemBuilder: (context) => [
              const PopupMenuItem(value: OrderSortType.date, child: Text("По дате", style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: OrderSortType.status, child: Text("По статусу", style: TextStyle(color: Colors.white))),
              const PopupMenuItem(value: OrderSortType.type, child: Text("По типу", style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyOrdersState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inbox_outlined, size: 64, color: Color(0xFF7C3AED)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Нет заказов',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'В выбранном периоде заказы отсутствуют.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Обновить', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderExpansionCard extends ConsumerWidget {
  final OrderDto order;
  const _OrderExpansionCard({required this.order});

  // --- Переводчики (Translators) ---
  String _translateStatus(String status) {
    switch (status) {
      case 'Created': return 'Создан';
      case 'Assembly': return 'В сборке';
      case 'Ready': return 'Ожидает';
      case 'InTransit': return 'В пути';
      case 'Completed': return 'Завершен';
      case 'Cancelled': return 'Отменен';
      default: return status;
    }
  }

  String _translateType(String type) {
    switch (type) {
      case 'Pickup': return 'Самовывоз';
      case 'Delivery': return 'Доставка';
      case 'Postamat': return 'Постамат';
      case 'Express': return 'Экспресс';
      default: return type;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final tasksAsyncValue = ref.watch(orderTasksProvider(order.orderId));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        iconColor: const Color(0xFF7C3AED),
        collapsedIconColor: Colors.white54,
        title: Text("Заказ #${order.orderId}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${_translateStatus(order.status)} | ${order.totalPrice.toStringAsFixed(0)} ₽",
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          _buildInfoRow(Icons.access_time, "Создан", order.createdAt != null ? dateFormat.format(order.createdAt!) : "—"),
          _buildInfoRow(Icons.local_shipping, "Тип", _translateType(order.deliveryType)),
          _buildInfoRow(Icons.payment, "Оплата", order.paymentType == 'Prepaid' ? 'Предоплата' : 'При получении'),
          if (order.destinationAddress != null)
            _buildInfoRow(Icons.location_on, "Адрес", order.destinationAddress!),
          
          const Divider(color: Colors.white10, height: 24),
          const Text("Связанные задачи", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),

          tasksAsyncValue.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const Text("Нет задач", style: TextStyle(color: Colors.white54, fontSize: 13));
              }
              return _buildGroupedTasks(context, tasks);
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED))),
            error: (e, st) => Text("Ошибка: $e", style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
          ),

          const Divider(color: Colors.white10, height: 24),
          const Text("Состав заказа", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          
          // Список товаров
          ...order.positions.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Expanded(child: Text(p.itemName ?? "Товар ${p.itemId}", style: const TextStyle(color: Colors.white, fontSize: 13))),
                Text("${p.quantity} x ${p.price.toStringAsFixed(0)} ₽", style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          )),
          
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Итого:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("${order.totalPrice.toStringAsFixed(2)} ₽", style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSummary(BuildContext context, BossPanelTaskCardDto task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(task.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Text('${task.overallProgressPercentage}%', style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          if (task.assignees.isEmpty)
             const Text("Нет исполнителей", style: TextStyle(color: Colors.white54, fontSize: 12))
          else
            ...task.assignees.map((a) => InkWell(
              onTap: () {
                context.pushNamed(
                  'boss_panel_assignment_details',
                  extra: {'workerId': a.employeeId, 'taskId': task.id},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.white54),
                    const SizedBox(width: 4),
                    Expanded(child: Text(a.fullName, style: const TextStyle(color: Colors.blueAccent, fontSize: 12, decoration: TextDecoration.underline))),
                    Text(a.status, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF7C3AED)),
          const SizedBox(width: 8),
          Text("$label: ", style: const TextStyle(color: Colors.white38, fontSize: 12)),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  // Возвращает русское наименование этапа задачи по ее типу
  String _getStageName(String taskType) {
    switch (taskType) {
      case 'OrderAssembly': return 'Сборка';
      case 'OrderHandover': return 'Выдача';
      case 'ReturnToStock': return 'Возврат';
      case 'Inventory': return 'Инвентаризация';
      case 'Receipt': return 'Приемка';
      case 'Movement': return 'Перемещение';
      case 'Shipping': return 'Отгрузка';
      case 'Packing': return 'Упаковка';
      case 'Audit': return 'Аудит';
      case 'Labeling': return 'Маркировка';
      case 'Loading': return 'Погрузка';
      default: return taskType;
    }
  }

  // Группирует и отображает задачи по этапам
  Widget _buildGroupedTasks(BuildContext context, List<BossPanelTaskCardDto> tasks) {
    final Map<String, List<BossPanelTaskCardDto>> grouped = {};
    for (final task in tasks) {
      grouped.putIfAbsent(task.taskType, () => []).add(task);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final stageName = _getStageName(entry.key);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 4.0),
                child: Text(
                  stageName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...entry.value.map((task) => _buildTaskSummary(context, task)),
            ],
          ),
        );
      }).toList(),
    );
  }
}