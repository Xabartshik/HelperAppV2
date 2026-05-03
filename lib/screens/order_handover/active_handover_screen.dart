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
  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _handoverColor = Color(0xFFE11D48); // Rose для выдачи

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

    final bool isWaitingForPartner = state.details != null &&
        state.details!.isCooperative &&
        canEditTask &&
        state.details!.partnerStatus != AssignmentStatus.inProgress.index &&
        state.details!.partnerStatus != AssignmentStatus.completed.index;

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: _buildAppBar(state, vm),
      body: state.isLoading && state.details == null
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : isWaitingForPartner
              ? _buildWaitingForPartnerScreen(state.details!, vm)
              : Column(
                  children: [
                    _buildCooperationBanner(state.details),
                    _buildModeBanner(state.details),
                    if (!canEditTask) _buildStartTaskBanner(),
                    Expanded(
                      child: RefreshIndicator(
                        color: _primaryColor,
                        backgroundColor: _bgGray900,
                        onRefresh: () async => vm.loadTask(),
                        child: _buildContent(state, vm),
                      ),
                    ),
                    _buildScannerButton(state, vm),
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
          const Text(
            'Режим: Выдача / Передача',
            style: TextStyle(fontSize: 11, color: _handoverColor),
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
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => vm.loadTask(),
        ),
      ],
    );
  }

  Widget _buildStartTaskBanner() {
    return buildTaskNotStartedBanner(
      backgroundColor: _bgGray900,
      actionColor: _primaryColor,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      subtitle: 'Доступен только просмотр деталей.',
    );
  }

  Widget _buildModeBanner(HandoverTaskDetailsDto? details) {
    if (details == null) return const SizedBox();
    final isCourier = details.handoverType == 'ToCourier';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _handoverColor.withValues(alpha: 0.12),
        border: const Border(bottom: BorderSide(color: _handoverColor, width: 2)),
      ),
      child: Row(
        children: [
          Icon(isCourier ? Icons.local_shipping : Icons.person, color: _handoverColor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isCourier ? 'Передача курьеру' : 'Выдача клиенту',
                  style: const TextStyle(color: _handoverColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  isCourier ? 'Курьер: ${details.targetName}' : 'Покупатель: ${details.targetName}',
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
    if (state.errorMessage.isNotEmpty) {
      return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
    }
    if (state.details == null) return const SizedBox();
    if (state.allItemsScanned) return _buildCompletionState(state, vm);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      itemCount: state.details!.itemsToScan.length,
      itemBuilder: (context, index) => _buildItemCard(state.details!.itemsToScan[index]),
    );
  }

  Widget _buildItemCard(HandoverItemDto item) {
    final isDone = item.scannedQuantity >= item.quantity;
    final statusColor = isDone ? Colors.green : Colors.white54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDone ? Colors.green.withValues(alpha: 0.5) : Colors.transparent, width: 1.5),
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
                const SizedBox(height: 4),
                Text('Забрать: ${item.sourceCellCode}', style: const TextStyle(color: Colors.orangeAccent, fontSize: 12)),
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

  Widget _buildScannerButton(OrderHandoverState state, OrderHandoverViewModel vm) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: ElevatedButton.icon(
        onPressed: canEditTask ? () => _openScanner(state, vm) : null,
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        label: const Text('ОТКРЫТЬ СКАНЕР', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _handoverColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }

  void _openScanner(OrderHandoverState state, OrderHandoverViewModel vm) async {
    final result = await context.push<bool>('/order-handover/scanner', extra: {
      'taskId': widget.taskId,
      'workerId': _args.workerId,
    });
    
    if (result == true) {
      // Если прилетел true, значит все отсканировано и завершено
      ref.read(mainViewModelProvider.notifier).refreshTasks();
      if (mounted) context.pop();
    }
  }

  Widget _buildCompletionState(OrderHandoverState state, OrderHandoverViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: Colors.green, size: 52)),
            const SizedBox(height: 24),
            const Text('Выдача готова!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Все товары отсканированы. Можете завершить задачу.', style: TextStyle(color: Colors.white54, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: state.isLoading ? null : () => _handleCompleteTask(vm),
              icon: state.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white)) : const Icon(Icons.done_all, color: Colors.white),
              label: Text(state.isLoading ? 'Завершение...' : 'Завершить задачу', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCompleteTask(OrderHandoverViewModel vm) async {
    final (success, message) = await vm.completeTask();
    if (!mounted) return;
    if (success) {
      ref.read(mainViewModelProvider.notifier).refreshTasks();
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent.shade700));
    }
  }

  Widget _buildWaitingForPartnerScreen(HandoverTaskDetailsDto details, OrderHandoverViewModel vm) {
    // В точности как в сборке
    return Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 80, height: 80, child: Stack(alignment: Alignment.center, children: [const CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 3), Icon(Icons.people_outline, color: Colors.cyanAccent.withOpacity(0.8), size: 40)])), const SizedBox(height: 32), const Text('Ожидание напарника', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 16), RichText(textAlign: TextAlign.center, text: TextSpan(style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), children: [const TextSpan(text: 'Вы подтвердили готовность.\nПожалуйста, дождитесь, пока '), TextSpan(text: details.partnerName ?? 'ваш напарник', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), const TextSpan(text: ' тоже нажмет кнопку «Начать».')])), const SizedBox(height: 48), OutlinedButton.icon(onPressed: () => vm.loadTask(), icon: const Icon(Icons.refresh, color: Colors.white54), label: const Text('Обновить статус', style: TextStyle(color: Colors.white54)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))])));
  }

  Widget _buildCooperationBanner(HandoverTaskDetailsDto? details) {
    if (details == null || !details.isCooperative) return const SizedBox();
    return Container(
      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.05), border: Border(bottom: BorderSide(color: Colors.amber.withValues(alpha: 0.4), width: 1))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
          title: const Text('Тяжелый заказ!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(color: Colors.white10),
                const Row(children: [Icon(Icons.info_outline, color: Colors.white54, size: 16), SizedBox(width: 8), Expanded(child: Text('Вес > 50 кг. Работайте в паре и используйте тележку.', style: TextStyle(color: Colors.white70, fontSize: 13)))]),
                const SizedBox(height: 12),
                Text('Напарник: ${details.partnerName}', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
              ]),
            )
          ],
        ),
      ),
    );
  }
}