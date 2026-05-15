import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/inventory/inventory_dtos.dart';
import 'package:helper_app/core/models/item/item_dto.dart';
import 'package:helper_app/core/network/api_client.dart';
import 'package:helper_app/screens/admin_panel/tabs/branches/admin_branches_viewmodel.dart';
import 'admin_placement_viewmodel.dart';
import '../../../../core/models/inventory/position_cell_dto.dart';

class AdminPlacementState {
  final bool isLoading;
  final List<ItemDto> allItems; 
  final List<PositionCellDto> allPositions; 
  final List<ItemPositionDto> stock; 
  
  final String contentSearchQuery; 
  final int? selectedBranchId;
  final ItemDto? itemToPlace; 
  final bool showOnlyEmpty;

  AdminPlacementState({
    this.isLoading = false,
    this.allItems = const [],
    this.allPositions = const [],
    this.stock = const [],
    this.contentSearchQuery = '',
    this.selectedBranchId,
    this.itemToPlace,
    this.showOnlyEmpty = false,
  });

  List<Map<String, dynamic>> getItemsInPosition(int positionId) {
    final itemsInPos = stock.where((s) => s.positionId == positionId && s.quantity > 0);
    final Map<int, int> groupedStock = {};
    for (var s in itemsInPos) {
      groupedStock[s.itemId] = (groupedStock[s.itemId] ?? 0) + s.quantity;
    }

    return groupedStock.entries.map((entry) {
      final itemId = entry.key;
      final quantity = entry.value;

      final item = allItems.firstWhere(
        (i) => i.itemId == itemId, 
        orElse: () => ItemDto(
          name: "ID: $itemId", 
          barcode: "Штрих-код",
          itemId: itemId,
          weight: 0.0,
          length: 0.0,
          width: 0.0,
          height: 0.0,
          price: 0.0,
        ),
      );
      return {
        'name': item.name,
        'quantity': quantity,
      };
    }).toList();
  }

  List<PositionCellDto> get filteredPositions {
    var list = List<PositionCellDto>.from(allPositions);

    // 1. Фильтр по филиалу
    if (selectedBranchId != null) {
      list = list.where((p) => p.branchId == selectedBranchId).toList();
    }

    // 2. Фильтр "Только пустые"
    if (showOnlyEmpty) {
      final filledPositionIds = stock
          .where((s) => s.quantity > 0) 
          .map((s) => s.positionId)
          .toSet();
      list = list.where((p) => !filledPositionIds.contains(p.positionId)).toList();
    }

    // 3. Поиск (И по ячейке, И по товару)
    if (contentSearchQuery.isNotEmpty) {
      final q = contentSearchQuery.toLowerCase();
      
      final matchingItemIds = allItems
          .where((i) => i.name.toLowerCase().contains(q))
          .map((i) => i.itemId)
          .toSet();

      final positionsWithMatch = stock
          .where((s) => matchingItemIds.contains(s.itemId))
          .map((s) => s.positionId)
          .toSet();

      list = list.where((p) => 
        positionsWithMatch.contains(p.positionId) || 
        p.fullName.toLowerCase().contains(q)
      ).toList();
    }

    // 4. Сортировка: Филиал -> Зона -> ТИП ХРАНИЛИЩА -> Стеллаж -> Полка
    list.sort((a, b) {
      int cmp = a.branchId.compareTo(b.branchId);
      if (cmp != 0) return cmp;

      cmp = a.zoneCode.compareTo(b.zoneCode);
      if (cmp != 0) return cmp;
      
      // Сортировка по типу (чтобы отделить паллеты от стеллажей)
      cmp = a.firstLevelStorageType.compareTo(b.firstLevelStorageType);
      if (cmp != 0) return cmp;

      int flsA = int.tryParse(a.flsNumber) ?? 0;
      int flsB = int.tryParse(b.flsNumber) ?? 0;
      cmp = flsA.compareTo(flsB);
      if (cmp == 0) cmp = a.flsNumber.compareTo(b.flsNumber); 
      
      if (cmp == 0) {
        cmp = (int.tryParse(a.secondLevelStorage ?? '0') ?? 0)
            .compareTo(int.tryParse(b.secondLevelStorage ?? '0') ?? 0);
        if (cmp == 0) cmp = (a.secondLevelStorage ?? '').compareTo(b.secondLevelStorage ?? '');
      }
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
    bool? showOnlyEmpty,
  }) {
    return AdminPlacementState(
      isLoading: isLoading ?? this.isLoading,
      allItems: allItems ?? this.allItems,
      allPositions: allPositions ?? this.allPositions,
      stock: stock ?? this.stock,
      contentSearchQuery: contentSearchQuery ?? this.contentSearchQuery,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      itemToPlace: clearItemToPlace ? null : (itemToPlace ?? this.itemToPlace),
      showOnlyEmpty: showOnlyEmpty ?? this.showOnlyEmpty,
    );
  }
}

final adminPlacementProvider = AutoDisposeNotifierProvider<AdminPlacementViewModel, AdminPlacementState>(
  () => AdminPlacementViewModel(),
);

class AdminPlacementViewModel extends AutoDisposeNotifier<AdminPlacementState> {
  @override
  AdminPlacementState build() {
    Future.microtask(() => refreshData());
    return AdminPlacementState();
  }

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
  void toggleShowOnlyEmpty() => state = state.copyWith(showOnlyEmpty: !state.showOnlyEmpty);

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