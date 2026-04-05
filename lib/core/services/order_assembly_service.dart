import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/logger.dart';
import '../network/api_client.dart';
import '../models/order_assembly/order_assembly_dtos.dart';

/// Провайдер сервиса сборки заказов
final orderAssemblyServiceProvider = Provider<OrderAssemblyService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrderAssemblyService(apiClient);
});

/// Сервис для взаимодействия с API модуля OrderAssembly
class OrderAssemblyService {
  final ApiClient _apiClient;

  OrderAssemblyService(this._apiClient);

  // ---------------------------------------------------------------------------
  // GET: список задач для сотрудника
  // ---------------------------------------------------------------------------

  /// Возвращает список задач сборки для указанного сотрудника
  Future<List<WorkerAssemblyTaskDto>> getTasks(int userId) async {
    try {
      Logger.i('OrderAssembly: запрос задач для userId=$userId');

      if (userId <= 0) {
        Logger.w('OrderAssembly: userId <= 0, возвращаем пустой список');
        return [];
      }

      final response = await _apiClient.getAsync('OrderAssembly/tasks/$userId');

      if (response == null || (response is List && response.isEmpty)) {
        Logger.i('OrderAssembly: задачи не найдены для userId=$userId');
        return [];
      }

      final tasks = (response as List)
          .map((json) => WorkerAssemblyTaskDto.fromJson(json))
          .toList();

      Logger.i('OrderAssembly: получено ${tasks.length} задач для userId=$userId');
      return tasks;
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка при получении задач для userId=$userId', e, stack);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: сканирование товара (режим Сбора)
  // ---------------------------------------------------------------------------

  /// Сканирует штрихкод товара и обновляет статус строки на «Собран»
  Future<void> scanPick(int lineId, String barcode) async {
    try {
      Logger.i('OrderAssembly: scanPick lineId=$lineId, barcode=$barcode');

      final request = ScanPickRequest(lineId: lineId, barcode: barcode);
      await _apiClient.postAsync(
        'OrderAssembly/scan-pick',
        data: request.toJson(),
      );

      Logger.i('OrderAssembly: scanPick успешно для lineId=$lineId');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка scanPick lineId=$lineId', e, stack);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: массовое размещение товаров ячейки
  // ---------------------------------------------------------------------------

  /// Переводит все товары ячейки assignmentId в статус «Размещено»
  Future<void> scanPlaceBulk(int assignmentId, String cellCode) async {
    try {
      Logger.i('OrderAssembly: scanPlaceBulk assignmentId=$assignmentId, cellCode=$cellCode');

      final request = ScanPlaceBulkRequest(
        assignmentId: assignmentId,
        cellCode: cellCode,
      );
      await _apiClient.postAsync(
        'OrderAssembly/scan-place-bulk',
        data: request.toJson(),
      );

      Logger.i('OrderAssembly: scanPlaceBulk успешно для assignmentId=$assignmentId');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка scanPlaceBulk assignmentId=$assignmentId', e, stack);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: отчёт об отсутствующем товаре
  // ---------------------------------------------------------------------------

  /// Фиксирует отсутствие товара с указанием причины
  Future<void> reportMissing(int lineId, String reason) async {
    try {
      Logger.i('OrderAssembly: reportMissing lineId=$lineId, reason=$reason');

      final request = ReportMissingRequest(lineId: lineId, reason: reason);
      await _apiClient.postAsync(
        'OrderAssembly/report-missing',
        data: request.toJson(),
      );

      Logger.i('OrderAssembly: reportMissing успешно для lineId=$lineId');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка reportMissing lineId=$lineId', e, stack);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST: завершение задачи сборки
  // ---------------------------------------------------------------------------

  /// Закрывает задачу сборки (все ячейки заполнены)
  Future<void> completeAssembly(int assignmentId) async {
    try {
      Logger.i('OrderAssembly: completeAssembly assignmentId=$assignmentId');

      await _apiClient.postAsync(
        'OrderAssembly/complete/$assignmentId',
        data: null,
      );

      Logger.i('OrderAssembly: задача $assignmentId успешно завершена');
    } catch (e, stack) {
      Logger.e('OrderAssembly: ошибка completeAssembly assignmentId=$assignmentId', e, stack);
      rethrow;
    }
  }
}
