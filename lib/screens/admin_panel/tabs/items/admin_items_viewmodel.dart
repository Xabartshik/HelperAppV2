import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/item/item_dto.dart';

class AdminItemsState {
  final bool isLoading;
  final List<ItemDto> items;
  final String searchQuery;
  final Set<int> selectedItemIds;

  AdminItemsState({
    this.isLoading = false,
    this.items = const [],
    this.searchQuery = '',
    this.selectedItemIds = const {},
  });

  AdminItemsState copyWith({
    bool? isLoading,
    List<ItemDto>? items,
    String? searchQuery,
    Set<int>? selectedItemIds,
  }) {
    return AdminItemsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
    );
  }

  List<ItemDto> get filteredItems {
    if (searchQuery.isEmpty) return items;
    return items.where((i) => i.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }
}

final editingItemProvider = StateProvider<ItemDto?>((ref) => null);

final adminItemsProvider = AutoDisposeNotifierProvider<AdminItemsViewModel, AdminItemsState>(
  () => AdminItemsViewModel(),
);

class AdminItemsViewModel extends AutoDisposeNotifier<AdminItemsState> {
  @override
  AdminItemsState build() {
    Future.microtask(() => loadItems());
    return AdminItemsState();
  }

  Future<void> loadItems() async {
    state = state.copyWith(isLoading: true);
    final items = await ref.read(apiClientProvider).getItemsAsync();
    state = state.copyWith(items: items, isLoading: false);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  // Выбор или снятие выбора с товара
  void toggleItemSelection(int itemId) {
    final current = Set<int>.from(state.selectedItemIds);
    if (current.contains(itemId)) {
      current.remove(itemId);
    } else {
      current.add(itemId);
    }
    state = state.copyWith(selectedItemIds: current);
  }

  // Выбор всех отфильтрованных товаров или снятие выбора
  void selectAllItems() {
    final filtered = state.filteredItems;
    final current = Set<int>.from(state.selectedItemIds);
    final allFilteredIds = filtered.map((e) => e.itemId).toSet();

    if (allFilteredIds.every((id) => current.contains(id))) {
      current.removeAll(allFilteredIds);
    } else {
      current.addAll(allFilteredIds);
    }
    state = state.copyWith(selectedItemIds: current);
  }

  // Очистка выбора
  void clearSelection() {
    state = state.copyWith(selectedItemIds: {});
  }

  Future<bool> createItem(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).createItemAsync(data);
    if (success) await loadItems();
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> updateItem(ItemDto item) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updateItemAsync(item);
    if (success) await loadItems();
    state = state.copyWith(isLoading: false);
    return success;
  }
}