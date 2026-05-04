// lib/screens/order_handover/active_handover_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/services/auth_service.dart';
import '../tasks/base_task_screen.dart';
import '../home/main_viewmodel.dart';
import 'order_handover_viewmodel.dart';
import '../../core/models/order_handover/order_handover_dtos.dart';

class ActiveHandoverScreen extends ConsumerStatefulWidget {
  final int assignmentId;
  final int taskId;
  final int? taskStatusIndex;
  final int? assignmentStatusIndex;

  const ActiveHandoverScreen({
    super.key,
    required this.assignmentId,
    required this.taskId,
    this.taskStatusIndex,
    this.assignmentStatusIndex,
  });

  @override
  ConsumerState<ActiveHandoverScreen> createState() => _ActiveHandoverScreenState();
}

class _ActiveHandoverScreenState extends ConsumerState<ActiveHandoverScreen>
    with BaseTaskScreenMixin<ActiveHandoverScreen> {
      
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _handoverColor = Color(0xFFE11D48); 
  static const Color _cancelColor = Color(0xFFEF4444);   

  OrderHandoverArgs get _args {
    final currentUser = ref.read(currentUserProvider);
    return (
      assignmentId: widget.assignmentId,
      taskId: widget.taskId,
      workerId: currentUser?.employeeId ?? 0,
    );
  }

  @override
  BaseTaskScreenArgs get baseTaskArgs => BaseTaskScreenArgs(
        taskId: widget.taskId,
        workerId: _args.workerId,
        taskStatusIndex: widget.taskStatusIndex,
        assignmentStatusIndex: widget.assignmentStatusIndex,
      );

  @override
  void initState() {
    super.initState();
    initializeTaskStartState();
  }

  @override
  Future<void> onTaskStarted() async {
    await ref.read(orderHandoverViewModelProvider(_args).notifier).activateTask();
  }

  @override
  Widget build(BuildContext context) {
    final provider = orderHandoverViewModelProvider(_args);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: _buildAppBar(state, vm),
      body: state.isLoading && state.details == null
          ? const Center(child: CircularProgressIndicator(color: _handoverColor))
          : Column(
              children: [
                _buildCooperationBanner(state.details),
                _buildModeBanner(state),
                if (!canEditTask) _buildStartTaskBanner(),
                Expanded(
                  child: RefreshIndicator(
                    color: _handoverColor,
                    onRefresh: () async => vm.loadTask(),
                    child: _buildContent(state, vm),
                  ),
                ),
                _buildBottomControls(state, vm),
              ],
            ),
    );
  }

  AppBar _buildAppBar(OrderHandoverState state, OrderHandoverViewModel vm) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.details?.taskNumber ?? 'Выдача #${widget.taskId}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            state.isCancelMode ? 'ИЗМЕНЕНИЕ ОТМЕН' : 'Режим: Выдача / Передача',
            style: TextStyle(fontSize: 11, color: state.isCancelMode ? _cancelColor : _handoverColor),
          ),
        ],
      ),
      backgroundColor: _bgGray950,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (state.isCancelMode)
          TextButton(
            onPressed: () => vm.selectAllForCancellation(),
            child: const Text('ОТМЕНИТЬ ВСЁ', 
              style: TextStyle(color: _cancelColor, fontWeight: FontWeight.bold)),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => vm.loadTask(),
        ),
      ],
    );
  }

  Widget _buildModeBanner(OrderHandoverState state) {
    final details = state.details;
    if (details == null) return const SizedBox();
    final isCourier = details.handoverType == 'ToCourier';
    final activeColor = state.isCancelMode ? _cancelColor : _handoverColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.12),
        border: Border(bottom: BorderSide(color: activeColor, width: 2)),
      ),
      child: Row(
        children: [
          Icon(
            state.isCancelMode ? Icons.edit_note : (isCourier ? Icons.local_shipping : Icons.person), 
            color: activeColor, 
            size: 28
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.isCancelMode ? 'Редактирование отмен' : (isCourier ? 'Передача курьеру' : 'Выдача клиенту'),
                  style: TextStyle(color: activeColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  state.isCancelMode 
                    ? 'Уменьшите количество, чтобы вернуть товар в сборку' 
                    : 'Цель: ${details.targetName}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(OrderHandoverState state, OrderHandoverViewModel vm) {
    if (state.details == null) return const SizedBox();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      itemCount: state.details!.itemsToScan.length,
      itemBuilder: (context, index) {
        final item = state.details!.itemsToScan[index];
        return state.isCancelMode 
            ? _buildCancelItemCard(item, state, vm) 
            : _buildItemCard(item, state);
      },
    );
  }

  Widget _buildItemCard(HandoverItemDto item, OrderHandoverState state) {
    final cancelled = state.cancelledQuantities[item.lineId] ?? 0;
    final isDone = (item.scannedQuantity + cancelled) >= item.quantity;
    final statusColor = isDone ? Colors.green : Colors.white54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDone ? Colors.green.withValues(alpha: 0.5) : Colors.transparent, 
          width: 1.5
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (cancelled > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Отменено: $cancelled шт.', 
                      style: const TextStyle(color: _cancelColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(height: 4),
                Text('Ячейка: ${item.sourceCellCode}', 
                  style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${item.scannedQuantity} / ${item.quantity}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDone ? Colors.green : Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCancelItemCard(HandoverItemDto item, OrderHandoverState state, OrderHandoverViewModel vm) {
    final cancelled = state.cancelledQuantities[item.lineId] ?? 0;
    final maxAvailable = item.quantity - item.scannedQuantity;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cancelColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName, style: const TextStyle(color: Colors.white, fontSize: 14)),
                Text('Отсканировано: ${item.scannedQuantity} / ${item.quantity}', 
                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: _cancelColor),
                onPressed: () => vm.updateCancelledQuantity(item.lineId, cancelled - 1, maxAvailable),
              ),
              SizedBox(
                width: 30,
                child: Text('$cancelled', 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () => vm.updateCancelledQuantity(item.lineId, cancelled + 1, maxAvailable),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomControls(OrderHandoverState state, OrderHandoverViewModel vm) {
    if (!canEditTask) return const SizedBox();

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        children: [
          if (state.isCancelMode)
            ElevatedButton(
              onPressed: () => vm.toggleCancelMode(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _bgGray900,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('СОХРАНИТЬ И ВЫЙТИ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          else ...[
            if (state.allItemsProcessed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () => _confirmCompletion(vm),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('ЗАВЕРШИТЬ ВЫДАЧУ', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: state.allItemsScanned ? null : () => _openScanner(state, vm),
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    label: const Text('СКАНЕР', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _handoverColor,
                      disabledBackgroundColor: _bgGray900,
                      minimumSize: const Size(0, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => vm.toggleCancelMode(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _bgGray900,
                      minimumSize: const Size(0, 54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: state.cancelledQuantities.isNotEmpty ? Colors.amber : _cancelColor, width: 1),
                    ),
                    child: Text(
                      state.cancelledQuantities.isNotEmpty ? 'ПРАВКА' : 'ОТМЕНА', 
                      style: TextStyle(
                        color: state.cancelledQuantities.isNotEmpty ? Colors.amber : _cancelColor, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
void _confirmCompletion(OrderHandoverViewModel vm) async {
    // Если это передача курьеру — требуем "цифровое рукопожатие"
    if (ref.read(orderHandoverViewModelProvider(_args)).details?.handoverType == 'ToCourier') {
      
      // Открываем сканер (можешь использовать свой существующий экран для сканирования QR)
      final String? scannedQr = await context.push<String>('/customer-qr-scanner');
      
      if (scannedQr != null && scannedQr.isNotEmpty) {
        final (success, message) = await vm.completeCourierHandover(scannedQr);
        
        if (mounted) {
          if (success) {
            ref.read(mainViewModelProvider.notifier).refreshTasks();
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
          }
        }
      }
      return; // Прерываем выполнение, чтобы не открылся стандартный диалог
    }

    // Стандартный диалог для выдачи клиентам (Самовывоз)
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Завершить заказ?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Вы подтверждаете выдачу отсканированных товаров и отмену недоступных позиций?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('НЕТ', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('ДА, ЗАВЕРШИТЬ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final (success, message) = await vm.completeTask();
      if (mounted && success) {
        ref.read(mainViewModelProvider.notifier).refreshTasks();
        context.pop();
      }
    }
  }

  void _openScanner(OrderHandoverState state, OrderHandoverViewModel vm) async {
    await context.push('/order-handover/scanner', extra: {
      'taskId': widget.taskId,
      'workerId': _args.workerId,
    });
    vm.loadTask();
  }

  Widget _buildStartTaskBanner() {
    return buildTaskNotStartedBanner(
      backgroundColor: _bgGray900,
      actionColor: _handoverColor,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      subtitle: 'Доступен только просмотр деталей.',
    );
  }

  Widget _buildCooperationBanner(HandoverTaskDetailsDto? details) {
    if (details == null || !details.isCooperative) return const SizedBox();
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.amber.withValues(alpha: 0.4), width: 1))
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
        title: const Text('Тяжелый заказ!', 
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(color: Colors.white10),
              Text('Напарник: ${details.partnerName}', 
                style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
            ]),
          )
        ],
      ),
    );
  }
}