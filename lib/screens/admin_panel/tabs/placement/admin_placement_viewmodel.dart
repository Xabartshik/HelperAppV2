import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/inventory/inventory_dtos.dart';
import 'package:helper_app/core/models/item/item_dto.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/inventory/position_cell_dto.dart';

class AdminPlacementState {
  final bool isLoading;
  final List<ItemDto> allItems; 
  final List<PositionCellDto> allPositions; 
  final List<ItemPositionDto> stock; // Остатки: ItemId + PositionId + Qty
  
  final String contentSearchQuery; // Фильтр по названию товара внутри ячеек
  final int? selectedBranchId;
  final ItemDto? itemToPlace; 

  AdminPlacementState({
    this.isLoading = false,
    this.allItems = const [],
    this.allPositions = const [],
    this.stock = const [],
    this.contentSearchQuery = '',
    this.selectedBranchId,
    this.itemToPlace,
  });

// Получить список товаров в конкретной ячейке
  List<Map<String, dynamic>> getItemsInPosition(int positionId) {
    final itemsInPos = stock.where((s) => s.positionId == positionId);
    return itemsInPos.map((s) {
      final item = allItems.firstWhere(
        (i) => i.itemId == s.itemId, 
        orElse: () => ItemDto(
          name: "ID: ${s.itemId}", 
          itemId: s.itemId,
          weight: 0.0,
          length: 0.0,
          width: 0.0,
          height: 0.0,
          price: 0.0,
        ),
      );
      return {
        'name': item.name,
        'quantity': s.quantity,
      };
    }).toList();
  }

  // УМНАЯ ФИЛЬТРАЦИЯ ТОПОЛОГИИ
  List<PositionCellDto> get filteredPositions {
    var list = allPositions;

    if (selectedBranchId != null) {
      list = list.where((p) => p.branchId == selectedBranchId).toList();
    }

    // Если введен запрос по содержимому
    if (contentSearchQuery.isNotEmpty) {
      final q = contentSearchQuery.toLowerCase();
      
      // Находим ID всех товаров, подходящих под поиск
      final matchingItemIds = allItems
          .where((i) => i.name.toLowerCase().contains(q))
          .map((i) => i.itemId)
          .toSet();

      // Находим ID всех позиций, где лежат эти товары
      final positionsWithMatch = stock
          .where((s) => matchingItemIds.contains(s.itemId))
          .map((s) => s.positionId)
          .toSet();

      // Оставляем только эти позиции
      list = list.where((p) => positionsWithMatch.contains(p.positionId)).toList();
    }

    // Сортировка (Зона -> Стеллаж -> Полка)
    list.sort((a, b) {
      int cmp = a.zoneCode.compareTo(b.zoneCode);
      if (cmp != 0) return cmp;
      int flsA = int.tryParse(a.flsNumber) ?? 0;
      int flsB = int.tryParse(b.flsNumber) ?? 0;
      cmp = flsA.compareTo(flsB);
      if (cmp == 0) cmp = (int.tryParse(a.secondLevelStorage ?? '0') ?? 0)
          .compareTo(int.tryParse(b.secondLevelStorage ?? '0') ?? 0);
      return cmp;
    });

    return list;
  }

  AdminPlacementState copyWith({
    bool? isLoading,
    List<ItemDto>? allItems,
    List<PositionCellDto>? allPositions,
    List<ItemPositionDto>? stock,
    String? contentSearchQuery,
    int? selectedBranchId,
    ItemDto? itemToPlace,
    bool clearItemToPlace = false,
  }) {
    return AdminPlacementState(
      isLoading: isLoading ?? this.isLoading,
      allItems: allItems ?? this.allItems,
      allPositions: allPositions ?? this.allPositions,
      stock: stock ?? this.stock,
      contentSearchQuery: contentSearchQuery ?? this.contentSearchQuery,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      itemToPlace: clearItemToPlace ? null : (itemToPlace ?? this.itemToPlace),
    );
  }
}

final adminPlacementProvider = AutoDisposeNotifierProvider<AdminPlacementViewModel, AdminPlacementState>(
  () => AdminPlacementViewModel(),
);

class AdminPlacementViewModel extends AutoDisposeNotifier<AdminPlacementState> {
  @override
  AdminPlacementState build() => AdminPlacementState();

  Future<void> refreshData() async {
    state = state.copyWith(isLoading: true);
    final client = ref.read(apiClientProvider);
    final results = await Future.wait([
      client.getItemsAsync(),
      client.getPositionsAsync(),
      client.getItemPositionsAsync(),
    ]);
    state = state.copyWith(
      allItems: results[0] as List<ItemDto>,
      allPositions: results[1] as List<PositionCellDto>,
      stock: results[2] as List<ItemPositionDto>,
      isLoading: false,
    );
  }

  void setContentSearch(String q) => state = state.copyWith(contentSearchQuery: q);
  void setBranch(int? id) => state = state.copyWith(selectedBranchId: id);
  void setItemToPlace(ItemDto? item) => state = state.copyWith(itemToPlace: item, clearItemToPlace: item == null);

  Future<bool> executePlacement(int positionId, int qty) async {
    if (state.itemToPlace == null) return false;
    final success = await ref.read(apiClientProvider).placeItemInPositionAsync(
      ItemPositionDto(itemId: state.itemToPlace!.itemId, positionId: positionId, quantity: qty)
    );
    if (success) {
      await refreshData();
      setItemToPlace(null);
    }
    return success;
  }
}