import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';
import '../home/main_viewmodel.dart';
import '../tasks/base_task_screen.dart';
import 'order_assembly_viewmodel.dart';

/// Основной рабочий экран сборки заказа.
/// Визуально разделяет режимы «Сбор» (Pick) и «Размещение» (Place) / «Выдача» (Express).
class ActiveAssemblyScreen extends ConsumerStatefulWidget {
  final int assignmentId;
  final int taskId;
  final int? taskStatusIndex;
  final int? assignmentStatusIndex;

  const ActiveAssemblyScreen({
    super.key,
    required this.assignmentId,
    this.taskId = 0,
    this.taskStatusIndex,
    this.assignmentStatusIndex,
  });

  @override
  ConsumerState<ActiveAssemblyScreen> createState() => _ActiveAssemblyScreenState();
}

class _ActiveAssemblyScreenState extends ConsumerState<ActiveAssemblyScreen>
    with SingleTickerProviderStateMixin, BaseTaskScreenMixin<ActiveAssemblyScreen> {
  // Цвета в стиле приложения
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _pickColor = Color(0xFF0D9488); // teal для режима Сбора
  static const Color _placeColor = Color(0xFFF59E0B); // amber для режима Размещения

  late AnimationController _modeAnimController;
  late Animation<double> _modeAnimation;

  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();

  @override
  BaseTaskScreenArgs get baseTaskArgs => BaseTaskScreenArgs(
        taskId: widget.taskId,
        workerId: _args.userId,
        taskStatusIndex: widget.taskStatusIndex,
        assignmentStatusIndex: widget.assignmentStatusIndex,
      );

  OrderAssemblyArgs get _args {
    final currentUser = ref.read(currentUserProvider);
    return (
      assignmentId: widget.assignmentId,
      userId: currentUser?.employeeId ?? 0,
    );
  }



  @override
  void initState() {
    super.initState();
    initializeTaskStartState();
    _modeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _modeAnimation = CurvedAnimation(
      parent: _modeAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _modeAnimController.dispose();
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Future<void> onTaskStarted() async {
    await ref.read(orderAssemblyViewModelProvider(_args).notifier).loadTask();
  }

  @override
  Widget build(BuildContext context) {
    final provider = orderAssemblyViewModelProvider(_args);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    if (state.mode == AssemblyMode.place && _modeAnimController.value < 1.0) {
      _modeAnimController.forward();
    } else if (state.mode == AssemblyMode.pick && _modeAnimController.value > 0.0) {
      _modeAnimController.reverse();
    }

    final modeColor = state.mode == AssemblyMode.pick ? _pickColor : _placeColor;

    final bool isWaitingForPartner = state.isCooperative && 
                                     canEditTask && 
                                     state.partnerStatus != AssignmentStatus.inProgress &&
                                     state.partnerStatus != AssignmentStatus.completed;

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: _buildAppBar(state, modeColor),
      body: state.isLoading && state.cells.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : isWaitingForPartner 
              ? _buildWaitingForPartnerScreen(state, vm)
              : Column(
                  children: [
                    _buildCooperationBanner(state),
                    _buildModeBanner(state, vm),
                    _buildProgressBar(state),
                    if (!canEditTask) _buildStartTaskBanner(),
                    Expanded(
                      child: RefreshIndicator(
                        color: _primaryColor,
                        backgroundColor: _bgGray900,
                        onRefresh: () async => vm.loadTask(),
                        child: _buildContent(state, vm),
                      ),
                    ),
                    // Показываем особые кнопки, если это этап выдачи экспресс-заказа
                    if (state.isExpress && state.mode == AssemblyMode.place && canEditTask)
                      _buildExpressBottomControls(state, vm)
                    else
                      _buildBarcodeInput(state, vm),
                  ],
                ),
    );
  }

  AppBar _buildAppBar(OrderAssemblyState state, Color modeColor) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (state.task?.taskNumber != null && state.task!.taskNumber!.isNotEmpty)
                ? state.task!.taskNumber!
                : 'Задача ${widget.assignmentId}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            state.mode == AssemblyMode.pick 
                ? 'Режим: Сбор товаров' 
                : (state.isExpress ? 'Режим: Выдача' : 'Режим: Размещение'),
            style: TextStyle(fontSize: 11, color: modeColor),
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
          onPressed: () => ref.read(orderAssemblyViewModelProvider(_args).notifier).loadTask(),
          tooltip: 'Обновить',
        ),
      ],
    );
  }

  /// Баннер режима с поддержкой Экспресс-выдачи
  Widget _buildModeBanner(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    return AnimatedBuilder(
      animation: _modeAnimation,
      builder: (context, child) {
        final isPick = state.mode == AssemblyMode.pick;
        final isExpressPlace = !isPick && state.isExpress;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isPick
                ? _pickColor.withValues(alpha: 0.12)
                : _placeColor.withValues(alpha: 0.12),
            border: Border(
              bottom: BorderSide(
                color: isPick ? _pickColor : _placeColor,
                width: 2,
              ),
            ),
          ),
          child: Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isPick ? Icons.shopping_cart_outlined : Icons.place_outlined,
                  key: ValueKey(state.mode),
                  color: isPick ? _pickColor : _placeColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(state.mode),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPick 
                            ? 'Режим: Сбор товаров' 
                            : (isExpressPlace ? 'Режим: Выдача клиенту' : 'Режим: Размещение'),
                        style: TextStyle(
                          color: isPick ? _pickColor : _placeColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPick
                            ? 'Сканируйте штрихкод товара'
                            : (isExpressPlace 
                                ? 'Отсканируйте QR-код покупателя для выдачи' 
                                : 'Перейдите в зону выдачи и сканируйте код ячейки'),
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Прогресс-бар с условием скрытия для Express
  Widget _buildProgressBar(OrderAssemblyState state) {
    final total = state.totalItems;
    final done = state.pickedItems;
    final progress = total > 0 ? done / total : 0.0;
    final placedCells = state.placedCells;
    final totalCells = state.cells.length;

    return Container(
      color: _bgGray950,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Сбор товаров', style: TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: _bgGray900,
                  color: _pickColor,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 4),
                Text('$done / $total товаров', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Убираем блок «Размещение ячеек» для Express заказов
          if (!state.isExpress) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Размещение ячеек', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: totalCells > 0 ? placedCells / totalCells : 0.0,
                    backgroundColor: _bgGray900,
                    color: _placeColor,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 4),
                  Text('$placedCells / $totalCells ячеек', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    if (state.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 56),
              const SizedBox(height: 16),
              Text(state.errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 14), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => vm.loadTask(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Повторить', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              ),
            ],
          ),
        ),
      );
    }
    
    if (state.allCellsPlaced && state.cells.isNotEmpty) return _buildCompletionState(state, vm);

    // Специальный экран для Помощника в сборке
    if (state.cells.isEmpty && state.isCooperative) {
      return _buildHelperActiveScreen(state);
    }

    if (state.cells.isEmpty) return const Center(child: Text('Нет ячеек в задаче', style: TextStyle(color: Colors.white54)));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      itemCount: state.cells.length,
      itemBuilder: (context, index) => _buildCellCard(state.cells[index], state, vm),
    );
  }

  Widget _buildHelperActiveScreen(OrderAssemblyState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.handshake, color: _primaryColor, size: 80),
            const SizedBox(height: 24),
            const Text('Вы — помощник', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(
              'Помогайте сотруднику ${state.partnerName ?? 'напарник'} с переноской тяжелых грузов.\n\nВам не нужно ничего сканировать. Ваша задача автоматически завершится, когда ведущий закончит сборку на своем терминале.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellCard(CellPlacementVm cell, OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final isPick = state.mode == AssemblyMode.pick;
    final cellColor = cell.isPlaced ? Colors.green : (isPick ? _pickColor : _placeColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cell.isPlaced ? Colors.green.withValues(alpha: 0.5) : (cell.allDone ? cellColor.withValues(alpha: 0.6) : _bgGray900), width: 1.5),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => vm.toggleCellExpansion(cell),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(color: cellColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(cell.isPlaced ? Icons.check_circle_outline : Icons.place_outlined, color: cellColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Для Express заменяем название ячейки в режиме выдачи
                        Text(
                          state.isExpress && !isPick
                              ? 'Выдать покупателю'
                              : (cell.cellDisplayName.isNotEmpty ? cell.cellDisplayName : 'Ячейка: ${cell.cellCode}'), 
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 2),
                        Text(cell.isPlaced ? '✅ Размещено' : 'Собрано: ${cell.doneCount} / ${cell.totalItems}', style: TextStyle(color: cell.isPlaced ? Colors.green : Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(cell.isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.white38),
                ],
              ),
            ),
          ),
          if (cell.isExpanded) ...[
            const Divider(color: Colors.white12, height: 1),
            ...cell.items.map((item) => _buildItemRow(item, state, vm)),
          ],
        ],
      ),
    );
  }

Widget _buildBottomControls(OrderAssemblyState state, OrderAssemblyViewModel vm) {
  if (state.mode == AssemblyMode.pick) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => context.push('/assembly-scanner', extra: {
          'assignmentId': widget.assignmentId,
          'userId': ref.read(currentUserProvider)?. employeeId ?? 0,
        }),
        icon: const Icon(Icons.barcode_reader, color: Colors.white),
        label: const Text('Сканировать товар', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Режим размещения (Place)
  return Container(
    padding: const EdgeInsets.all(16),
    child: state.isExpress 
      ? Row( // Для экспресса добавляем кнопку "Изменить" (Cancel Mode)
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () => vm.toggleCancelMode(),
                icon: Icon(state.isCancelMode ? Icons.close : Icons.edit_note, 
                  color: state.isCancelMode ? Colors.redAccent : Colors.orange),
                label: Text(state.isCancelMode ? 'Отмена' : 'Изменить', 
                  style: TextStyle(color: state.isCancelMode ? Colors.redAccent : Colors.orange)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: state.isCancelMode ? Colors.redAccent : Colors.orange),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Вызываем сканер и ждем QR-код клиента
                  final result = await context.push<bool>('/assembly-scanner', extra: {
                    'assignmentId': widget.assignmentId,
                    'userId': ref.read(currentUserProvider)?. employeeId ?? 0,
                  });
                  
                  if (result != null && mounted) {
                    _showFinalConfirmation(state, vm);
                  }
                },
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                label: Text(state.isCancelMode ? 'Выдать с отменами' : 'Выдать заказ', 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: state.isCancelMode ? Colors.orange : const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        )
      : ElevatedButton.icon( // Обычное размещение по ячейкам
          onPressed: () => context.push('/assembly-scanner', extra: {
            'assignmentId': widget.assignmentId,
            'userId': ref.read(currentUserProvider)?. employeeId ?? 0,
          }),
          icon: const Icon(Icons.grid_view, color: Colors.white),
          label: const Text('Разместить в ячейку', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
  );
}

Widget _buildItemRow(AssemblyItemVm item, OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final statusColor = item.isMissing ? Colors.redAccent : (item.isPicked ? Colors.greenAccent.shade400 : Colors.white54);
    final parentCell = state.cells.firstWhere((c) => c.items.any((i) => i.lineId == item.lineId));
    final isPickMode = state.mode == AssemblyMode.pick;
    
    // Модификация текста ячейки для Express
    final cellText = isPickMode 
        ? 'Забрать из: ${item.sourceCellCode}' 
        : (state.isExpress ? '' : 'Положить в: ${parentCell.cellDisplayName}');
    
    final cellTextColor = isPickMode ? Colors.orangeAccent : Colors.blueAccent;

    // Параметры для счетчика отмены
    final int cancelledQty = state.cancelledQuantities[item.lineId] ?? 0;
    final int maxAvailable = item.collectedQuantity;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5))),
      child: Row(
        children: [
          Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 12, top: 4), decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.itemName.isNotEmpty ? item.itemName : 'Товар #${item.itemId}', style: TextStyle(color: item.isDone ? Colors.white54 : Colors.white, fontSize: 13, decoration: item.isMissing ? TextDecoration.lineThrough : null)),
                
                // === ИЗМЕНЕНИЕ: Текстовый индикатор отмены как в экране выдачи ===
                if (cancelledQty > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text('Отменено: $cancelledQty шт.', 
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),

                if (cellText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(cellText, style: TextStyle(color: item.isDone && isPickMode ? Colors.white54 : cellTextColor, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 4),
                Text('${item.statusText} · ${item.collectedQuantity}/${item.quantity} шт.', style: TextStyle(color: statusColor, fontSize: 11)),
                
                // === СЧЕТЧИКИ ОТМЕНЫ (Визуал синхронизирован с _buildCancelItemCard) ===
                if (state.isExpress && state.mode == AssemblyMode.place && state.isCancelMode)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _bgGray900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text('К отмене:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              onPressed: () => vm.updateCancelledQuantity(item.lineId, cancelledQty - 1, maxAvailable),
                            ),
                            SizedBox(
                              width: 30, // Фиксированная ширина для ровного центрирования текста
                              child: Text(
                                '$cancelledQty',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green), // Изменено на зеленый
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              onPressed: () => vm.updateCancelledQuantity(item.lineId, cancelledQty + 1, maxAvailable),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (isPickMode && !item.isDone)
            TextButton(
              onPressed: canEditTask ? () => _showReportMissingDialog(item, vm) : null,
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Нет', style: TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildCompletionState(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: Colors.green, size: 52)),
            const SizedBox(height: 24),
            const Text('Все ячейки заполнены!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Вы можете завершить задачу сборки', style: TextStyle(color: Colors.white54, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: state.isLoading ? null : () => _handleCompleteTask(vm),
              icon: state.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.done_all, color: Colors.white),
              label: Text(state.isLoading ? 'Завершение...' : 'Завершить задачу', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartTaskBanner() {
    return buildTaskNotStartedBanner(backgroundColor: _bgGray900, actionColor: _primaryColor, margin: const EdgeInsets.fromLTRB(12, 8, 12, 8), subtitle: 'Доступен только просмотр деталей.');
  }

/// Нижняя панель для экспресс-выдачи с кнопками режима отмены
  Widget _buildExpressBottomControls(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    // 1. КРАСИВАЯ КНОПКА ВЕРИФИКАЦИИ (ЕСЛИ КЛИЕНТ ЕЩЕ НЕ ПОДТВЕРЖДЕН)
    if (!state.isCustomerVerified) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: const BoxDecoration(
          color: _bgGray950,
          border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
        ),
        child: InkWell(
          onTap: () => _openScanner(state, vm),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              // Динамичный градиент для привлечения внимания
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1), // Indigo
                  const Color(0xFF8B5CF6), // Violet
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // Иконка в красивой подложке
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                // Текстовый блок
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'ВЫДАЧА ЗАКАЗА',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Отсканируйте QR покупателя',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Стрелочка "вперед"
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. ПАНЕЛЬ УПРАВЛЕНИЯ ОТМЕНАМИ (ЕСЛИ КЛИЕНТ УЖЕ ПОДТВЕРЖДЕН)
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => vm.toggleCancelMode(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _bgGray900,
                minimumSize: const Size(0, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(
                  color: state.cancelledQuantities.isNotEmpty ? Colors.amber : Colors.redAccent, 
                  width: 1.5, // Немного толще рамка для акцента
                ),
              ),
              child: Text(
                state.cancelledQuantities.isNotEmpty ? 'ПРАВКА' : 'ОТМЕНА', 
                style: TextStyle(
                  color: state.cancelledQuantities.isNotEmpty ? Colors.amber : Colors.redAccent, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                )
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: () => _showFinalConfirmation(state, vm),
              icon: const Icon(Icons.done_all, color: Colors.white),
              label: Text(
                state.isCancelMode ? 'ВЫДАТЬ С ОТМЕНАМИ' : 'ВЫДАТЬ ЗАКАЗ',
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 14,
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isCancelMode ? Colors.orange : const Color(0xFF0D9488),
                minimumSize: const Size(0, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

// Добавить в _ActiveAssemblyScreenState
void _showFinalConfirmation(OrderAssemblyState state, OrderAssemblyViewModel vm) async {
    // Достаем сохраненный токен из состояния напрямую
    final String qrToken = state.tempQrToken ?? '';
    
    if (qrToken.isEmpty) {
      // Больше никаких "тихих возвратов". Если токена нет, мы об этом узнаем!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка: QR-код клиента не найден. Пожалуйста, отсканируйте его еще раз.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return; 
    } 

    final int cancelledCount = state.cancelledQuantities.values.fold(0, (a, b) => a + b);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        title: const Text('Подтверждение выдачи', style: TextStyle(color: Colors.white)),
        content: Text(
          cancelledCount > 0 
            ? 'Выдать заказ клиенту?\n\nВнимание: Будет отменено товаров: $cancelledCount шт.'
            : 'Выдать заказ клиенту в полном объеме?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Назад', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              // ВАЖНО: Убедись, что у тебя во ViewModel метод называется именно так!
              final result = await vm.finalizeExpressHandover(); 
              
              if (result.$1 && mounted) {
                // Возвращаемся в список задач
                ref.read(mainViewModelProvider.notifier).refreshTasks();
                Navigator.pop(context, true); 
              } else if (!result.$1 && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.$2), backgroundColor: Colors.redAccent),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cancelledCount > 0 ? Colors.orange : const Color(0xFF0D9488),
            ),
            child: const Text('Да, выдать', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  } 
 
  /// Поле ввода со сканером
  Widget _buildBarcodeInput(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final isPick = state.mode == AssemblyMode.pick;
    final activeColor = isPick ? _pickColor : _placeColor;
    
    final hint = isPick 
        ? 'Штрихкод товара...' 
        : (state.isExpress ? 'QR-код клиента...' : 'Код ячейки выдачи...');

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: canEditTask ? () => _openScanner(state, vm) : null,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(isPick ? Icons.qr_code_scanner : Icons.grid_view, color: activeColor, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _barcodeController,
              focusNode: _barcodeFocusNode,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                filled: true,
                fillColor: _bgGray900,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: activeColor, width: 1.5)),
              ),
              enabled: canEditTask,
              onSubmitted: (value) => _handleBarcodeSubmit(value, state, vm),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: canEditTask ? () => _handleBarcodeSubmit(_barcodeController.text, state, vm) : null,
            style: ElevatedButton.styleFrom(backgroundColor: activeColor, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(0, 40)),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Future<void> _openScanner(OrderAssemblyState state, OrderAssemblyViewModel vm) async {
    if (!canEditTask) return;
    // В методе _openScanner или по кнопке "Выдать"
    final result = await context.push<bool>('/order-assembly/scanner', extra: {
      'assignmentId': widget.assignmentId,
      'userId': _args.userId,
    });

    // Нам не нужно обрабатывать строку здесь, так как vm.verifyCustomerQr уже всё сохранил в стейт.
    if (result == true) {
      // UI обновится сам благодаря ref.watch(provider)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Клиент подтвержден'), backgroundColor: Colors.green)
      );
    }
  }

  /// Обработка ввода и отправка сканов
  Future<void> _handleBarcodeSubmit(
      String value, OrderAssemblyState state, OrderAssemblyViewModel vm) async {
    if (!canEditTask) return;
    final barcode = value.trim();
    if (barcode.isEmpty) return;

    _barcodeController.clear();
    _barcodeFocusNode.requestFocus();

    (bool, String) result;

    if (state.mode == AssemblyMode.pick) {
      result = await vm.processScanPick(barcode);
    } else if (state.isExpress) {
      // Направляем в метод выдачи, если это экспресс
      result = await vm.processExpressHandover(barcode);
    } else {
      result = await vm.processScanPlace(barcode);
    }

    final (success, message) = result;

    if (!mounted) return;

    // Спец-обработка для быстрого закрытия экрана при выдаче клиенту
    if (success && message.startsWith('FINISH_EXPRESS:')) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.substring(15)),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
      ref.read(mainViewModelProvider.notifier).refreshTasks();
      context.pop(true);
      return;
    }

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green.shade700 : Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: success ? 2 : 4),
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _showReportMissingDialog(AssemblyItemVm item, OrderAssemblyViewModel vm) async {
    if (!canEditTask) return;
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgGray950,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Товар отсутствует', style: TextStyle(color: Colors.white, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.itemName.isNotEmpty ? item.itemName : 'Товар #${item.itemId}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
            const Text('Причина отсутствия:', style: TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(controller: reasonController, autofocus: true, style: const TextStyle(color: Colors.white, fontSize: 13), decoration: InputDecoration(hintText: 'Причина...', hintStyle: const TextStyle(color: Colors.white38, fontSize: 12), filled: true, fillColor: const Color(0xFF141414), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)), maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена', style: TextStyle(color: Colors.white54)),),
          ElevatedButton(onPressed: () { if (reasonController.text.trim().isEmpty) return; Navigator.pop(ctx, true); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Подтвердить', style: TextStyle(color: Colors.white)),),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final (success, message) = await vm.reportMissingItem(item.lineId, reasonController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: success ? Colors.orange.shade700 : Colors.redAccent.shade700, behavior: SnackBarBehavior.floating, margin: const EdgeInsets.fromLTRB(12, 0, 12, 80), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
    }
  }

  Future<void> _handleCompleteTask(OrderAssemblyViewModel vm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgGray950,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Завершение задачи', style: TextStyle(color: Colors.white)),
        content: const Text('Все ячейки обработаны. Завершить задачу сборки?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена', style: TextStyle(color: Colors.white54)),),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: const Text('Завершить', style: TextStyle(color: Colors.white)),),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    final (success, message) = await vm.completeTask();
    if (!mounted) return;
    if (success) {
      ref.read(mainViewModelProvider.notifier).refreshTasks();
      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent.shade700, behavior: SnackBarBehavior.floating, margin: const EdgeInsets.fromLTRB(12, 0, 12, 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
    }
  }

  Widget _buildWaitingForPartnerScreen(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    return Center(child: Padding(padding: const EdgeInsets.all(32.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 80, height: 80, child: Stack(alignment: Alignment.center, children: [const CircularProgressIndicator(color: Colors.cyanAccent, strokeWidth: 3), Icon(Icons.people_outline, color: Colors.cyanAccent.withOpacity(0.8), size: 40)])), const SizedBox(height: 32), const Text('Ожидание напарника', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 16), RichText(textAlign: TextAlign.center, text: TextSpan(style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5), children: [const TextSpan(text: 'Вы подтвердили готовность.\nПожалуйста, дождитесь, пока '), TextSpan(text: state.partnerName ?? 'ваш напарник', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), const TextSpan(text: ' тоже нажмет кнопку «Начать» в своем приложении.')])), const SizedBox(height: 48), OutlinedButton.icon(onPressed: () => vm.loadTask(), icon: const Icon(Icons.refresh, color: Colors.white54), label: const Text('Обновить статус', style: TextStyle(color: Colors.white54)), style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)))])));
  }

  Widget _buildCooperationBanner(OrderAssemblyState state) {
    if (!state.isCooperative) return const SizedBox();
    final bool partnerStarted = state.partnerStatus == AssignmentStatus.inProgress || state.partnerStatus == AssignmentStatus.completed;
    final bool partnerCompleted = state.partnerStatus == AssignmentStatus.completed;

    return Container(
      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.05), border: Border(bottom: BorderSide(color: Colors.amber.withValues(alpha: 0.4), width: 1))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 24),
          title: const Text('Тяжелый груз!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Divider(color: Colors.white10),
                const Row(children: [Icon(Icons.info_outline, color: Colors.white54, size: 16), SizedBox(width: 8), Expanded(child: Text('Вес заказа > 50 кг. ОБЯЗАТЕЛЬНО возьмите грузовую тележку.', style: TextStyle(color: Colors.white70, fontSize: 13)))]),
                const SizedBox(height: 12),
                Row(children: [const Icon(Icons.people_outline, color: Colors.cyanAccent, size: 18), const SizedBox(width: 8), Expanded(child: RichText(text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14), children: [const TextSpan(text: 'Напарник: '), TextSpan(text: state.partnerName ?? 'Не назначен', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent))])))]),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: partnerStarted ? Colors.green.withOpacity(0.1) : Colors.white10, borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(partnerCompleted ? Icons.done_all : (partnerStarted ? Icons.check_circle : Icons.person_search_outlined), color: partnerStarted ? Colors.greenAccent : Colors.white54, size: 18), const SizedBox(width: 10), Expanded(child: Text(partnerCompleted ? 'Коллега уже завершил свою часть задачи.' : (partnerStarted ? 'Коллега подтвердил участие. Можете начинать.' : 'Ожидайте коллегу. Он еще не подтвердил участие.'), style: TextStyle(color: partnerStarted ? Colors.greenAccent : Colors.white54, fontSize: 12)))]))
              ]),
            )
          ],
        ),
      ),
    );
  }
}