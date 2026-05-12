import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/branch/branch_dto.dart';

class AdminBranchesState {
  final bool isLoading;
  final List<BranchDto> branches;

  AdminBranchesState({this.isLoading = false, this.branches = const []});

  AdminBranchesState copyWith({bool? isLoading, List<BranchDto>? branches}) {
    return AdminBranchesState(
      isLoading: isLoading ?? this.isLoading,
      branches: branches ?? this.branches,
    );
  }
}

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

  Future<bool> createBranch(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).createBranchAsync(data);
    if (success) {
      await loadBranches(); // Перезагружаем список после успешного создания
    }
    state = state.copyWith(isLoading: false);
    return success;
  }
}