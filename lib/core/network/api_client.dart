import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/attendance/break_status_dto.dart';
import 'package:helper_app/core/models/attendance/check_io_employee_dto.dart';
import 'package:helper_app/core/models/config/app_config_dto.dart';
import 'package:helper_app/core/models/order/order_dto.dart';
import '../utils/logger.dart';
import 'api_exceptions.dart';
import 'api_endpoints.dart';
import '../models/boss_panel/boss_panel_models.dart';
import '../models/inventory/inventory_dtos.dart';
import '../models/order_assembly/order_assembly_dtos.dart';
import '../models/tasks/mobile_base_task_dto.dart';

/// Провайдер для получения инфы об устройстве
final deviceInfoProvider = Provider((ref) => DeviceInfoPlugin());

/// Провайдер для ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class ApiClient {
  final Ref ref;
  late final Dio _dio;
  bool _hasNetwork = true;

  bool get hasNetwork => _hasNetwork;

  ApiClient(this.ref) {
    _dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:5000/api/', // placeholder
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500, // Обрабатываем 401 и 404 вручную
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        Logger.i('API Запрос: ${options.method} ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        Logger.i('API Ответ: ${response.statusCode} для ${response.requestOptions.path}');
        try {
          _handleResponseErrors(response);
          return handler.next(response);
        } catch (e) {
          return handler.reject(DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: e,
            type: DioExceptionType.badResponse,
          ));
        }
      },
      onError: (DioException e, handler) {
        _hasNetwork = false;
        Logger.e('Ошибка сети при запросе ${e.requestOptions.path}', e);
        return handler.next(e);
      },
    ));
  }
  Future<void> rejectCourierOrderAsync(int orderId) async {
    try {
      await postAsync(ApiEndpoints.rejectCourierOrder(orderId));
    } catch (e) {
      Logger.e('Ошибка фиксации отказа от заказа $orderId', e);
      rethrow;
    }
  }
  /// Единое завершение назначения работника (полиморфно для любой задачи)
  Future<void> workerTaskCompleteAsync(int taskId, int workerId, {Map<String, dynamic>? data}) async {
    final url = ApiEndpoints.workerTaskComplete(taskId, workerId);
    await postAsync(url, data: data ?? {});
  }
  Future<dynamic> workerTaskDetailsAsync(int taskId, int workerId) async {
    final url = ApiEndpoints.workerTaskDetails(taskId, workerId);
    return await getAsync(url);
  }

  Future<void> workerTaskPauseAsync(int taskId, int workerId) async {
    final url = ApiEndpoints.workerTaskPause(taskId, workerId);
    await postAsync(url);
  }

  Future<void> workerTaskCancelAsync(int taskId, int workerId) async {
    final url = ApiEndpoints.workerTaskCancel(taskId, workerId);
    await postAsync(url);
  }

  Future<void> workerTaskStartAsync(int taskId, int workerId) async {
    final url = ApiEndpoints.workerTaskStart(taskId, workerId);
    await postAsync(url, data: {});
  }
void _handleResponseErrors(Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException('Токен истёк или невалиден');
    }
    if (response.statusCode == 404) {
      throw NotFoundException('Ресурс не найден: ${response.requestOptions.path}');
    }

    // Достаем текст ошибки из JSON ответа бэкенда
    String serverMessage = 'HTTP ошибка: ${response.statusCode}';
    if (response.data is Map) {
      final msg = response.data['message'] ?? response.data['Message'] ?? response.data['error'];
      final details = response.data['details'] ?? response.data['Details'];
      
      if (msg != null) serverMessage = msg.toString();
      if (details != null) serverMessage += '\nДетали: $details';
    }

    if (response.statusCode == 409) {
      throw ConflictException(serverMessage);
    }
    
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ApiException(serverMessage);
    }
  }

  Future<void> updateCourierStatusAsync(int branchId, String checkType) async {
    try {
      await postAsync(
        ApiEndpoints.updateCourierStatus,
        data: {
          'branchId': branchId,
          'checkType': checkType,
        },
      );
    } catch (e) {
      Logger.w('Ошибка смены статуса транспорта: $e');
      rethrow;
    }
  }
  
  
  Future<CheckIOEmployeeDto?> getLastCheckAsync(int employeeId) async {
    final response = await getAsync(ApiEndpoints.lastCheck(employeeId));
    if (response == null) return null;
    return CheckIOEmployeeDto.fromJson(response);
  }
  static String? _cachedBaseUrl;

  Future<AppConfigDto?> getAppConfigAsync() async {
      final response = await getAsync(ApiEndpoints.getConfig);
      if (response == null || response is! Map<String, dynamic>) return null;
      return AppConfigDto.fromJson(response);
  }

  // Делаем геттер публичным, чтобы к нему можно было обратиться из MainPage
  String get baseUrl => _cachedBaseUrl ?? 'http://localhost:5000';

  Future<String> _resolveBaseUrl() async {
    if (_cachedBaseUrl != null) return _cachedBaseUrl!;

    if (kIsWeb) {
      _cachedBaseUrl = 'http://localhost:5000/api/';
    } else if (Platform.isAndroid) {
      try {
        final deviceInfo = ref.read(deviceInfoProvider);
        final androidInfo = await deviceInfo.androidInfo;
        
        // В device_info_plus признак эмулятора проверяется через свойство isPhysicalDevice
        if (!androidInfo.isPhysicalDevice) {
          Logger.i('Обнаружен Android эмулятор, используем 10.0.2.2');
          _cachedBaseUrl = 'http://10.0.2.2:5000/api/';
        } else {
          // Для физического Android устройства
          const physicalDeviceAddress = "http://192.168.0.106:5000/api/";
          Logger.i('Обнаружено физическое Android устройство, используем $physicalDeviceAddress');
          _cachedBaseUrl = physicalDeviceAddress;
        }
      } catch (e) {
        Logger.e('Ошибка при определении типа устройства Android, fallback на 10.0.2.2', e);
        _cachedBaseUrl = 'http://10.0.2.2:5000/api/';
      }
    } else if (Platform.isIOS) {
      Logger.i('iOS платформа, используем localhost');
      _cachedBaseUrl = 'http://localhost:5000/api/';
    } else {
      Logger.i('Другая платформа, используем localhost');
      _cachedBaseUrl = 'http://localhost:5000/api/';
    }

    _dio.options.baseUrl = _cachedBaseUrl!;
    return _cachedBaseUrl!;
  }

  void setAuthorizationToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<dynamic> getAsync(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      _hasNetwork = true;
      await _resolveBaseUrl();
      final response = await _dio.get(endpoint, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
        // Пропускаем все наши кастомные бизнес-ошибки дальше
        if (e.error is UnauthorizedException || 
            e.error is NotFoundException || 
            e.error is ConflictException || 
            e.error is ApiException) {
          throw e.error!; 
        }
        throw NoNetworkException('Нет подключения к сети', e);
      }
    }
  

  Future<dynamic> postAsync(String endpoint, {dynamic data}) async {
    try {
      _hasNetwork = true;
      await _resolveBaseUrl();
      final response = await _dio.post(endpoint, data: data);
      return response.data;
      } on DioException catch (e) {
          // Пропускаем все наши кастомные бизнес-ошибки дальше
          if (e.error is UnauthorizedException || 
              e.error is NotFoundException || 
              e.error is ConflictException || 
              e.error is ApiException) {
            throw e.error!; 
          }
          throw NoNetworkException('Нет подключения к сети', e);
        }
  }

  // Boss Panel API Endpoints
  Future<List<BossPanelTaskCardDto>> getBossPanelActiveTasksAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelActiveTasks);
    return (response as List).map((x) => BossPanelTaskCardDto.fromJson(x)).toList();
  }

  Future<List<EmployeeWorkloadDto>> getBossPanelEmployeeWorkloadAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelEmployeeWorkload);
    return (response as List).map((x) => EmployeeWorkloadDto.fromJson(x)).toList();
  }

  Future<List<AvailableEmployeeDto>> getBossPanelAvailableEmployeesAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelAvailableEmployees);
    return (response as List).map((x) => AvailableEmployeeDto.fromJson(x)).toList();
  }

  Future<List<PositionCellDto>> getBossPanelPositionsAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelPositions);
    return (response as List).map((x) => PositionCellDto.fromJson(x)).toList();
  }

  Future<List<int>> getBossPanelAutoSelectedEmployeesAsync(int count) async {
    final response = await getAsync(ApiEndpoints.bossPanelAutoSelectEmployees(count));
    return List<int>.from(response);
  }

  Future<dynamic> createBossPanelInventoryTaskByZoneAsync(
    CreateInventoryByZoneDto dto, {
    int? branchId,
    List<int>? itemPositionIds,
  }) async {
    final payload = Map<String, dynamic>.from(dto.toJson());
    if (branchId != null) {
      payload['branchId'] = branchId;
    }
    if (itemPositionIds != null) {
      payload['itemPositionsIds'] = itemPositionIds;
      payload['divisionStrategy'] = 'ByQuantity';
    }

    return await postAsync(
      ApiEndpoints.bossPanelCreateInventoryByZone,
      data: payload,
    );
  }
  Future<void> scanQrCheckInAsync(String payload, int branchId, String checkType) async {
    await postAsync(
      ApiEndpoints.qrCheckInScan,
      data: {
        "payload": payload,
        "branchId": branchId,
        "checkType": checkType,
      },
    );
  }
  Future<List<AvailableOrderDto>> getBossPanelAvailableOrdersAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelAvailableOrders);
    return (response as List).map((x) => AvailableOrderDto.fromJson(x)).toList();
  }

  Future<int> createBossPanelOrderAssemblyTaskAsync(CreateOrderAssemblyTaskDto dto) async {
    return await postAsync(ApiEndpoints.bossPanelCreateOrderAssembly, data: dto.toJson());
  }

  // Inventory API Endpoints
  Future<InventoryTaskDetailsDto?> getInventoryTaskDetailsAsync(int assignmentId) async {
    final response = await getAsync(ApiEndpoints.inventoryTaskDetails(assignmentId));
    if (response == null || response is! Map<String, dynamic>) return null;
    return _mapInventoryAssignmentDetails(response);
  }

  InventoryTaskDetailsDto _mapInventoryAssignmentDetails(Map<String, dynamic> json) {
    final createdDateRaw = json['createdDate']?.toString();
    final createdDate = DateTime.tryParse(createdDateRaw ?? '') ?? DateTime.now();

    final cellInventoriesRaw = (json['cellInventories'] as List?) ?? const [];
    final items = <InventoryItemDto>[];

    for (final cell in cellInventoriesRaw) {
      if (cell is! Map<String, dynamic>) continue;

      final positionId = (cell['positionId'] as num?)?.toInt() ?? 0;
      final positionCode = (cell['cellDisplayName'] ?? cell['cellCode'] ?? '').toString();
      final cellItemsRaw = (cell['items'] as List?) ?? const [];

      for (final item in cellItemsRaw) {
        if (item is! Map<String, dynamic>) continue;

        items.add(InventoryItemDto(
          itemId: (item['itemId'] as num?)?.toInt() ?? 0,
          lineId: (item['lineId'] as num?)?.toInt(),
          itemName: (item['itemName'] ?? '').toString(),
          positionCode: positionCode,
          positionId: positionId,
          expectedQuantity: (item['expectedQuantity'] as num?)?.toInt() ?? 0,
        ));
      }
    }

    return InventoryTaskDetailsDto(
      taskId: (json['taskId'] as num?)?.toInt() ?? 0,
      zoneCode: '',
      items: items,
      totalExpectedCount: (json['totalLines'] as num?)?.toInt() ?? items.length,
      initiatedAt: createdDate,
    );
  }

  Future<CompleteAssignmentResultDto?> completeInventoryAssignmentAsync(CompleteAssignmentDto dto) async {
    final response = await postAsync(ApiEndpoints.inventoryCompleteAssignment, data: dto.toJson());
    if (response == null) return null;
    return CompleteAssignmentResultDto.fromJson(response);
  }

  Future<ItemInfoDto?> getItemInfoAsync(int itemId) async {
    final response = await getAsync(ApiEndpoints.itemInfo(itemId));
    if (response == null) return null;
    return ItemInfoDto.fromJson(response);
  }

  Future<InventoryStatisticsDto?> processInventoryScanAsync(ProcessInventoryScanDto dto) async {
    final response = await postAsync(ApiEndpoints.inventoryProcessScan, data: dto.toJson());
    if (response == null) return null;
    return InventoryStatisticsDto.fromJson(response);
  }

  // Order Assembly API Endpoints
  Future<List<WorkerAssemblyTaskDto>> getOrderAssemblyTasksAsync(int userId) async {
    final response = await getAsync(ApiEndpoints.orderAssemblyTasks(userId));
    if (response == null || response is! List) return [];
    return (response).map((x) => WorkerAssemblyTaskDto.fromJson(x)).toList();
  }

  Future<WorkerAssemblyTaskDto?> getOrderAssemblyTaskDetailsAsync(int assignmentId) async {
    final response = await getAsync(ApiEndpoints.orderAssemblyDetails(assignmentId));
    if (response == null || response is! Map<String, dynamic>) return null;
    return WorkerAssemblyTaskDto.fromJson(response);
  }

Future<void> scanAssemblyPickAsync(int assignmentId, int lineId, String barcode) async {
    try {
      await postAsync(ApiEndpoints.orderAssemblyScanPick(assignmentId), data: {
        'lineId': lineId,
        'barcode': barcode,
      });
    } catch (e) {
      Logger.w('Ошибка при сканировании товара сборки: $e');
      rethrow;
    }
  }

  Future<void> scanAssemblyPlaceAsync(int assignmentId, int lineId, String cellCode) async {
    try {
      await postAsync(ApiEndpoints.orderAssemblyScanPlace(assignmentId), data: {
        'lineId': lineId,
        'cellCode': cellCode,
      });
    } catch (e) {
      Logger.w('Ошибка при сканировании ячейки сборки: $e');
      rethrow;
    }
  }

Future<void> scanReturnItemAsync(int assignmentId, int lineId, String barcode) async {
    await postAsync(ApiEndpoints.returnScanItem(assignmentId), data: {
      'lineId': lineId,
      'barcode': barcode,
    });
  }

  Future<void> scanReturnCellAsync(int assignmentId, int lineId, String cellCode) async {
    await postAsync(ApiEndpoints.returnScanCell(assignmentId), data: {
      'lineId': lineId,
      'cellCode': cellCode,
    });
  }

  Future<void> orderAssemblyScanPlaceBulkAsync(int assignmentId, String cellCode) async {
    final request = ScanPlaceBulkRequest(assignmentId: assignmentId, cellCode: cellCode);
    await postAsync(ApiEndpoints.orderAssemblyScanPlaceBulk, data: request.toJson());
  }

  Future<void> orderAssemblyReportMissingAsync(int lineId, String reason) async {
    final request = ReportMissingRequest(lineId: lineId, reason: reason);
    await postAsync(ApiEndpoints.orderAssemblyReportMissing, data: request.toJson());
  }

  Future<void> orderAssemblyCompleteAsync(int assignmentId) async {
    await postAsync(ApiEndpoints.orderAssemblyComplete(assignmentId), data: null);
  }

  /// Получить текущий статус перерыва сотрудника
  Future<BreakStatusDto> getBreakStatusAsync(int employeeId) async {
    try {
      final response = await getAsync(ApiEndpoints.breakStatus(employeeId));
      return BreakStatusDto.fromJson(response);
    } catch (e) {
      Logger.e('Ошибка получения статуса перерыва для сотрудника $employeeId', e);
      rethrow;
    }
  }

  /// Запрос на начало перерыва
  Future<void> startBreakAsync(int employeeId) async {
    try {
      await postAsync(ApiEndpoints.startBreak(employeeId));
    } catch (e) {
      Logger.e('Ошибка начала перерыва для сотрудника $employeeId', e);
      rethrow;
    }
  }

  /// Запрос на завершение перерыва
  Future<void> endBreakAsync(int employeeId) async {
    try {
      await postAsync(ApiEndpoints.endBreak(employeeId));
    } catch (e) {
      Logger.e('Ошибка завершения перерыва для сотрудника $employeeId', e);
      rethrow;
    }
  }
  Future<List<OrderDto>> getCustomerOrdersAsync(int customerId) async {
    try {
      final response = await getAsync(ApiEndpoints.customerOrders(customerId));
      
      // Поскольку getAsync уже возвращает response.data, 
      // нам остается только проверить, что это список, и скрафтить DTO.
      if (response != null && response is List) {
        return response.map((json) => OrderDto.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      Logger.e('Ошибка загрузки заказов клиента $customerId', e);
      throw Exception('Ошибка загрузки заказов: $e');
    }
  }
Future<void> orderAssemblyVerifyQrAsync(int assignmentId, String qrToken) async {
    try {
      await postAsync(
        ApiEndpoints.orderAssemblyVerifyQr(assignmentId),
        data: { 'qrToken': qrToken },
      );
    } catch (e) {
      Logger.w('Ошибка при верификации QR: $e');
      rethrow;
    }
  }

  // Внутри класса ApiClient
void forceResetNetworkState() {
  _hasNetwork = true;
  Logger.i('ApiClient: Состояние сети принудительно сброшено (hasNetwork = true)');
}

Future<void> orderAssemblyExpressHandoverAsync(
  int assignmentId, 
  String qrToken, 
  Map<int, int>? cancelledLines,
) async {
  try {
    // Преобразуем Map<int, int> в Map<String, int>, чтобы JSON смог его прочитать
    final Map<String, dynamic>? formattedCancelledLines = cancelledLines?.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    await postAsync(
      ApiEndpoints.orderAssemblyExpressHandover(assignmentId),
      data: {
        'qrToken': qrToken,
        'cancelledLines': formattedCancelledLines, // Теперь ключи — строки
      },
    );
  } catch (e) {
    Logger.w('Ошибка при экспресс-выдаче заказа: $e');
    rethrow;
  }
}
  Future<Map<String, dynamic>> orderHandoverScanAsync(int taskId, int workerId, String barcode) async {
    final url = ApiEndpoints.orderHandoverScan(taskId, workerId);
    
    // Согласно требованию, отправляем строку в формате JSON: "$barcode"
    final response = await postAsync(url, data: '"$barcode"');
    
    return response as Map<String, dynamic>;
  }
  
  Future<List<AvailableEmployeeDto>> getBossPanelAvailableCouriersAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelAvailableCouriers);
    if (response == null || response is! List) return [];
    return response.map((x) => AvailableEmployeeDto.fromJson(x)).toList();
  }

  Future<List<AvailableOrderDto>> getBossPanelReadyOrdersAsync() async {
    final response = await getAsync(ApiEndpoints.bossPanelReadyOrders);
    if (response == null || response is! List) return [];
    return response.map((x) => AvailableOrderDto.fromJson(x)).toList();
  }

Future<List<MobileBaseTaskDto>> getGlobalPoolTasksAsync(int branchId) async {
    final response = await getAsync(ApiEndpoints.globalPoolTasks(branchId));
    if (response == null || response is! List) return [];
    return response.map((x) => MobileBaseTaskDto.fromJson(x)).toList();
  }

  Future<void> claimTaskFromPoolAsync(int taskId, int workerId) async {
    await postAsync(ApiEndpoints.claimPoolTask(taskId, workerId));
  }

// 1. Для обычной выдачи в магазине
  Future<void> completeWorkerTaskAsync(int taskId, int workerId, {Map<int, int>? cancelledLines}) async {
    try {
      // Собираем чистый Map<String, dynamic>, который Dio 100% переварит
      final Map<String, dynamic> requestData = {};
      
      if (cancelledLines != null && cancelledLines.isNotEmpty) {
        final Map<String, dynamic> serializedLines = {};
        cancelledLines.forEach((key, value) {
          serializedLines[key.toString()] = value;
        });
        requestData['cancelledLines'] = serializedLines;
      }

      await postAsync(
        ApiEndpoints.workerTaskComplete(taskId, workerId),
        data: requestData.isNotEmpty ? requestData : null,
      );
    } catch (e) {
      Logger.w('Ошибка при завершении задачи: $e');
      rethrow;
    }
  }

  // 2. Для курьерской доставки
  Future<void> completeCourierHandoverAsync(int taskId, int workerId, String qrToken, {Map<int, int>? cancelledLines}) async {
    try {
      final Map<String, dynamic> requestData = {
        'qrToken': qrToken,
        'courierId': workerId,
      };

      if (cancelledLines != null && cancelledLines.isNotEmpty) {
        final Map<String, dynamic> serializedLines = {};
        cancelledLines.forEach((key, value) {
          serializedLines[key.toString()] = value;
        });
        requestData['rejectedQuantities'] = serializedLines;
      }

      await postAsync(
        ApiEndpoints.courierPartialComplete,
        data: requestData,
      );
    } catch (e) {
      Logger.e('Ошибка подтверждения доставки курьером: $e');
      rethrow;
    }
  }



  /// Запрос на получение временного QR-кода курьера для приемки товаров
  Future<Map<String, dynamic>?> getCourierPickupQrAsync(int courierId) async {
    try {
      final response = await getAsync(ApiEndpoints.getCourierPickupQr(courierId));
      
      if (response != null && response is Map<String, dynamic>) {
        return response; // Возвращаем Map, чтобы достать Token и ExpiresInSeconds
      }
      return null;
    } catch (e) {
      Logger.e('Ошибка при получении QR-кода для курьера $courierId', e);
      rethrow;
    }
  }

  Future<List<OrderDto>> getCourierOrdersAsync(int courierId) async {
    try {
      final response = await getAsync(ApiEndpoints.getCourierOrders(courierId));
      if (response == null || response is! List) return [];
      return response.map((x) => OrderDto.fromJson(x)).toList();
    } catch (e) {
      Logger.e('Ошибка загрузки заказов курьера $courierId', e);
      throw Exception('Не удалось загрузить маршрутный лист');
    }
  }

  Future<void> confirmDeliveryAsync(int orderId) async {
    try {
      await postAsync(ApiEndpoints.deliverCourierOrder(orderId));
    } catch (e) {
      Logger.e('Ошибка подтверждения доставки заказа $orderId', e);
      rethrow;
    }
  }

  Future<int?> initCourierBatchHandoverAsync(List<int> orderIds, int courierId, int branchId) async {
    try {
      final response = await postAsync(
        ApiEndpoints.initCourierBatchHandover,
        data: {
          'orderIds': orderIds,
          'courierId': courierId,
          'branchId': branchId,
        },
      );
      
      if (response != null && response['taskId'] != null) {
        return response['taskId'] as int;
      }
      return null;
    } catch (e) {
      Logger.w('Ошибка при формировании пакетной отгрузки курьеру: $e');
      rethrow;
    }
  }

Future<int?> initCustomerHandoverAsync(String qrToken, int workerId, int branchId, int expectedOrderId) async {
    try {
      final response = await postAsync(
        ApiEndpoints.initCustomerHandover,
        data: {
          'qrToken': qrToken,
          'workerId': workerId,
          'branchId': branchId,
          'expectedOrderId': expectedOrderId,
        },
      );
      
      if (response != null && response['taskId'] != null) {
        return response['taskId'] as int;
      }
      return null;
    } catch (e) {
      Logger.w('Ошибка при инициализации выдачи по QR: $e');
      rethrow;
    }
  }

  Future<OrderDto> getOrderByIdAsync(int orderId) async {
    try {
      final response = await getAsync(ApiEndpoints.orderDetails(orderId));
      
      if (response != null && response is Map<String, dynamic>) {
        return OrderDto.fromJson(response);
      }
      throw ApiException('Неверный формат ответа от сервера');
    } catch (e) {
      Logger.e('Ошибка загрузки деталей заказа $orderId', e);
      throw Exception('Ошибка загрузки деталей заказа: $e');
    }
  }

  Future<String> getBaseUrlAsync() async {
    return await _resolveBaseUrl();
  }
}
