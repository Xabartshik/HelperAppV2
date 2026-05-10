// lib/screens/order_assembly/order_assembly_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order_assembly/order_assembly_dtos.dart';
import '../../core/utils/logger.dart';

// ---------------------------------------------------------------------------
// Режим работы экрана сборки
// ---------------------------------------------------------------------------

/// Режим работы экрана ActiveAssemblyScreen
enum AssemblyMode {
  /// Сотрудник собирает товары из хранилища в тележку поштучно[cite: 4]
  pick,

  /// Все товары собраны — сотрудник размещает их по ячейкам выдачи[cite: 4]
  place,
}

// ---------------------------------------------------------------------------
// View-модели (VM) для UI-отображения
// ---------------------------------------------------------------------------

/// VM для отображения одного товара на экране[cite: 4]
class AssemblyItemVm {
  final int lineId;
  final int itemId;
  final String itemName;
  final String barcode;
  final String sourceCellCode;
  final int quantity;
  int collectedQuantity;
  OrderAssemblyLineStatus status;

  AssemblyItemVm({
    required this.lineId,
    required this.itemId,
    required this.itemName,
    required this.sourceCellCode,
    required this.barcode,
    required this.quantity,
    required this.collectedQuantity,
    required this.status,
  });

  bool get isPicked => status == OrderAssemblyLineStatus.picked || status == OrderAssemblyLineStatus.placed;
  bool get isPlaced => status == OrderAssemblyLineStatus.placed;
  bool get isMissing => status == OrderAssemblyLineStatus.discrepancy;
  bool get isDone => isPicked || isMissing;

  /// Текстовое отображение статуса[cite: 4]
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

/// VM для отображения одной ячейки выдачи с её товарами[cite: 4]
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

/// Иммутабельное состояние экрана сборки заказов[cite: 4]
class OrderAssemblyState {
  final bool isLoading;
  final String errorMessage;

  /// Режим работы: Сбор или Размещение[cite: 4]
  final AssemblyMode mode;
  final bool isCooperative; 
  final String? partnerName;
  final AssignmentStatus? partnerStatus;
  
  /// Текущая задача сборки[cite: 4]
  final WorkerAssemblyTaskDto? task;

  /// Тип доставки (загружается отдельно из деталей заказа)[cite: 4]
  final String? deliveryType;

  /// Сгруппированные ячейки с товарами[cite: 4]
  final List<CellPlacementVm> cells;

  /// Флаг: все товары собраны (можно переходить к размещению)[cite: 4]
  final bool allItemsPicked;

  /// Флаг: все ячейки заполнены (можно завершать задачу)[cite: 4]
  final bool allCellsPlaced;

  const OrderAssemblyState({
    this.isLoading = false,
    this.errorMessage = '',
    this.mode = AssemblyMode.pick,
    this.task,
    this.deliveryType, 
    this.cells = const [],
    this.allItemsPicked = false,
    this.allCellsPlaced = false,
    this.isCooperative = false,
    this.partnerName,
    this.partnerStatus,
  });

  OrderAssemblyState copyWith({
    bool? isLoading,
    String? errorMessage,
    AssemblyMode? mode,
    WorkerAssemblyTaskDto? task,
    String? deliveryType,
    List<CellPlacementVm>? cells,
    bool? allItemsPicked,
    bool? allCellsPlaced,
    bool? isCooperative,
    String? partnerName,
    AssignmentStatus? partnerStatus,
  }) {
    return OrderAssemblyState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      mode: mode ?? this.mode,
      task: task ?? this.task,
      deliveryType: deliveryType ?? this.deliveryType,
      cells: cells ?? this.cells,
      allItemsPicked: allItemsPicked ?? this.allItemsPicked,
      allCellsPlaced: allCellsPlaced ?? this.allCellsPlaced,
      isCooperative: isCooperative ?? this.isCooperative,
      partnerName: partnerName ?? this.partnerName,
      partnerStatus: partnerStatus ?? this.partnerStatus,
    );
  }

  /// Общий прогресс сбора: количество собранных / всего[cite: 4]
  int get totalItems => cells.fold(0, (s, c) => s + c.totalItems);
  int get pickedItems => cells.fold(0, (s, c) => s + c.pickedCount + c.missingCount);
  int get placedCells => cells.where((c) => c.isPlaced).length;

  /// Проверка на экспресс-доставку[cite: 4]
  bool get isExpress => deliveryType == 'Express';
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

class OrderAssemblyViewModel
    extends AutoDisposeFamilyNotifier<OrderAssemblyState, OrderAssemblyArgs> {
  @override
  OrderAssemblyState build(OrderAssemblyArgs arg) {
    Future.microtask(() => loadTask());
    return const OrderAssemblyState();
  }

  // -----------------------------------------------------------------------
  // Загрузка данных
  // -----------------------------------------------------------------------

  Future<void> loadTask() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final client = ref.read(apiClientProvider);
      
      // 1. Загружаем детали задачи сборки[cite: 4]
      final task = await client.getOrderAssemblyTaskDetailsAsync(arg.assignmentId);

      if (task == null) {
        Logger.w('OrderAssembly: детали задачи ${arg.assignmentId} не найдены');
        state = state.copyWith(
          errorMessage: 'Задача не найдена или уже завершена',
          isLoading: false,
        );
        return;
      }

      // 2. Загружаем детали заказа, чтобы определить DeliveryType[cite: 4]
      String? fetchedDeliveryType;
      try {
        final orderDetails = await client.getOrderByIdAsync(task.orderId);
        fetchedDeliveryType = orderDetails.deliveryType;
      } catch (e) {
        Logger.w('OrderAssembly: Не удалось загрузить детали заказа ${task.orderId} для определения типа доставки. Ошибка: $e');
      }

      final cells = task.cellPlacements.map((c) => _mapToCellVm(c, task.assignmentId)).toList();

      state = state.copyWith(
        task: task,
        deliveryType: fetchedDeliveryType, 
        cells: cells,
        isCooperative: task.isCooperative, 
        partnerName: task.partnerName,     
        partnerStatus: task.partnerStatus, 
        isLoading: false,
      );

      _recalculateProgress();
      Logger.i('OrderAssembly: задача ${task.taskNumber} загружена. Кооперация: ${task.isCooperative}, Тип: $fetchedDeliveryType');
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

Future<(bool, String)> processScanPick(String barcode) async {
    if (state.mode != AssemblyMode.pick) {
      return (false, 'Неверный режим: ожидается режим «Сбор»');
    }

    final trimmedBarcode = barcode.trim();
    if (trimmedBarcode.isEmpty) return (false, 'Пустой штрихкод');

    AssemblyItemVm? foundItem;
    // Ищем товар в ячейках сборки
    for (final cell in state.cells) {
      foundItem = cell.items.firstWhereOrNull(
        (i) => i.barcode == trimmedBarcode && !i.isDone,
      );
      if (foundItem != null) break;
    }

    if (foundItem == null) {
      Logger.w('OrderAssembly: штрихкод $trimmedBarcode не найден в задаче');
      return (false, 'Товар со штрихкодом «$trimmedBarcode» не найден в задаче');
    }

    try {
      final client = ref.read(apiClientProvider);
      
      // Вызываем специфичный метод контроллера сборки
      await client.scanAssemblyPickAsync(arg.assignmentId, foundItem.lineId, trimmedBarcode);

      // Локальное обновление для мгновенного отклика UI
      foundItem.collectedQuantity++;
      if (foundItem.collectedQuantity >= foundItem.quantity) {
        foundItem.status = OrderAssemblyLineStatus.picked;
        Logger.i('OrderAssembly: товар ${foundItem.itemName} полностью собран');
      }

      _recalculateProgress();
      _triggerRebuild();

      final isAllDone = state.allItemsPicked;
      final msg = '✓ ${foundItem.itemName} собран (${foundItem.collectedQuantity}/${foundItem.quantity})';
      
      return (true, isAllDone ? 'FINISH:$msg' : msg);
    } catch (e) {
      Logger.e('OrderAssembly: ошибка scanPick barcode=$trimmedBarcode', e);
      return (false, 'Ошибка сервера: $e');
    }
  }
  // -----------------------------------------------------------------------
  // Режим Размещения (Place Mode)
  // -----------------------------------------------------------------------

Future<(bool, String)> processScanPlace(String scannedCellCode) async {
    if (state.mode != AssemblyMode.place) {
      return (false, 'Неверный режим: ожидается режим «Размещение»');
    }

    final trimmedCode = scannedCellCode.trim();
    if (trimmedCode.isEmpty) return (false, 'Пустой код ячейки');

    // Ищем ячейку в стейте по строковому коду (QR-коду)
    final cell = state.cells.firstWhereOrNull(
      (c) => c.cellCode == trimmedCode && !c.isPlaced,
    );

    if (cell == null) {
      Logger.w('OrderAssembly: ячейка $trimmedCode не найдена или уже размещена');
      return (false, 'Ячейка «$trimmedCode» не найдена или уже обработана');
    }

    try {
      final client = ref.read(apiClientProvider);
      
      // Отправляем скан в контроллер сборки. 
      // Передаем ID первой линии этой ячейки (бэкенд привяжет всё назначение к этой позиции).
      await client.scanAssemblyPlaceAsync(arg.assignmentId, cell.items.first.lineId, trimmedCode);

      // Массово обновляем статус всех товаров в этой ячейке локально
      for (final item in cell.items) {
        if (item.isPicked) {
          item.status = OrderAssemblyLineStatus.placed;
        }
      }
      cell.isPlaced = true;

      _recalculateProgress();
      _triggerRebuild();

      Logger.i('OrderAssembly: ячейка $trimmedCode успешно размещена');
      final name = cell.cellDisplayName.isNotEmpty ? cell.cellDisplayName : trimmedCode;
      final isAllPlaced = state.allCellsPlaced;
      final msg = '📦 Ячейка «$name» размещена';
      
      // Если все готово, добавляем префикс FINISH:
      return (true, isAllPlaced ? 'FINISH:$msg' : msg);
    } catch (e) {
      Logger.e('OrderAssembly: ошибка scanPlace cellCode=$trimmedCode', e);
      return (false, 'Ошибка сервера: $e');
    }
  }
  // -----------------------------------------------------------------------
  // Экспресс-выдача (Express Handover)
  // -----------------------------------------------------------------------

  /// Обрабатывает сканирование QR-кода клиента для экспресс-выдачи[cite: 4]
  Future<(bool, String)> processExpressHandover(String qrToken) async {
    if (state.mode != AssemblyMode.place) {
      return (false, 'Неверный режим: ожидается размещение/выдача');
    }

    if (qrToken.trim().isEmpty) return (false, 'Пустой QR-код');

    try {
      final client = ref.read(apiClientProvider);
      
      // Отправка запроса на сервер для валидации выдачи[cite: 4]
      await client.orderAssemblyExpressHandoverAsync(arg.assignmentId, qrToken);

      // Обновляем локальное состояние[cite: 4]
      state = state.copyWith(allCellsPlaced: true);
      
      return (true, 'FINISH_EXPRESS:✅ Товар передан клиенту, заказ завершен!');
    } catch (e) {
      Logger.e('OrderAssembly: ошибка express handover qr=$qrToken', e);
      return (false, 'Ошибка валидации QR: $e');
    }
  }

  // -----------------------------------------------------------------------
  // Остальные методы
  // -----------------------------------------------------------------------

  Future<(bool, String)> reportMissingItem(int lineId, String reason) async {
    if (lineId <= 0) return (false, 'Некорректный lineId');
    if (reason.trim().isEmpty) return (false, 'Укажите причину отсутствия');

    try {
      final client = ref.read(apiClientProvider);
      await client.orderAssemblyReportMissingAsync(lineId, reason);

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

  Future<(bool, String)> completeTask() async {
    if (state.task == null) return (false, 'Задача не загружена');

    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      await client.workerTaskCompleteAsync(state.task!.taskId, arg.userId);

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

  void toggleCellExpansion(CellPlacementVm cell) {
    cell.isExpanded = !cell.isExpanded;
    _triggerRebuild();
  }

  void _recalculateProgress() {
    final allItems = state.cells.expand((c) => c.items).toList();
    final allDone = allItems.isNotEmpty && allItems.every((i) => i.isDone);
    final allPlaced = state.cells.isNotEmpty && state.cells.every((c) => c.isPlaced);

    final newMode = (allDone && state.mode == AssemblyMode.pick)
        ? AssemblyMode.place
        : state.mode;

    state = state.copyWith(
      allItemsPicked: allDone,
      allCellsPlaced: allPlaced,
      mode: newMode,
    );
  }

  void _triggerRebuild() {
    state = state.copyWith(cells: [...state.cells]);
  }

  CellPlacementVm _mapToCellVm(CellPlacementInfoDto dto, int assignmentId) {
    final items = dto.items
        .map((item) => AssemblyItemVm(
              lineId: item.lineId,
              itemId: item.itemId,
              itemName: item.itemName ?? '',
              barcode: item.barcode ?? '',
              sourceCellCode: item.sourceCellCode ?? 'Неизвестная ячейка',
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