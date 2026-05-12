import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/item/item_dto.dart';

class AdminItemsState {
  final bool isLoading;
  final List<ItemDto> items;
  final String searchQuery;

  AdminItemsState({this.isLoading = false, this.items = const [], this.searchQuery = ''});

  AdminItemsState copyWith({bool? isLoading, List<ItemDto>? items, String? searchQuery}) {
    return AdminItemsState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      searchQuery: searchQuery ?? this.searchQuery,
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