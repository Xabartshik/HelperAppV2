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
  final Set<int> selectedPositionIds;
  final bool isGroupedView; // Флаг для группировки

  AdminPositionsState({
    this.isLoading = false,
    this.positions = const [],
    this.searchQuery = '',
    this.selectedBranchId,
    this.selectedPositionIds = const {},
    this.isGroupedView = true, // По умолчанию включена
  });

  AdminPositionsState copyWith({
    bool? isLoading,
    List<PositionCellDto>? positions,
    String? searchQuery,
    int? selectedBranchId,
    Set<int>? selectedPositionIds,
    bool? isGroupedView,
  }) {
    return AdminPositionsState(
      isLoading: isLoading ?? this.isLoading,
      positions: positions ?? this.positions,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBranchId: selectedBranchId ?? this.selectedBranchId,
      selectedPositionIds: selectedPositionIds ?? this.selectedPositionIds,
      isGroupedView: isGroupedView ?? this.isGroupedView,
    );
  }

  List<PositionCellDto> get filteredPositions {
    var list = List<PositionCellDto>.from(positions);
    
    // 1. Фильтрация
    if (selectedBranchId != null) {
      list = list.where((p) => p.branchId == selectedBranchId).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((p) => p.fullName.toLowerCase().contains(q)).toList();
    }

    // 2. Умная сортировка: Зона -> Стеллаж -> Полка -> Ячейка
    list.sort((a, b) {
      int cmp = a.zoneCode.compareTo(b.zoneCode);
      if (cmp != 0) return cmp;

      // Сортируем номера стеллажей как числа, чтобы 2 шло перед 10
      int flsA = int.tryParse(a.flsNumber) ?? 0;
      int flsB = int.tryParse(b.flsNumber) ?? 0;
      cmp = flsA.compareTo(flsB);
      if (cmp == 0) cmp = a.flsNumber.compareTo(b.flsNumber); // Фолбэк на строку
      if (cmp != 0) return cmp;

      // Сортируем полки
      int shelfA = int.tryParse(a.secondLevelStorage ?? '0') ?? 0;
      int shelfB = int.tryParse(b.secondLevelStorage ?? '0') ?? 0;
      cmp = shelfA.compareTo(shelfB);
      if (cmp == 0) cmp = (a.secondLevelStorage ?? '').compareTo(b.secondLevelStorage ?? '');
      if (cmp != 0) return cmp;

      // Сортируем ячейки
      int cellA = int.tryParse(a.thirdLevelStorage ?? '0') ?? 0;
      int cellB = int.tryParse(b.thirdLevelStorage ?? '0') ?? 0;
      cmp = cellA.compareTo(cellB);
      if (cmp == 0) cmp = (a.thirdLevelStorage ?? '').compareTo(b.thirdLevelStorage ?? '');
      return cmp;
    });

    return list;
  }
}

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

  void toggleGroupedView() {
    state = state.copyWith(isGroupedView: !state.isGroupedView);
  }

  Future<void> exportSelectedToPdf() async {
    if (state.selectedPositionIds.isEmpty) return;
    final selectedPositions = state.positions
        .where((p) => state.selectedPositionIds.contains(p.positionId))
        .toList();
    await PdfExportService.exportPositionLabels(selectedPositions);
  }

  Future<bool> createBulkPositions(Map<String, dynamic> values) async {
    state = state.copyWith(isLoading: true);
    try {
      final payload = {
        'branchId': values['branchId'],
        'zoneCode': values['zoneCode'],
        'storageType': values['storageType'],
        'startFLSNumber': int.parse(values['startNum'].toString()),
        'storageCount': int.parse(values['count'].toString()),
        'shelvesCount': values['storageType'] == 'RACK' ? int.tryParse(values['shelvesCount']?.toString() ?? '') : null,
        'cellsPerShelf': values['storageType'] == 'RACK' ? int.tryParse(values['cellsCount']?.toString() ?? '') : null,
        'defaultLength': double.tryParse(values['length']?.toString() ?? '0'),
        'defaultWidth': double.tryParse(values['width']?.toString() ?? '0'),
        'defaultHeight': double.tryParse(values['height']?.toString() ?? '0'),
      };

      final createdPositions = await ref.read(apiClientProvider).createBulkPositionsAsync(payload);

      if (createdPositions != null && createdPositions.isNotEmpty) {
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