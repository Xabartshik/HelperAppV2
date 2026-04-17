import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order_assembly/order_assembly_dtos.dart';
import '../../core/utils/logger.dart';

// ---------------------------------------------------------------------------
// Режим работы экрана сборки
// ---------------------------------------------------------------------------

/// Режим работы экрана ActiveAssemblyScreen
enum AssemblyMode {
  /// Сотрудник собирает товары из хранилища в тележку поштучно
  pick,

  /// Все товары собраны — сотрудник размещает их по ячейкам выдачи
  place,
}

// ---------------------------------------------------------------------------
// View-модели (VM) для UI-отображения
// ---------------------------------------------------------------------------

/// VM для отображения одного товара на экране
class AssemblyItemVm {
  final int lineId;
  final int itemId;
  final String itemName;
  final String barcode;
  final int quantity;
  int collectedQuantity;
  OrderAssemblyLineStatus status;

  AssemblyItemVm({
    required this.lineId,
    required this.itemId,
    required this.itemName,
    required this.barcode,
    required this.quantity,
    required this.collectedQuantity,
    required this.status,
  });

  bool get isPicked => status == OrderAssemblyLineStatus.picked || status == OrderAssemblyLineStatus.placed;
  bool get isPlaced => status == OrderAssemblyLineStatus.placed;
  bool get isMissing => status == OrderAssemblyLineStatus.discrepancy;
  bool get isDone => isPicked || isMissing;

  /// Текстовое отображение статуса
  String get statusText {
    switch (status) {
      case OrderAssemblyLineStatus.pending:
        return '⏳ Ожидает';
      case OrderAssemblyLineStatus.picked:
        return '✓ Собран';
      case OrderAssemblyLineStatus.placed:
        return '📦 Размещён';
      case OrderAssemblyLineStatus.discrepancy:
        return '✗ Отсутствует';
    }
  }
}

/// VM для отображения одной ячейки выдачи с её товарами
class CellPlacementVm {
  final int assignmentId;
  final int targetPositionId;
  final String cellCode;
  final String cellDisplayName;
  final List<AssemblyItemVm> items;
  bool isExpanded;
  bool isPlaced;

  CellPlacementVm({
    required this.assignmentId,
    required this.targetPositionId,
    required this.cellCode,
    required this.cellDisplayName,
    required this.items,
    this.isExpanded = true,
    this.isPlaced = false,
  });

  int get totalItems => items.length;
  int get pickedCount => items.where((i) => i.isPicked).length;
  int get missingCount => items.where((i) => i.isMissing).length;
  int get doneCount => items.where((i) => i.isDone).length;
  bool get allDone => doneCount == totalItems;
}

// ---------------------------------------------------------------------------
// Стейт экрана сборки
// ---------------------------------------------------------------------------

/// Иммутабельное состояние экрана сборки заказов
class OrderAssemblyState {
  final bool isLoading;
  final String errorMessage;

  /// Режим работы: Сбор или Размещение
  final AssemblyMode mode;

  /// Текущая задача
  final WorkerAssemblyTaskDto? task;

  /// Сгруппированные ячейки с товарами
  final List<CellPlacementVm> cells;

  /// Флаг: все товары собраны (можно переходить к размещению)
  final bool allItemsPicked;

  /// Флаг: все ячейки заполнены (можно завершать задачу)
  final bool allCellsPlaced;

  const OrderAssemblyState({
    this.isLoading = false,
    this.errorMessage = '',
    this.mode = AssemblyMode.pick,
    this.task,
    this.cells = const [],
    this.allItemsPicked = false,
    this.allCellsPlaced = false,
  });

  OrderAssemblyState copyWith({
    bool? isLoading,
    String? errorMessage,
    AssemblyMode? mode,
    WorkerAssemblyTaskDto? task,
    List<CellPlacementVm>? cells,
    bool? allItemsPicked,
    bool? allCellsPlaced,
  }) {
    return OrderAssemblyState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      mode: mode ?? this.mode,
      task: task ?? this.task,
      cells: cells ?? this.cells,
      allItemsPicked: allItemsPicked ?? this.allItemsPicked,
      allCellsPlaced: allCellsPlaced ?? this.allCellsPlaced,
    );
  }

  /// Общий прогресс сбора: количество собранных / всего
  int get totalItems => cells.fold(0, (s, c) => s + c.totalItems);
  int get pickedItems => cells.fold(0, (s, c) => s + c.pickedCount + c.missingCount);
  int get placedCells => cells.where((c) => c.isPlaced).length;
}

// ---------------------------------------------------------------------------
// Провайдер ViewModel
// ---------------------------------------------------------------------------

typedef OrderAssemblyArgs = ({int assignmentId, int userId});

final orderAssemblyViewModelProvider =
    AutoDisposeNotifierProviderFamily<OrderAssemblyViewModel, OrderAssemblyState, OrderAssemblyArgs>(
  () => OrderAssemblyViewModel(),
);

// ---------------------------------------------------------------------------
// ViewModel
// ---------------------------------------------------------------------------

/// ViewModel для экрана ActiveAssemblyScreen.
/// Управляет стейт-машиной режимов Pick → Place и взаимодействием с API.
class OrderAssemblyViewModel
    extends AutoDisposeFamilyNotifier<OrderAssemblyState, OrderAssemblyArgs> {
  @override
  OrderAssemblyState build(OrderAssemblyArgs arg) {
    // Загружаем данные после инициализации
    Future.microtask(() => loadTask());
    return const OrderAssemblyState();
  }

  // -----------------------------------------------------------------------
  // Загрузка данных
  // -----------------------------------------------------------------------

  /// Загружает задачу по assignmentId из аргументов провайдера
  Future<void> loadTask() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final client = ref.read(apiClientProvider);
      final tasks = await client.getOrderAssemblyTasksAsync(arg.userId);

      final task = tasks.firstWhereOrNull((t) => t.assignmentId == arg.assignmentId);

      if (task == null) {
        final availableIds = tasks.map((t) => t.assignmentId).join(', ');
        Logger.w('OrderAssembly: задача ${arg.assignmentId} не найдена для userId=${arg.userId}. Доступные ID: [$availableIds]');
        state = state.copyWith(
          errorMessage: 'Задача не найдена или уже завершена. Доступные задачи: $availableIds',
          isLoading: false,
        );
        return;
      }

      final cells = task.cellPlacements.map((c) => _mapToCellVm(c, task.assignmentId)).toList();

      state = state.copyWith(
        task: task,
        cells: cells,
        isLoading: false,
      );

      _recalculateProgress();
      Logger.i('OrderAssembly: задача ${task.taskNumber} загружена, ячеек: ${cells.length}');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка загрузки задачи ${arg.assignmentId}', e, stack);
      state = state.copyWith(
        errorMessage: 'Ошибка загрузки: $e',
        isLoading: false,
      );
    }
  }

  // -----------------------------------------------------------------------
  // Режим Сбора (Pick Mode)
  // -----------------------------------------------------------------------

  /// Обрабатывает отсканированный штрихкод товара в режиме Сбора.
  /// Возвращает (успех, сообщение).
  Future<(bool, String)> processScanPick(String barcode) async {
    if (state.mode != AssemblyMode.pick) {
      return (false, 'Неверный режим: ожидается режим «Сбор»');
    }

    if (barcode.trim().isEmpty) return (false, 'Пустой штрихкод');

    // Ищем товар по штрихкоду среди всех ячеек
    AssemblyItemVm? foundItem;
    for (final cell in state.cells) {
      foundItem = cell.items.firstWhereOrNull(
        (i) => i.barcode == barcode && !i.isDone,
      );
      if (foundItem != null) break;
    }

    if (foundItem == null) {
      Logger.w('OrderAssembly: штрихкод $barcode не найден в задаче');
      return (false, 'Товар со штрихкодом «$barcode» не найден в задаче');
    }

    // Вызываем API
    try {
      final client = ref.read(apiClientProvider);
      await client.orderAssemblyScanPickAsync(foundItem.lineId, barcode);

      foundItem.collectedQuantity++;
      if (foundItem.collectedQuantity >= foundItem.quantity) {
        foundItem.status = OrderAssemblyLineStatus.picked;
        Logger.i('OrderAssembly: товар ${foundItem.itemName} полностью собран');
      }

      _recalculateProgress();
      _triggerRebuild();

      final isAllDone = state.allItemsPicked;
      final msg = '✓ ${foundItem.itemName} собран (${foundItem.collectedQuantity}/${foundItem.quantity})';
      
      // Возвращаем специальный флаг успеха, если это был последний товар в режиме сбора
      return (true, isAllDone ? 'FINISH:$msg' : msg);
    } catch (e) {
      Logger.e('OrderAssembly: ошибка scanPick barcode=$barcode', e);
      return (false, 'Ошибка сервера: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Режим Размещения (Place Mode)
  // -----------------------------------------------------------------------

  /// Обрабатывает сканирование кода ячейки в режиме Размещения.
  /// Возвращает (успех, сообщение).
  Future<(bool, String)> processScanPlace(String cellCode) async {
    if (state.mode != AssemblyMode.place) {
      return (false, 'Неверный режим: ожидается режим «Размещение»');
    }

    if (cellCode.trim().isEmpty) return (false, 'Пустой код ячейки');

    // Пытаемся найти ячейку по ID (если в коде число) или по строковому коду
    final scannedId = int.tryParse(cellCode.trim());
    
    final cell = state.cells.firstWhereOrNull(
      (c) => (scannedId != null && c.targetPositionId == scannedId) || 
             (c.cellCode == cellCode && !c.isPlaced),
    );

    if (cell == null) {
      Logger.w('OrderAssembly: ячейка $cellCode не найдена или уже размещена');
      return (false, 'Ячейка «$cellCode» не найдена или уже обработана');
    }

    // Вызываем API массового размещения
    try {
      final client = ref.read(apiClientProvider);
      await client.orderAssemblyScanPlaceBulkAsync(cell.assignmentId, cellCode);

      // Обновляем статусы товаров ячейки локально
      for (final item in cell.items) {
        if (item.isPicked) {
          item.status = OrderAssemblyLineStatus.placed;
        }
      }
      cell.isPlaced = true;

      _recalculateProgress();
      _triggerRebuild();

      Logger.i('OrderAssembly: ячейка $cellCode успешно размещена');
      final name = cell.cellDisplayName.isNotEmpty ? cell.cellDisplayName : cellCode;
      return (true, '📦 Ячейка «$name» размещена');
    } catch (e) {
      Logger.e('OrderAssembly: ошибка scanPlaceBulk cellCode=$cellCode', e);
      return (false, 'Ошибка сервера: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Отчёт об отсутствующем товаре
  // -----------------------------------------------------------------------

  /// Отмечает товар как отсутствующий и отправляет отчёт на сервер
  Future<(bool, String)> reportMissingItem(int lineId, String reason) async {
    if (lineId <= 0) return (false, 'Некорректный lineId');
    if (reason.trim().isEmpty) return (false, 'Укажите причину отсутствия');

    try {
      final client = ref.read(apiClientProvider);
      await client.orderAssemblyReportMissingAsync(lineId, reason);

      // Обновляем статус локально
      for (final cell in state.cells) {
        final item = cell.items.firstWhereOrNull((i) => i.lineId == lineId);
        if (item != null) {
          item.status = OrderAssemblyLineStatus.discrepancy;
          Logger.i('OrderAssembly: товар lineId=$lineId отмечен как отсутствующий');
          break;
        }
      }

      _recalculateProgress();
      _triggerRebuild();

      return (true, 'Товар отмечен как отсутствующий');
    } catch (e) {
      Logger.e('OrderAssembly: ошибка reportMissing lineId=$lineId', e);
      return (false, 'Ошибка: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Завершение задачи
  // -----------------------------------------------------------------------

  /// Завершает задачу сборки (вызывается, когда все ячейки заполнены)
  Future<(bool, String)> completeTask() async {
    if (state.task == null) return (false, 'Задача не загружена');

    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      await client.orderAssemblyCompleteAsync(state.task!.assignmentId);

      Logger.i('OrderAssembly: задача ${state.task!.assignmentId} завершена');
      state = state.copyWith(isLoading: false);
      return (true, '✅ Задача успешно завершена');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка completeTask', e, stack);
      state = state.copyWith(
        errorMessage: 'Ошибка завершения: $e',
        isLoading: false,
      );
      return (false, 'Ошибка завершения: $e');
    }
  }

  // -----------------------------------------------------------------------
  // UI-хелперы
  // -----------------------------------------------------------------------

  /// Переключает раскрытие/свёртку ячейки
  void toggleCellExpansion(CellPlacementVm cell) {
    cell.isExpanded = !cell.isExpanded;
    _triggerRebuild();
  }

  // -----------------------------------------------------------------------
  // Приватные методы
  // -----------------------------------------------------------------------

  /// Пересчитывает прогресс и при необходимости переключает режим Pick → Place
  void _recalculateProgress() {
    final allItems = state.cells.expand((c) => c.items).toList();
    final allDone = allItems.isNotEmpty && allItems.every((i) => i.isDone);
    final allPlaced = state.cells.isNotEmpty && state.cells.every((c) => c.isPlaced);

    // Возвращаем автоматическое переключение Pick -> Place, чтобы основной экран обновил UI.
    // При этом сканер все равно закроется из-за логики в AssemblyBarcodeScannerPage.
    final newMode = (allDone && state.mode == AssemblyMode.pick)
        ? AssemblyMode.place
        : state.mode;

    if (newMode == AssemblyMode.place && state.mode == AssemblyMode.pick) {
      Logger.i('OrderAssembly: все товары собраны, переход в состояние Размещения');
    }

    state = state.copyWith(
      allItemsPicked: allDone,
      allCellsPlaced: allPlaced,
      mode: newMode,
    );
  }

  /// Форсирует пересборку UI (для изменений изменяемых данных VM)
  void _triggerRebuild() {
    state = state.copyWith(cells: [...state.cells]);
  }

  /// Маппит DTO ячейки в VM
  CellPlacementVm _mapToCellVm(CellPlacementInfoDto dto, int assignmentId) {
    final items = dto.items
        .map((item) => AssemblyItemVm(
              lineId: item.lineId,
              itemId: item.itemId,
              itemName: item.itemName,
              barcode: item.barcode,
              quantity: item.quantity,
              collectedQuantity: item.pickedQuantity, 
              status: item.status,
            ))
        .toList();

    return CellPlacementVm(
      assignmentId: assignmentId,
      targetPositionId: dto.targetPositionId,
      cellCode: dto.cellCode ?? '',
      cellDisplayName: dto.cellDisplayName ?? dto.cellCode ?? '',
      items: items,
    );
  }
}
