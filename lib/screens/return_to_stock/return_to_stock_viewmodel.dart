import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/return_to_stock/return_to_stock_dtos.dart';
import '../../core/utils/logger.dart';

typedef ReturnToStockArgs = ({int assignmentId, int taskId, int workerId});

class ReturnToStockState {
  final bool isLoading;
  final String errorMessage;
  final ReturnTaskDetailsDto? details;
  final Set<int> locallyScannedLineIds;
  final Map<int, int> manualTargetCells; // ДОБАВЛЕНО: lineId -> positionId

  const ReturnToStockState({
    this.isLoading = false,
    this.errorMessage = '',
    this.details,
    this.locallyScannedLineIds = const {},
    this.manualTargetCells = const {}, // ДОБАВЛЕНО
  });

  ReturnToStockState copyWith({
    bool? isLoading,
    String? errorMessage,
    ReturnTaskDetailsDto? details,
    Set<int>? locallyScannedLineIds,
    Map<int, int>? manualTargetCells,
  }) {
    return ReturnToStockState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      details: details ?? this.details,
      locallyScannedLineIds: locallyScannedLineIds ?? this.locallyScannedLineIds,
      manualTargetCells: manualTargetCells ?? this.manualTargetCells,
    );
  }

  bool get allItemsProcessed =>
      details != null &&
      details!.itemsToScan.isNotEmpty &&
      details!.itemsToScan.every((i) => locallyScannedLineIds.contains(i.lineId) || i.scannedQuantity >= i.quantity);
}

final returnToStockViewModelProvider = AutoDisposeNotifierProviderFamily<
    ReturnToStockViewModel, ReturnToStockState, ReturnToStockArgs>(
  () => ReturnToStockViewModel(),
);

class ReturnToStockViewModel extends AutoDisposeFamilyNotifier<ReturnToStockState, ReturnToStockArgs> {
  @override
  ReturnToStockState build(ReturnToStockArgs arg) {
    Future.microtask(() => loadTask());
    return const ReturnToStockState();
  }

  Future<void> loadTask() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      final rawResponse = await client.workerTaskDetailsAsync(arg.taskId, arg.workerId);
      final detailsMap = rawResponse['taskDetails'] as Map<String, dynamic>?;
      
      if (detailsMap == null) throw Exception('Детали задачи отсутствуют.');

      final details = ReturnTaskDetailsDto.fromJson(detailsMap);
      state = state.copyWith(isLoading: false, details: details);
    } catch (e) {
      Logger.e('Ошибка загрузки деталей возврата: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Стандартная пометка товара как размещенного (в ячейку по умолчанию)
  void processLocalScan(int lineId) {
    final newScans = Set<int>.from(state.locallyScannedLineIds)..add(lineId);
    state = state.copyWith(locallyScannedLineIds: newScans);
  }

  // ДОБАВЛЕНО: Установка новой ячейки
  void updateTargetCell(int lineId, int newPositionId) {
    final newCells = Map<int, int>.from(state.manualTargetCells);
    newCells[lineId] = newPositionId;
    
    // Также помечаем товар как "обработанный"
    final newScans = Set<int>.from(state.locallyScannedLineIds)..add(lineId);
    
    state = state.copyWith(
      manualTargetCells: newCells,
      locallyScannedLineIds: newScans
    );
  }

  Future<(bool, String)> completeTask() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      
      // ДОБАВЛЕНО: Передаем словарь ячеек. 
      // В API клиенте параметр называется cancelledLines, но мы знаем, что бэкенд поймет это как словарь целевых ячеек!
      await client.completeWorkerTaskAsync(
        arg.taskId, 
        arg.workerId,
        cancelledLines: state.manualTargetCells.isNotEmpty ? state.manualTargetCells : null
      );
      
      return (true, 'Возврат успешно завершен, ячейки обновлены!');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return (false, e.toString());
    }
  }

  // Сканирование штрих-кода товара (Pick)
Future<(bool, String)> processScanItem(int lineId, String barcode) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      final currentAssignmentId = state.details?.assignmentId ?? arg.assignmentId;
      
      await client.scanReturnItemAsync(currentAssignmentId, lineId, barcode.trim());
      
      await loadTask(); // Обновляем данные с сервера
      return (true, 'Товар подтвержден');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return (false, e.toString());
    }
  }

  // Сканирование QR-кода ячейки (Place)
Future<(bool, String)> processScanCell(int lineId, String cellCode) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      
      // ИЗМЕНЕНИЕ: Берем актуальный AssignmentId из загруженных деталей
      final currentAssignmentId = state.details?.assignmentId ?? arg.assignmentId;
      
      await client.scanReturnCellAsync(currentAssignmentId, lineId, cellCode.trim());
      
      await loadTask();
      // Проверяем, все ли позиции теперь размещены для автозакрытия
      final allDone = state.details?.itemsToScan.every((i) => i.scannedQuantity > 0 && i.targetCellCode != null) ?? false;
      
      return (true, allDone ? 'FINISH:Размещено в ячейке $cellCode' : 'Размещено в ячейке $cellCode');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return (false, e.toString());
    }
  }
}