// lib/screens/order_handover/order_handover_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/models/order_handover/order_handover_dtos.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/utils/logger.dart';

typedef OrderHandoverArgs = ({int assignmentId, int taskId, int workerId});

class OrderHandoverState {
  final bool isLoading;
  final String errorMessage;
  final HandoverTaskDetailsDto? details;

  const OrderHandoverState({
    this.isLoading = false,
    this.errorMessage = '',
    this.details,
  });

  OrderHandoverState copyWith({
    bool? isLoading,
    String? errorMessage,
    HandoverTaskDetailsDto? details,
  }) {
    return OrderHandoverState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      details: details ?? this.details,
    );
  }

  bool get allItemsScanned => 
      details != null && 
      details!.itemsToScan.isNotEmpty && 
      details!.itemsToScan.every((i) => i.scannedQuantity >= i.quantity);
}

final orderHandoverViewModelProvider = AutoDisposeNotifierProviderFamily<
    OrderHandoverViewModel, OrderHandoverState, OrderHandoverArgs>(
  () => OrderHandoverViewModel(),
);

class OrderHandoverViewModel extends AutoDisposeFamilyNotifier<OrderHandoverState, OrderHandoverArgs> {
  @override
  OrderHandoverState build(OrderHandoverArgs arg) {
    Future.microtask(() => loadTask());
    return const OrderHandoverState();
  }

Future<void> loadTask() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final client = ref.read(apiClientProvider);
      
      // Получаем MobileBaseTaskDto в виде JSON
      final rawResponse = await client.workerTaskDetailsAsync(arg.taskId, arg.workerId);
      
      // Достаем вложенный объект с деталями выдачи
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

  Future<void> activateTask() async {
    try {
      final client = ref.read(apiClientProvider);
      await client.workerTaskStartAsync(arg.taskId, arg.workerId);
      await loadTask(); // Обновляем статусы
    } catch (e) {
      Logger.e('Ошибка активации: $e');
    }
  }

  Future<(bool, String)> processScan(String barcode) async {
    try {
      final client = ref.read(apiClientProvider);
      final result = await client.orderHandoverScanAsync(arg.taskId, arg.workerId, barcode);
      final message = result['message'] as String;
      
      await loadTask(); // Обновляем счетчики
      return (true, message);
    } catch (e) {
      Logger.e('Ошибка сканирования выдачи: $e');
      return (false, e.toString());
    }
  }

  Future<(bool, String)> completeTask() async {
    state = state.copyWith(isLoading: true);
    try {
      final client = ref.read(apiClientProvider);
      await client.workerTaskCompleteAsync(arg.taskId, arg.workerId);
      return (true, 'Задача успешно завершена');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return (false, e.toString());
    }
  }
}