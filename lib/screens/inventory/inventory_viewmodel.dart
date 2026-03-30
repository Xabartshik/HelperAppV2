import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../core/network/api_client.dart';
import '../../core/models/inventory/inventory_dtos.dart';
import '../../core/utils/logger.dart';

class InventoryItemVm {
  final int itemId;
  final int? lineId;
  final String itemName;
  final String positionCode;
  final int? expectedQuantity;
  int? actualQuantity;

  InventoryItemVm({
    required this.itemId,
    this.lineId,
    required this.itemName,
    required this.positionCode,
    this.expectedQuantity,
    this.actualQuantity,
  });

  bool get isCompleted => actualQuantity != null;

  String get statusText {
    if (actualQuantity == null) return "Не проверено";
    if (expectedQuantity == null) return "⚠ Неожиданный товар";
    if (actualQuantity == 0) return "⚠ Отсутствует";
    if (actualQuantity == expectedQuantity) return "✓ Совпадение";
    final diff = actualQuantity! - expectedQuantity!;
    return diff > 0 ? "⚠ Излишек: +$diff" : "⚠ Недостача: $diff";
  }
}

class InventoryGroupVm {
  final String positionCode;
  final List<InventoryItemVm> items;
  bool isExpanded;

  InventoryGroupVm({
    required this.positionCode,
    required this.items,
    this.isExpanded = false,
  });

  int get itemCount => items.length;
  int get expectedTotalQuantity => items.fold(0, (sum, i) => sum + (i.expectedQuantity ?? 0));
  int get actualTotalQuantity => items.fold(0, (sum, i) => sum + (i.actualQuantity ?? 0));
  int get scannedCount => items.where((i) => i.actualQuantity != null).length;
}

class InventoryState {
  final bool isLoading;
  final String errorMessage;

  final int workerId;
  final int assignmentId;

  final String zoneCode;
  final DateTime? initiatedAt;
  final String status;
  final String description;

  final int totalItems;
  final int scannedItemsCount;
  final int varianceCount;
  final bool hasVariances;

  final List<InventoryGroupVm> groupedItems;

  const InventoryState({
    this.isLoading = false,
    this.errorMessage = '',
    required this.workerId,
    required this.assignmentId,
    this.zoneCode = '',
    this.initiatedAt,
    this.status = '',
    this.description = '',
    this.totalItems = 0,
    this.scannedItemsCount = 0,
    this.varianceCount = 0,
    this.hasVariances = false,
    this.groupedItems = const [],
  });

  InventoryState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? zoneCode,
    DateTime? initiatedAt,
    String? status,
    String? description,
    int? totalItems,
    int? scannedItemsCount,
    int? varianceCount,
    bool? hasVariances,
    List<InventoryGroupVm>? groupedItems,
  }) {
    return InventoryState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      workerId: workerId,
      assignmentId: assignmentId,
      zoneCode: zoneCode ?? this.zoneCode,
      initiatedAt: initiatedAt ?? this.initiatedAt,
      status: status ?? this.status,
      description: description ?? this.description,
      totalItems: totalItems ?? this.totalItems,
      scannedItemsCount: scannedItemsCount ?? this.scannedItemsCount,
      varianceCount: varianceCount ?? this.varianceCount,
      hasVariances: hasVariances ?? this.hasVariances,
      groupedItems: groupedItems ?? this.groupedItems,
    );
  }
}

typedef InventoryArgs = ({int workerId, int assignmentId});

final inventoryViewModelProvider = AutoDisposeNotifierProviderFamily<InventoryViewModel, InventoryState, InventoryArgs>(() {
  return InventoryViewModel();
});

class InventoryViewModel extends AutoDisposeFamilyNotifier<InventoryState, InventoryArgs> {
  @override
  InventoryState build(InventoryArgs args) {
    final workerId = args.workerId;
    final assignmentId = args.assignmentId;
    
    Future.microtask(() => loadDetailsAsync());

    return InventoryState(
      workerId: workerId,
      assignmentId: assignmentId,
    );
  }

  void _triggerRebuild() {
    _updateStatistics();
    state = state.copyWith(groupedItems: [...state.groupedItems]);
  }

  void _updateStatistics() {
    final allItems = state.groupedItems.expand((g) => g.items).toList();
    final total = allItems.length;
    final scanned = allItems.where((i) => i.actualQuantity != null).length;
    final variance = allItems.where((i) => i.actualQuantity != null && i.actualQuantity != i.expectedQuantity).length;
    
    state = state.copyWith(
      totalItems: total,
      scannedItemsCount: scanned,
      varianceCount: variance,
      hasVariances: variance > 0,
    );
  }

  Future<void> loadDetailsAsync() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final client = ref.read(apiClientProvider);
      final dto = await client.getInventoryTaskDetailsAsync(state.workerId, state.assignmentId);

      if (dto == null) {
        state = state.copyWith(errorMessage: 'Сервер вернул пустой ответ', isLoading: false);
        return;
      }

      final groupedMap = groupBy(dto.items, (InventoryItemDto item) => item.positionCode);
      final groupedItems = groupedMap.entries.map((entry) {
        final positionCode = entry.key;
        final items = entry.value.map((item) => InventoryItemVm(
          itemId: item.itemId,
          lineId: item.lineId,
          itemName: item.itemName,
          positionCode: positionCode,
          expectedQuantity: item.expectedQuantity,
          actualQuantity: null,
        )).toList();

        return InventoryGroupVm(positionCode: positionCode, items: items);
      }).toList();

      groupedItems.sort((a, b) => a.positionCode.compareTo(b.positionCode));

      state = state.copyWith(
        initiatedAt: dto.initiatedAt,
        zoneCode: dto.zoneCode,
        status: 'В процессе',
        description: 'Инвентаризация зоны ${dto.zoneCode}',
        groupedItems: groupedItems,
      );
      
      _updateStatistics();

    } catch (e) {
      Logger.e('Ошибка при загрузке деталей инвентаризации', e);
      state = state.copyWith(errorMessage: 'Ошибка загрузки: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleGroupExpansion(InventoryGroupVm group) {
    group.isExpanded = !group.isExpanded;
    _triggerRebuild();
  }

  void markAsAbsent(InventoryItemVm item) {
    item.actualQuantity = 0;
    Logger.i('Товар ${item.itemName} (ID: ${item.itemId}) отмечен как отсутствующий');
    _triggerRebuild();
  }

  void setManualQuantity(InventoryItemVm item, int quantity) {
    item.actualQuantity = quantity;
    Logger.i('Вручную введено количество для товара ${item.itemName} (ID: ${item.itemId}): $quantity');
    _triggerRebuild();
  }

  /// Обрабатывает отсканированный штрихкод.
  /// Возвращает true и сообщение, если товар успешно найден и добавлен.
  Future<(bool, String)> processScannedCodeAsync(String positionCode, String barcode) async {
    if (barcode.trim().isEmpty) return (false, 'Пустой код');

    final group = state.groupedItems.firstWhereOrNull((g) => g.positionCode == positionCode);
    if (group == null) return (false, 'Позиция не найдена в текущей задаче');

    final itemId = int.tryParse(barcode);
    if (itemId == null) return (false, 'Неверный формат: $barcode');

    final item = group.items.firstWhereOrNull((i) => i.itemId == itemId);

    if (item == null) {
      // Товар не найден среди ожидаемых - необходимо API
      try {
        final client = ref.read(apiClientProvider);
        final itemInfo = await client.getItemInfoAsync(itemId);
        
        if (itemInfo == null) return (false, 'Товар с ID $itemId не найден в базе');

        // В UI нужно будет вызвать диалог "Учесть товар?".
        // Здесь мы сигнализируем UI, что требуется подтверждение:
        return (false, 'REQUIRE_CONFIRMATION|${itemInfo.name}|$itemId');
      } catch (e) {
        Logger.e('Ошибка при получении информации о товаре $itemId', e);
        return (false, 'Ошибка: $e');
      }
    }

    item.actualQuantity = (item.actualQuantity ?? 0) + 1;
    Logger.i('Товар ${item.itemName} (ID: $itemId) учтен. Факт=${item.actualQuantity}');
    _triggerRebuild();

    return (true, '✓ ${item.itemName}: ${item.actualQuantity}');
  }

  void addUnexpectedItem(String positionCode, int itemId, String itemName) {
    final group = state.groupedItems.firstWhereOrNull((g) => g.positionCode == positionCode);
    if (group == null) return;

    final newItem = InventoryItemVm(
      itemId: itemId,
      itemName: itemName,
      positionCode: positionCode,
      actualQuantity: 1, // 1 т.к. только что отсканировали
    );

    group.items.add(newItem);
    _triggerRebuild();
  }

  Future<CompleteAssignmentResultDto?> completeInventoryAsync() async {
    final allItems = state.groupedItems.expand((g) => g.items).toList();
    
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);

      final lines = allItems.map((item) => CompleteAssignmentLineDto(
        lineId: item.lineId,
        itemId: item.itemId,
        positionCode: item.positionCode,
        actualQuantity: item.actualQuantity ?? 0, // Непроверенные = 0
      )).toList();

      final dto = CompleteAssignmentDto(
        assignmentId: state.assignmentId,
        workerId: state.workerId,
        lines: lines,
      );

      final result = await client.completeInventoryAssignmentAsync(dto);
      return result;
    } catch (e) {
      Logger.e('Ошибка при завершении инвентаризации', e);
      state = state.copyWith(errorMessage: 'Ошибка завершения: $e');
      return null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
