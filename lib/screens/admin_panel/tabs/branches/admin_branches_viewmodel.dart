import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/branch/branch_dto.dart';

class AdminBranchesState {
  final bool isLoading;
  final List<BranchDto> branches;
  final String searchQuery; // Поле для хранения строки поиска

  AdminBranchesState({
    this.isLoading = false,
    this.branches = const [],
    this.searchQuery = '',
  });

  AdminBranchesState copyWith({
    bool? isLoading,
    List<BranchDto>? branches,
    String? searchQuery,
  }) {
    return AdminBranchesState(
      isLoading: isLoading ?? this.isLoading,
      branches: branches ?? this.branches,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  // Геттер для получения отфильтрованного списка на основе поискового запроса
  List<BranchDto> get filteredBranches {
    if (searchQuery.isEmpty) return branches;
    final query = searchQuery.toLowerCase();
    return branches.where((b) =>
      b.branchName.toLowerCase().contains(query) ||
      b.address.toLowerCase().contains(query) ||
      b.branchType.toLowerCase().contains(query)
    ).toList();
  }
}
  final editingBranchProvider = StateProvider<BranchDto?>((ref) => null);
  
final adminBranchesProvider = AutoDisposeNotifierProvider<AdminBranchesViewModel, AdminBranchesState>(
  () => AdminBranchesViewModel(),
);

class AdminBranchesViewModel extends AutoDisposeNotifier<AdminBranchesState> {
  @override
  AdminBranchesState build() {
    Future.microtask(() => loadBranches());
    return AdminBranchesState();
  }

  Future<void> loadBranches() async {
    state = state.copyWith(isLoading: true);
    final branches = await ref.read(apiClientProvider).getBranchesAsync();
    state = state.copyWith(isLoading: false, branches: branches);
  }

  // Метод для обновления строки поиска из UI
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }



// Внутри класса AdminBranchesViewModel добавь:
  Future<bool> updateBranch(BranchDto branch) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updateBranchAsync(branch);
    if (success) {
      await loadBranches(); // Перезагружаем список
    }
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> createBranch(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).createBranchAsync(data);
    if (success) {
      await loadBranches();
    }
    state = state.copyWith(isLoading: false);
    return success;
  }
}