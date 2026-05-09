import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/services/auth_service.dart';
import '../tasks/base_task_screen.dart';
import '../home/main_viewmodel.dart';
import 'return_to_stock_viewmodel.dart';
import '../../core/models/return_to_stock/return_to_stock_dtos.dart';

class ActiveReturnScreen extends ConsumerStatefulWidget {
  final int assignmentId;
  final int taskId;
  final int? taskStatusIndex;
  final int? assignmentStatusIndex;

  const ActiveReturnScreen({
    super.key,
    required this.assignmentId,
    required this.taskId,
    this.taskStatusIndex,
    this.assignmentStatusIndex,
  });

  @override
  ConsumerState<ActiveReturnScreen> createState() => _ActiveReturnScreenState();
}

class _ActiveReturnScreenState extends ConsumerState<ActiveReturnScreen>
    with BaseTaskScreenMixin<ActiveReturnScreen> {
      
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _returnColor = Color(0xFF0D9488); // Бирюзовый цвет для возвратов

  ReturnToStockArgs get _args {
    final currentUser = ref.read(currentUserProvider);
    return (
      assignmentId: widget.assignmentId,
      taskId: widget.taskId,
      workerId: currentUser?.employeeId ?? 0,
    );
  }

  void _showCellInputDialog(BuildContext context, ReturnToStockViewModel vm, int lineId, String currentCell) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Укажите ячейку', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Предложено: $currentCell', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Введите ID или скан...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF141414),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.qr_code, color: Colors.white54),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('ОТМЕНА', style: TextStyle(color: Colors.white54))
          ),
          ElevatedButton(
            onPressed: () {
              final newId = int.tryParse(controller.text.trim());
              if (newId != null && newId > 0) {
                vm.updateTargetCell(lineId, newId); // Сохраняем во ViewModel
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _returnColor),
            child: const Text('СОХРАНИТЬ', style: TextStyle(color: Colors.white)),
          ),
        ],
      )
    );
  }

  @override
  bool get canEditTask {
    final state = ref.read(returnToStockViewModelProvider(_args));
    if (state.details != null) {
      return state.details!.status == 1 || state.details!.status == 2; 
    }
    return super.canEditTask;
  }

  @override
  bool get shouldShowStartButton {
    final state = ref.read(returnToStockViewModelProvider(_args));
    if (state.details != null) {
      return state.details!.status == 0; 
    }
    return super.shouldShowStartButton;
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
    await ref.read(returnToStockViewModelProvider(_args).notifier).loadTask();
  }

  @override
  Widget build(BuildContext context) {
    final provider = returnToStockViewModelProvider(_args);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.details?.taskNumber ?? 'Возврат #${widget.taskId}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text('Логистика / Складской возврат', style: TextStyle(fontSize: 11, color: _returnColor)),
          ],
        ),
        backgroundColor: _bgGray950,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => vm.loadTask()),
        ],
      ),
      body: state.isLoading && state.details == null
          ? const Center(child: CircularProgressIndicator(color: _returnColor))
          : Column(
              children: [
                _buildModeBanner(),
                if (!canEditTask) _buildStartTaskBanner(),
                Expanded(
                  child: RefreshIndicator(
                    color: _returnColor,
                    onRefresh: () async => vm.loadTask(),
                    child: _buildContent(state, vm),
                  ),
                ),
                _buildBottomControls(state, vm),
              ],
            ),
    );
  }

Widget _buildContent(ReturnToStockState state, ReturnToStockViewModel vm) {
    if (state.details == null) return const SizedBox();

    if (state.details!.itemsToScan.isEmpty) {
      return const Center(child: Text('Нет товаров для возврата', style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      itemCount: state.details!.itemsToScan.length,
      itemBuilder: (context, index) {
        final item = state.details!.itemsToScan[index];
        final isScannedLocally = state.locallyScannedLineIds.contains(item.lineId);
        final isDone = item.scannedQuantity >= item.quantity || isScannedLocally;
        
        // Получаем ручную ячейку, если кладовщик ее изменил
        final manualCellId = state.manualTargetCells[item.lineId];
        
        return GestureDetector(
          onTap: () {
            if (canEditTask && !isDone) vm.processLocalScan(item.lineId);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _bgGray900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDone ? Colors.green.withOpacity(0.5) : Colors.white12, 
                width: isDone ? 1.5 : 1
              ),
            ),
            child: Row(
              children: [
                Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, 
                     color: isDone ? Colors.green : Colors.white54),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.itemName, style: TextStyle(
                          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,
                          decoration: isDone ? TextDecoration.lineThrough : null)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.outbox, color: Colors.orangeAccent, size: 14),
                          const SizedBox(width: 4),
                          Expanded(child: Text('Из: ${item.sourceCellCode}', style: const TextStyle(color: Colors.orangeAccent, fontSize: 12))),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(manualCellId != null ? Icons.edit_location_alt : Icons.move_to_inbox, 
                               color: manualCellId != null ? Colors.amber : Colors.cyanAccent, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              manualCellId != null ? 'В: Ячейка ID $manualCellId (Изменено)' : 'В: ${item.targetCellCode}', 
                              style: TextStyle(
                                color: manualCellId != null ? Colors.amber : Colors.cyanAccent, 
                                fontSize: 12,
                                fontWeight: manualCellId != null ? FontWeight.bold : FontWeight.normal,
                              )
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (canEditTask)
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner, color: _returnColor),
                    tooltip: 'Изменить ячейку',
                    onPressed: () => _showCellInputDialog(context, vm, item.lineId, item.targetCellCode),
                  )
                else
                  Text('${item.quantity} шт', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildBottomControls(ReturnToStockState state, ReturnToStockViewModel vm) {
    if (!canEditTask) return const SizedBox();

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: ElevatedButton.icon(
        onPressed: state.allItemsProcessed ? () => _confirmCompletion(vm) : null,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text('РАЗМЕСТИТЬ И ЗАВЕРШИТЬ', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _returnColor,
          disabledBackgroundColor: _bgGray900,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _confirmCompletion(ReturnToStockViewModel vm) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Подтверждение', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Все товары возвращены на указанные складские полки?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('НЕТ', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: _returnColor),
            child: const Text('ДА', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final (success, message) = await vm.completeTask();
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
  }

  Widget _buildStartTaskBanner() {
    return buildTaskNotStartedBanner(
      backgroundColor: _bgGray900,
      actionColor: _returnColor,
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      subtitle: 'Требуется перенос товаров.',
    );
  }

  Widget _buildModeBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: _returnColor.withOpacity(0.12),
        border: const Border(bottom: BorderSide(color: _returnColor, width: 2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.assignment_return, color: _returnColor, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Возврат отказных товаров', style: TextStyle(color: _returnColor, fontSize: 15, fontWeight: FontWeight.bold)),
                SizedBox(height: 2),
                Text('Перенесите товары из зоны выдачи на полки', style: TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}