import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import 'package:helper_app/core/network/api_client.dart'; // Путь к вашему ApiClient

// Провайдер для получения списка заказов клиента
final customerOrdersProvider = FutureProvider.family<List<OrderDto>, int>((ref, customerId) async {
  // Получаем инстанс ApiClient
  final apiClient = ref.watch(apiClientProvider);
  
  // Вызываем метод, который мы добавили в ApiClient
  return await apiClient.getCustomerOrdersAsync(customerId);
});

// Провайдер для получения деталей конкретного заказа
final orderDetailsProvider = FutureProvider.family<OrderDto, int>((ref, orderId) async {
  // Получаем инстанс ApiClient
  final apiClient = ref.watch(apiClientProvider);
  
  // Вызываем метод, который мы добавили в ApiClient
  return await apiClient.getOrderByIdAsync(orderId);
});