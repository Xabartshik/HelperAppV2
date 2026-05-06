// lib/screens/order_handover/order_handover_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order_handover/order_handover_dtos.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/utils/logger.dart';

/// Аргументы для инициализации провайдера
typedef OrderHandoverArgs = ({int assignmentId, int taskId, int workerId});

/// Состояние экрана выдачи заказа
class OrderHandoverState {
  final bool isLoading;
  final String errorMessage;
  final HandoverTaskDetailsDto? details;
  final bool isCancelMode; // Режим отмены позиций
  final Map<int, int> cancelledQuantities; // lineId -> количество отмененного товара

  const OrderHandoverState({
    this.isLoading = false,
    this.errorMessage = '',
    this.details,
    this.isCancelMode = false,
    this.cancelledQuantities = const {},
  });

  OrderHandoverState copyWith({
    bool? isLoading,
    String? errorMessage,
    HandoverTaskDetailsDto? details,
    bool? isCancelMode,
    Map<int, int>? cancelledQuantities,
  }) {
    return OrderHandoverState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      details: details ?? this.details,
      isCancelMode: isCancelMode ?? this.isCancelMode,
      cancelledQuantities: cancelledQuantities ?? this.cancelledQuantities,
    );
  }

  /// Проверка: все ли товары обработаны (отсканированы или отменены локально)
  bool get allItemsProcessed =>
      details != null &&
      details!.itemsToScan.isNotEmpty &&
      details!.itemsToScan.every((i) {
        final cancelled = cancelledQuantities[i.lineId] ?? 0;
        return (i.scannedQuantity + cancelled) >= i.quantity;
      });

  /// Проверка: все ли товары отсканированы (старая логика для обратной совместимости)
  bool get allItemsScanned => 
      details != null && 
      details!.itemsToScan.isNotEmpty && 
      details!.itemsToScan.every((i) => i.scannedQuantity >= i.quantity);
}

/// Провайдер ViewModel для управления процессом выдачи
final orderHandoverViewModelProvider = AutoDisposeNotifierProviderFamily<
    OrderHandoverViewModel, OrderHandoverState, OrderHandoverArgs>(
  () => OrderHandoverViewModel(),
);

class OrderHandoverViewModel extends AutoDisposeFamilyNotifier<OrderHandoverState, OrderHandoverArgs> {
  @override
  OrderHandoverState build(OrderHandoverArgs arg) {
    // Автоматическая загрузка данных при создании
    Future.microtask(() => loadTask());
    return const OrderHandoverState();
  }

  /// Загрузка деталей задачи с сервера
  Future<void> loadTask() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      
      // Получаем детали задачи
      final rawResponse = await client.workerTaskDetailsAsync(arg.taskId, arg.workerId);
      final detailsMap = rawResponse['taskDetails'] as Map<String, dynamic>?;
      
      if (detailsMap == null) {
        throw Exception('Детали задачи отсутствуют в ответе сервера.');
      }

      final details = HandoverTaskDetailsDto.fromJson(detailsMap);
      state = state.copyWith(isLoading: false, details: details);
    } catch (e) {
      Logger.e('Ошибка загрузки деталей выдачи: $e');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Активация задачи (перевод в статус "В работе")
  Future<void> activateTask() async {
    try {
      final client = ref.read(apiClientProvider);
      await client.workerTaskStartAsync(arg.taskId, arg.workerId);
      await loadTask(); 
    } catch (e) {
      Logger.e('Ошибка активации: $e');
    }
  }

  /// Обработка сканирования штрих-кода товара
  Future<(bool, String)> processScan(String barcode) async {
    try {
      final client = ref.read(apiClientProvider);
      final result = await client.orderHandoverScanAsync(arg.taskId, arg.workerId, barcode);
      final message = result['message'] as String;
      
      await loadTask(); // Обновляем состояние после успешного сканирования
      return (true, message);
    } catch (e) {
      Logger.e('Ошибка сканирования выдачи: $e');
      return (false, e.toString());
    }
  }

  /// Завершение задачи выдачи
/// Завершение задачи выдачи
  Future<(bool, String)> completeTask() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      
      // Формируем payload с отмененными товарами (если они есть)
      final payload = {
        'cancelledLines': state.cancelledQuantities, // Map<int, int> { lineId: count }
      };

      // Передаем данные на сервер
      await client.workerTaskCompleteAsync(arg.taskId, arg.workerId, data: payload);
      
      return (true, 'Задача успешно завершена');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return (false, e.toString());
    }
  }

  Future<(bool, String)> completeCourierHandover(String qrToken) async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      // Имитация успешного вызова для примера:
      await client.completeCourierHandoverAsync(arg.taskId, arg.workerId, qrToken); 
      
      return (true, 'Отгрузка успешно подтверждена!');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return (false, e.toString());
    }
  }

  // --- Логика режима отмены ---

  /// Переключение режима отмены
  void toggleCancelMode() {
    state = state.copyWith(isCancelMode: !state.isCancelMode);
  }

  /// Обновление количества отменяемого товара для конкретной позиции
  void updateCancelledQuantity(int lineId, int quantity, int maxAvailable) {
    final newMap = Map<int, int>.from(state.cancelledQuantities);
    
    if (quantity <= 0) {
      newMap.remove(lineId);
    } else {
      // Количество не может превышать то, что еще не отсканировано
      newMap[lineId] = quantity > maxAvailable ? maxAvailable : quantity;
    }
    
    state = state.copyWith(cancelledQuantities: newMap);
  }

  /// Выбрать все несобранные товары для отмены
  void selectAllForCancellation() {
    if (state.details == null) return;
    
    final newMap = <int, int>{};
    for (var item in state.details!.itemsToScan) {
      final remaining = item.quantity - item.scannedQuantity;
      if (remaining > 0) {
        newMap[item.lineId] = remaining;
      }
    }
    
    state = state.copyWith(cancelledQuantities: newMap);
  }

  /// Сброс всех правок по отмене
  void clearCancellation() {
    state = state.copyWith(cancelledQuantities: {}, isCancelMode: false);
  }
}