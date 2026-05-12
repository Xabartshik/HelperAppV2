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

  List<PositionCellDto> get filteredPositions {
    var list = positions;
    if (selectedBranchId != null) {
      list = list.where((p) => p.branchId == selectedBranchId).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((p) => p.fullName.toLowerCase().contains(q)).toList();
    }
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

  Future<void> exportSelectedToPdf() async {
    if (state.selectedPositionIds.isEmpty) return;
    final selectedPositions = state.positions
        .where((p) => state.selectedPositionIds.contains(p.positionId))
        .toList();
    await PdfExportService.exportPositionLabels(selectedPositions);
  }

  // Обновленный метод формирования JSON для BulkCreatePositionDto
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