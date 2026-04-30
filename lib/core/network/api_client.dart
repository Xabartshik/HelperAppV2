import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:helper_app/core/models/attendance/check_io_employee_dto.dart';
import 'package:helper_app/core/models/config/app_config_dto.dart';
import '../utils/logger.dart';
import 'api_exceptions.dart';
import 'api_endpoints.dart';
import '../models/boss_panel/boss_panel_models.dart';
import '../models/inventory/inventory_dtos.dart';
import '../models/order_assembly/order_assembly_dtos.dart';

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

  void _handleResponseErrors(Response response) {
    if (response.statusCode == 401) {
      throw UnauthorizedException('Токен истёк или невалиден');
    }
    if (response.statusCode == 404) {
      throw NotFoundException('Ресурс не найден: ${response.requestOptions.path}');
    }
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ApiException('HTTP ошибка: ${response.statusCode}');
    }
    if (response.statusCode == 409) {
      // Пытаемся достать текст ошибки ('error': '...'), который мы отправляем из C#
      final errorMessage = (response.data is Map && response.data['error'] != null) 
          ? response.data['error'].toString() 
          : 'Пользователь с такими данными уже существует';
      throw ConflictException(errorMessage);
    }
    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ApiException('HTTP ошибка: ${response.statusCode}');
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

  Future<void> orderAssemblyScanPickAsync(int lineId, String barcode) async {
    final request = ScanPickRequest(lineId: lineId, barcode: barcode);
    await postAsync(ApiEndpoints.orderAssemblyScanPick, data: request.toJson());
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
}
