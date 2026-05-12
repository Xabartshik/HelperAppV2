import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/inventory/position_cell_dto.dart';
import '../../../../core/services/pdf_export_service.dart';
import '../../../../core/utils/logger.dart';

class AdminPositionsState {
  final bool isLoading;
  final List<PositionCellDto> positions;
  final String searchQuery;
  final int? selectedBranchId;
  final Set<int> selectedPositionIds; // Для выбора ячеек под экспорт PDF

  AdminPositionsState({
    this.isLoading = false,
    this.positions = const [],
    this.searchQuery = '',
    this.selectedBranchId,
    this.selectedPositionIds = const {},
  });

  AdminPositionsState copyWith({
    bool? isLoading,
    List<PositionCellDto>? positions,
    String? searchQuery,
    int? selectedBranchId,
    Set<int>? selectedPositionIds,
  }) {
    return AdminPositionsState(
      isLoading: isLoading ?? this.isLoading,
      positions: positions ?? this.positions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedPositionIds: selectedPositionIds ?? this.selectedPositionIds,
    );
  }

  // Геттер для фильтрации списка
  List<PositionCellDto> get filteredPositions {
    var list = positions;

    // 1. Фильтр по филиалу
    if (selectedBranchId != null) {
      list = list.where((p) => p.branchId == selectedBranchId).toList();
    }

    // 2. Поиск по названию (Зона-Стеллаж-Полка-Ячейка)
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((p) => p.fullName.toLowerCase().contains(q)).toList();
    }

    return list;
  }
}

// Провайдер для редактируемой позиции (одиночной)
final editingPositionProvider = StateProvider<PositionCellDto?>((ref) => null);

final adminPositionsProvider = AutoDisposeNotifierProvider<AdminPositionsViewModel, AdminPositionsState>(
  () => AdminPositionsViewModel(),
);

class AdminPositionsViewModel extends AutoDisposeNotifier<AdminPositionsState> {
  @override
  AdminPositionsState build() {
    Future.microtask(() => loadPositions());
    return AdminPositionsState();
  }

  Future<void> loadPositions() async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await ref.read(apiClientProvider).getPositionsAsync();
      state = state.copyWith(positions: list, isLoading: false);
    } catch (e) {
      Logger.e('Ошибка загрузки позиций', e);
      state = state.copyWith(isLoading: false);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setBranchFilter(int? branchId) {
    state = state.copyWith(selectedBranchId: branchId);
  }

  // --- Работа с выбором для экспорта ---

  void toggleSelection(int positionId) {
    final newSelection = Set<int>.from(state.selectedPositionIds);
    if (newSelection.contains(positionId)) {
      newSelection.remove(positionId);
    } else {
      newSelection.add(positionId);
    }
    state = state.copyWith(selectedPositionIds: newSelection);
  }

  void clearSelection() {
    state = state.copyWith(selectedPositionIds: {});
  }

  // Экспорт выбранных QR-кодов в PDF
  Future<void> exportSelectedToPdf() async {
    if (state.selectedPositionIds.isEmpty) return;

    final selectedPositions = state.positions
        .where((p) => state.selectedPositionIds.contains(p.positionId))
        .toList();

    await PdfExportService.exportPositionLabels(selectedPositions);
  }

  // --- API Операции ---

  // Массовое создание через твой новый эндпоинт /bulk
  Future<bool> createBulkPositions(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      // Отправляем BulkCreatePositionDto на сервер
      final createdPositions = await ref.read(apiClientProvider).createBulkPositionsAsync(data);

      if (createdPositions != null && createdPositions.isNotEmpty) {
        // Сразу после создания предлагаем сохранить PDF со всеми новыми ячейками
        await PdfExportService.exportPositionLabels(createdPositions);
        await loadPositions();
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      Logger.e('Ошибка при массовом создании', e);
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> updatePosition(PositionCellDto pos) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).updatePositionAsync(pos.toJson());
    if (success) await loadPositions();
    state = state.copyWith(isLoading: false);
    return success;
  }

  Future<bool> deletePosition(int id) async {
    state = state.copyWith(isLoading: true);
    final success = await ref.read(apiClientProvider).deletePositionAsync(id);
    if (success) await loadPositions();
    state = state.copyWith(isLoading: false);
    return success;
  }
}