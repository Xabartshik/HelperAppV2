import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';
import 'order_assembly_viewmodel.dart';

/// Основной рабочий экран сборки заказа.
/// Визуально разделяет режимы «Сбор» (Pick) и «Размещение» (Place).
class ActiveAssemblyScreen extends ConsumerStatefulWidget {
  final int assignmentId;

  const ActiveAssemblyScreen({
    super.key,
    required this.assignmentId,
  });

  @override
  ConsumerState<ActiveAssemblyScreen> createState() => _ActiveAssemblyScreenState();
}

class _ActiveAssemblyScreenState extends ConsumerState<ActiveAssemblyScreen>
    with SingleTickerProviderStateMixin {
  // Цвета в стиле приложения
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);
  static const Color _pickColor = Color(0xFF0D9488); // teal для режима Сбора
  static const Color _placeColor = Color(0xFFF59E0B); // amber для режима Размещения

  // Контроллер для анимации переключения режима
  late AnimationController _modeAnimController;
  late Animation<double> _modeAnimation;

  // Контроллер поля ввода штрихкода
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();

  OrderAssemblyArgs get _args {
    final currentUser = ref.read(currentUserProvider);
    return (
      assignmentId: widget.assignmentId,
      userId: currentUser?.id ?? 0,
    );
  }

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final provider = orderAssemblyViewModelProvider(_args);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    // Анимируем переход при смене режима
    if (state.mode == AssemblyMode.place && _modeAnimController.value < 1.0) {
      _modeAnimController.forward();
    } else if (state.mode == AssemblyMode.pick && _modeAnimController.value > 0.0) {
      _modeAnimController.reverse();
    }

    final modeColor = state.mode == AssemblyMode.pick ? _pickColor : _placeColor;

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: _buildAppBar(state, modeColor),
      body: state.isLoading && state.cells.isEmpty
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : Column(
              children: [
                // Баннер текущего режима (анимированный)
                _buildModeBanner(state, vm),
                // Прогресс-бар
                _buildProgressBar(state),
                // Список ячеек / товаров
                Expanded(
                  child: RefreshIndicator(
                    color: _primaryColor,
                    backgroundColor: _bgGray900,
                    onRefresh: () async => vm.loadTask(),
                    child: _buildContent(state, vm),
                  ),
                ),
                // Поле ввода штрихкода
                _buildBarcodeInput(state, vm),
              ],
            ),
    );
  }

  // ---------------------------------------------------------------------------
  // AppBar
  // ---------------------------------------------------------------------------

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
            state.mode == AssemblyMode.pick ? 'Режим: Сбор товаров' : 'Режим: Размещение',
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

  // ---------------------------------------------------------------------------
  // Баннер режима (анимированный)
  // ---------------------------------------------------------------------------

  Widget _buildModeBanner(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    return AnimatedBuilder(
      animation: _modeAnimation,
      builder: (context, child) {
        final isPick = state.mode == AssemblyMode.pick;
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
                        isPick ? 'Режим: Сбор товаров' : 'Режим: Размещение',
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
                            : 'Перейдите в зону выдачи и сканируйте код ячейки',
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

  // ---------------------------------------------------------------------------
  // Прогресс-бар
  // ---------------------------------------------------------------------------

  Widget _buildProgressBar(OrderAssemblyState state) {
    final total = state.totalItems;
    final done = state.pickedItems;
    final progress = total > 0 ? done / total : 0.0;

    final placedCells = state.placedCells;
    final totalCells = state.cells.length;

    return Container(
      color: _bgGray950,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
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
                    Text(
                      '$done / $total товаров',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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
                    Text(
                      '$placedCells / $totalCells ячеек',
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Контент (список ячеек или сообщение о завершении)
  // ---------------------------------------------------------------------------

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
              Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => vm.loadTask(),
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

    if (state.allCellsPlaced) {
      return _buildCompletionState(state, vm);
    }

    if (state.cells.isEmpty) {
      return const Center(
        child: Text('Нет ячеек в задаче', style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      itemCount: state.cells.length,
      itemBuilder: (context, index) => _buildCellCard(state.cells[index], state, vm),
    );
  }

  // ---------------------------------------------------------------------------
  // Карточка ячейки
  // ---------------------------------------------------------------------------

  Widget _buildCellCard(CellPlacementVm cell, OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final isPick = state.mode == AssemblyMode.pick;
    final cellColor = cell.isPlaced
        ? Colors.green
        : (isPick ? _pickColor : _placeColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _bgGray900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cell.isPlaced
              ? Colors.green.withValues(alpha: 0.5)
              : (cell.allDone
                  ? cellColor.withValues(alpha: 0.6)
                  : _bgGray900),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Заголовок ячейки
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            onTap: () => vm.toggleCellExpansion(cell),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Иконка статуса ячейки
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cellColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cell.isPlaced
                          ? Icons.check_circle_outline
                          : Icons.place_outlined,
                      color: cellColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cell.cellDisplayName.isNotEmpty
                              ? cell.cellDisplayName
                              : 'Ячейка: ${cell.cellCode}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cell.isPlaced
                              ? '✅ Размещено'
                              : 'Собрано: ${cell.doneCount} / ${cell.totalItems}',
                          style: TextStyle(
                            color: cell.isPlaced ? Colors.green : Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    cell.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white38,
                  ),
                ],
              ),
            ),
          ),
          // Контент ячейки (разворачиваемый)
          if (cell.isExpanded) ...[
            const Divider(color: Colors.white12, height: 1),
            ...cell.items.map((item) => _buildItemRow(item, state, vm)),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Строка товара внутри ячейки
  // ---------------------------------------------------------------------------

  Widget _buildItemRow(AssemblyItemVm item, OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final statusColor = item.isMissing
        ? Colors.redAccent
        : (item.isPicked ? Colors.greenAccent.shade400 : Colors.white54);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Row(
        children: [
          // Индикатор статуса
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12, top: 4),
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          // Информация о товаре
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName.isNotEmpty ? item.itemName : 'Товар #${item.itemId}',
                  style: TextStyle(
                    color: item.isDone ? Colors.white54 : Colors.white,
                    fontSize: 13,
                    decoration: item.isMissing ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.statusText} · ${item.collectedQuantity}/${item.quantity} шт.',
                  style: TextStyle(color: statusColor, fontSize: 11),
                ),
              ],
            ),
          ),
          // Кнопка «Отсутствует» (только в режиме Сбора для непроцессированных товаров)
          if (state.mode == AssemblyMode.pick && !item.isDone)
            TextButton(
              onPressed: () => _showReportMissingDialog(item, vm),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Нет', style: TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Состояние «всё размещено» — можно завершить задачу
  // ---------------------------------------------------------------------------

  Widget _buildCompletionState(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 52),
            ),
            const SizedBox(height: 24),
            const Text(
              'Все ячейки заполнены!',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Вы можете завершить задачу сборки',
              style: TextStyle(color: Colors.white54, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: state.isLoading ? null : () => _handleCompleteTask(vm),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.done_all, color: Colors.white),
              label: Text(
                state.isLoading ? 'Завершение...' : 'Завершить задачу',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Поле ввода штрихкода
  // ---------------------------------------------------------------------------

  Widget _buildBarcodeInput(OrderAssemblyState state, OrderAssemblyViewModel vm) {
    final isPick = state.mode == AssemblyMode.pick;
    final activeColor = isPick ? _pickColor : _placeColor;
    final hint = isPick ? 'Штрихкод товара...' : 'Код ячейки выдачи...';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          // Иконка режима
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPick ? Icons.qr_code_scanner : Icons.grid_view,
              color: activeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          // Поле ввода
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: activeColor, width: 1.5),
                ),
              ),
              onSubmitted: (value) => _handleBarcodeSubmit(value, state, vm),
            ),
          ),
          const SizedBox(width: 10),
          // Кнопка подтверждения
          ElevatedButton(
            onPressed: () => _handleBarcodeSubmit(_barcodeController.text, state, vm),
            style: ElevatedButton.styleFrom(
              backgroundColor: activeColor,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size(0, 40),
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Обработчики событий
  // ---------------------------------------------------------------------------

  /// Обрабатывает ввод штрихкода (товар или ячейка, в зависимости от режима)
  Future<void> _handleBarcodeSubmit(
      String value, OrderAssemblyState state, OrderAssemblyViewModel vm) async {
    final barcode = value.trim();
    if (barcode.isEmpty) return;

    _barcodeController.clear();
    _barcodeFocusNode.requestFocus();

    (bool, String) result;

    if (state.mode == AssemblyMode.pick) {
      result = await vm.processScanPick(barcode);
    } else {
      result = await vm.processScanPlace(barcode);
    }

    final (success, message) = result;

    if (!mounted) return;

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

  /// Диалог отметки товара как отсутствующего
  Future<void> _showReportMissingDialog(AssemblyItemVm item, OrderAssemblyViewModel vm) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgGray950,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Товар отсутствует',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.itemName.isNotEmpty ? item.itemName : 'Товар #${item.itemId}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 16),
            const Text(
              'Причина отсутствия:',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reasonController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Например: не обнаружен на складе',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF141414),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Укажите причину'), behavior: SnackBarBehavior.floating),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Подтвердить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final (success, message) = await vm.reportMissingItem(item.lineId, reasonController.text.trim());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.orange.shade700 : Colors.redAccent.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Завершение задачи с подтверждением
  Future<void> _handleCompleteTask(OrderAssemblyViewModel vm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _bgGray950,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Завершение задачи', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Все ячейки обработаны. Завершить задачу сборки?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Завершить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final (success, message) = await vm.completeTask();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      Logger.i('ActiveAssemblyScreen: задача завершена, возврат на список задач');
      context.pop(); // Возврат на экран выбора задач
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent.shade700,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}
