import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:helper_app/core/models/config/app_config_dto.dart';
import 'package:helper_app/core/models/user/current_user.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/logger.dart';

class DeliverySlot {
  final int id;
  final String name;
  final int startHour;
  final int endHour;

  DeliverySlot(this.id, this.name, this.startHour, this.endHour);
}

final List<DeliverySlot> defaultSlots = [
  DeliverySlot(1, 'Утро (10:00 - 14:00)', 10, 14),
  DeliverySlot(2, 'День (14:00 - 18:00)', 14, 18),
  DeliverySlot(3, 'Вечер (18:00 - 22:00)', 18, 22),
];

enum DeliveryType {
  pickup('Самовывоз'),
  express('Экспресс-доставка'),
  courier('Курьерская доставка'),
  postamat('Доставка в постамат');

  const DeliveryType(this.label);
  final String label;

  String toServerString() {
    switch (this) {
      case DeliveryType.pickup:
        return 'Pickup';
      case DeliveryType.express:
        return 'Express';
      case DeliveryType.courier:
        return 'Delivery';
      case DeliveryType.postamat:
        return 'Postamat';
    }
  }
}

class Branch {
  final int branchId;
  final String branchName;
  final String? branchType;
  final String? address;

  Branch({
    required this.branchId,
    required this.branchName,
    this.branchType,
    this.address,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      branchId: json['branchId'] as int? ?? 0,
      branchName: json['branchName'] as String? ?? 'Неизвестный филиал',
      branchType: json['branchType'] as String?,
      address: json['address'] as String?,
    );
  }
}

class AvailableItem {
  final int itemId;
  final String name;
  final double price;
  final int availableQuantity;
  final double length;
  final double width;
  final double height;

  AvailableItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.availableQuantity,
    this.length = 100, 
    this.width = 100,
    this.height = 100,
  });

  factory AvailableItem.fromJson(Map<String, dynamic> json) {
    return AvailableItem(
      itemId: json['itemId'] as int? ?? 0,
      name: json['name'] as String? ?? 'Без названия',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      availableQuantity: json['availableQuantity'] as int? ?? 0,
      length: (json['length'] as num?)?.toDouble() ?? 100,
      width: (json['width'] as num?)?.toDouble() ?? 100,
      height: (json['height'] as num?)?.toDouble() ?? 100,
    );
  }
}

class Postamat {
  final int id;
  final String address;

  Postamat({required this.id, required this.address});

  factory Postamat.fromJson(Map<String, dynamic> json) {
    return Postamat(
      id: json['id'] as int? ?? 0,
      address: json['address'] as String? ?? 'Неизвестный адрес',
    );
  }
}

class CreateOrderViewModel extends ChangeNotifier {
  final ApiClient _apiClient;
  final int customerId;
  CreateOrderViewModel(this._apiClient, this.customerId);

  int currentStep = 0;
  bool isLoading = false;
  String? errorMessage;

  List<Branch> branches = [];
  Branch? selectedBranch;

  List<AvailableItem> availableItems = [];
  Map<int, int> cart = {};

  DeliveryType selectedDeliveryType = DeliveryType.pickup;
  List<Postamat> postamats = [];
  Postamat? selectedPostamat;
  DateTime? deliveryDate;
  String destinationAddress = '';
  bool prepayNow = false; 
  DeliverySlot? selectedSlot;
  List<DeliverySlot> availableSlots = [];
  AppConfigDto? appConfig;

  bool isCheckingPostamatCapacity = false;
  bool? postamatCapacityOk;
  String? postamatCapacityError;

  Future<void> _fetchConfig() async {
    try {
      appConfig = await _apiClient.getAppConfigAsync();
    } catch (e) {
      Logger.e('Ошибка при загрузке конфига', e);
      appConfig = AppConfigDto(
        pickupWindowLimitHours: 0.5, 
        deliveryWindowLimitHours: 1.0, 
        weightCoefficient: 1.0, 
        maxConcurrentBreaksPercentage: 20,
        breakDurationMinutes: 10,
        workMinutesRequiredForBreak: 60,
        useUnifiedWorkerTasksApi: true,
      );
    }
    notifyListeners();
  }
  
  Future<void> initialize() async {
    await _fetchConfig();
    await _fetchBranches();
  }

  void nextStep() {
    if (canProceedToNextStep()) {
      currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  bool canProceedToNextStep() {
    switch (currentStep) {
      case 0: return selectedBranch != null;
      case 1: return cart.isNotEmpty;
      case 2: 
        if (selectedDeliveryType == DeliveryType.postamat) {
          return selectedPostamat != null;
        }
        if (selectedDeliveryType == DeliveryType.courier) {
          return destinationAddress.isNotEmpty && selectedSlot != null && deliveryDate != null;
        }
        if (selectedDeliveryType == DeliveryType.pickup) {
          return deliveryDate != null; 
        }
        return true; 
      case 3: return canSubmitOrder;
      default: return false;
    }
  }

  Future<void> _fetchBranches() async {
    await _withLoading(() async {
      final response = await _apiClient.getAsync(ApiEndpoints.getBranches);
      if (response is List) {
        branches = response.map((json) => Branch.fromJson(json)).toList();
      }
    });
  }

  void selectBranch(Branch branch) {
    if (selectedBranch?.branchId == branch.branchId) return;
    selectedBranch = branch;
    cart.clear(); 
    _fetchItems();
  }

  Future<void> _fetchItems([String query = '']) async {
    if (selectedBranch == null) return;
    await _withLoading(() async {
      final endpoint = ApiEndpoints.getAvailableItems(selectedBranch!.branchId, query: query);
      final response = await _apiClient.getAsync(endpoint);
      if (response is List) {
        availableItems = response.map((json) => AvailableItem.fromJson(json)).toList();
      }
    });
  }

  Future<void> searchItems(String query) async {
    await _fetchItems(query);
  }

  Future<void> _fetchPostamats() async {
    if (postamats.isNotEmpty) return;
    await _withLoading(() async {
      final response = await _apiClient.getAsync(ApiEndpoints.getPostamats);
      if (response is List) {
        postamats = response.map((json) => Postamat.fromJson(json)).toList();
      }
    });
  }

  void updateCartQuantity(int itemId, int delta, int maxQuantity) {
    int current = cart[itemId] ?? 0;
    int newVal = current + delta;
    
    if (newVal < 0) return;
    if (newVal > maxQuantity) newVal = maxQuantity;

    if (newVal == 0) {
      cart.remove(itemId);
    } else {
      cart[itemId] = newVal;
    }
    notifyListeners();
  }

  void setManualQuantity(int itemId, int value, int maxQuantity) {
    if (value < 0) return;
    int finalValue = value > maxQuantity ? maxQuantity : value;

    if (finalValue == 0) {
      cart.remove(itemId);
    } else {
      cart[itemId] = finalValue;
    }
    notifyListeners();
  }

  double get cartTotalPrice {
    double total = 0;
    for (var entry in cart.entries) {
      final item = availableItems.firstWhere((i) => i.itemId == entry.key, orElse: () => availableItems.first);
      total += item.price * entry.value;
    }
    return total;
  }
  
  int get totalItemsCount {
      int count = 0;
      for (var qty in cart.values) { count += qty; }
      return count;
  }

  void setPostamat(Postamat postamat) {
    selectedPostamat = postamat;
    postamatCapacityOk = null;
    postamatCapacityError = null;
    notifyListeners();
  }

  /// Возвращает первую доступную дату для календаря с учетом лимита из конфига
/// Возвращает первую доступную дату для календаря с учетом лимита из конфига
  DateTime get firstAvailableDeliveryDate {
    final now = DateTime.now();
    // Берем лимит времени из конфига (по умолчанию 1.0 час, если конфиг не загружен)
    final limitHours = appConfig?.deliveryWindowLimitHours ?? 1.0;
    final limitMinutes = (limitHours * 60).toInt();
    
    final minRequiredTime = now.add(Duration(minutes: limitMinutes));
    final today = DateTime(now.year, now.month, now.day);
    
    // Проверяем, есть ли хотя бы одно окно СЕГОДНЯ, которое еще НЕ ЗАКОНЧИЛОСЬ
    bool hasSlotsToday = defaultSlots.any((slot) {
      final slotEndToday = today.add(Duration(hours: slot.endHour));
      return slotEndToday.isAfter(minRequiredTime);
    });
    
    return hasSlotsToday ? today : today.add(const Duration(days: 1));
  }
  
  // Вычисляет доступные слоты для выбранного дня
void _calculateAvailableSlots() {
    if (deliveryDate == null) {
      availableSlots = [];
      selectedSlot = null;
      return;
    }

    final now = DateTime.now();
    
    // Приводим deliveryDate к локальному времени без смещения дней, 
    // так как year, month, day у UTC-объекта соответствуют выбранной дате.
    final isToday = deliveryDate!.year == now.year && 
                    deliveryDate!.month == now.month && 
                    deliveryDate!.day == now.day;

    if (isToday) {
      final limitHours = appConfig?.deliveryWindowLimitHours ?? 1.0;
      final limitMinutes = (limitHours * 60).toInt();
      final minRequiredTime = now.add(Duration(minutes: limitMinutes));
      
      final today = DateTime(now.year, now.month, now.day);
      
      // Доступны те слоты, которые еще не завершились
      availableSlots = defaultSlots.where((slot) {
        final slotEndToday = today.add(Duration(hours: slot.endHour));
        return slotEndToday.isAfter(minRequiredTime);
      }).toList();
    } else {
      availableSlots = List.from(defaultSlots); 
    }

    // Обязательно сбрасываем выбранный слот, если он больше недоступен в новом списке
    if (selectedSlot != null) {
      final stillAvailable = availableSlots.any((s) => s.id == selectedSlot!.id);
      if (!stillAvailable) {
        selectedSlot = null;
      }
    }
  }



  DateTime get minPickupTime {
      final prepHours = appConfig?.pickupWindowLimitHours ?? 1.0;
      final prepMinutes = (prepHours * 60).toInt();
      final now = DateTime.now().toLocal();
      
      var minTime = now.add(Duration(minutes: prepMinutes));

      if (minTime.hour < 10) {
        return DateTime(minTime.year, minTime.month, minTime.day, 10, 0);
      }

      if (minTime.hour >= 22) {
        final tomorrow = minTime.add(const Duration(days: 1));
        return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 0);
      }

      return minTime;
    }


  void setDeliveryDate(DateTime date) {
    if (selectedDeliveryType == DeliveryType.courier) {
      deliveryDate = DateTime.utc(date.year, date.month, date.day);
    } else if (selectedDeliveryType == DeliveryType.pickup) {
      int hour = date.hour;
      if (hour < 10) hour = 10;
      if (hour >= 22) hour = 21; 

      deliveryDate = DateTime(date.year, date.month, date.day, hour, date.minute);
    } else {
      deliveryDate = date;
    }
    
    _calculateAvailableSlots();
    notifyListeners();
  }

  void setDeliverySlot(DeliverySlot slot) {
    selectedSlot = slot;
    notifyListeners();
  }

  void setDeliveryType(DeliveryType type) {
    selectedDeliveryType = type;
    deliveryDate = null; 
    selectedSlot = null;
    
    if (type == DeliveryType.postamat) {
      _fetchPostamats();
    }
    
    if (type == DeliveryType.pickup || type == DeliveryType.express) {
       destinationAddress = selectedBranch?.address ?? '';
    } else {
       destinationAddress = '';
    }

    postamatCapacityOk = null;
    postamatCapacityError = null;
    notifyListeners();
  }
  
  void setDestinationAddress(String address) {
      destinationAddress = address;
      notifyListeners();
  }
  
  void togglePrepay(bool value) {
      prepayNow = value;
      notifyListeners();
  }

  Future<void> checkCapacityAndSubmit() async {
    if (selectedDeliveryType == DeliveryType.postamat) {
      await _checkPostamatCapacity();
      if (postamatCapacityOk != true) {
        return; 
      }
    }
    
    await _createOrder();
  }

  Future<void> _checkPostamatCapacity() async {
    if (selectedPostamat == null || cart.isEmpty) return;

    isCheckingPostamatCapacity = true;
    postamatCapacityError = null;
    notifyListeners();

    try {
      final itemsToPack = cart.entries.map((entry) {
        final item = availableItems.firstWhere((i) => i.itemId == entry.key);
        return {
          'orderPositionId': 0, 
          'itemId': item.itemId,
          'length': item.length,
          'width': item.width,
          'height': item.height,
          'quantity': entry.value
        };
      }).toList();

      final payload = {
        'postamatId': selectedPostamat!.id,
        'itemsToPack': itemsToPack
      };

      Logger.i('Проверка габаритов: $payload');
      final response = await _apiClient.postAsync(ApiEndpoints.checkPostamatCapacity, data: payload);
      
      if (response == true) {
         postamatCapacityOk = true;
      } else {
         postamatCapacityOk = false;
         postamatCapacityError = 'Габариты заказа превышают размер свободных ячеек в выбранном терминале. Уменьшите количество товаров или измените способ доставки.';
      }
    } catch (e) {
      Logger.e('Ошибка при проверке габаритов постамата', e);
      postamatCapacityOk = false;
      postamatCapacityError = 'Произошла ошибка при проверке вместимости терминала: $e';
    } finally {
      isCheckingPostamatCapacity = false;
      notifyListeners();
    }
  }

bool get canSubmitOrder {
    if (cart.isEmpty || selectedBranch == null) return false;
    
    if (selectedDeliveryType == DeliveryType.postamat) {
      return selectedPostamat != null && !isCheckingPostamatCapacity;
    }
    if (selectedDeliveryType == DeliveryType.courier || selectedDeliveryType == DeliveryType.express) {
      // Принудительно обновляем слоты, чтобы проверить, не истекло ли время ожидания
      _calculateAvailableSlots(); 
      return destinationAddress.isNotEmpty && selectedSlot != null && deliveryDate != null;
    }
    if (selectedDeliveryType == DeliveryType.pickup) {
      return deliveryDate != null; 
    }
    
    return true; 
  }

  Future<bool> _createOrder() async {
    if (!canSubmitOrder) return false;

    return _withLoading<bool>(() async {
      final positions = cart.entries.map((entry) {
        final item = availableItems.firstWhere((i) => i.itemId == entry.key);
        return {
            'itemId': entry.key,
            'quantity': entry.value,
            'price': item.price 
        };
      }).toList();

// Определение правильной даты для отправки на сервер
      String? dateToSubmit;
      if (deliveryDate != null) {
        if (selectedDeliveryType == DeliveryType.courier && selectedSlot != null) {
          // Собираем точное локальное время начала слота и переводим в UTC[cite: 8]
          final localStart = DateTime(
            deliveryDate!.year, 
            deliveryDate!.month, 
            deliveryDate!.day, 
            selectedSlot!.startHour
          );
          dateToSubmit = localStart.toUtc().toIso8601String();
        } else {
          // Самовывоз: Конвертируем локальное выбранное время в UTC[cite: 8]
          dateToSubmit = deliveryDate!.toUtc().toIso8601String();
        }
      }

      final payload = {
        'customerId': customerId, 
        'branchId': selectedBranch!.branchId,
        'deliveryDate': dateToSubmit, 
        'deliveryType': selectedDeliveryType.toServerString(),
        'paymentType': prepayNow ? 'Prepaid' : 'Postpaid',
        
        'destinationAddress': (selectedDeliveryType == DeliveryType.courier || selectedDeliveryType == DeliveryType.express) 
            ? destinationAddress 
            : (selectedDeliveryType == DeliveryType.postamat ? selectedPostamat?.address : null),
        
        'postamatId': selectedDeliveryType == DeliveryType.postamat ? selectedPostamat?.id : null,
        'deliverySlotId': selectedDeliveryType == DeliveryType.courier ? selectedSlot?.id : null,
        'totalPrice': cartTotalPrice, 
        'positions': positions
      };
      
      Logger.i('Отправка заказа на сервер: $payload');
      
      await _apiClient.postAsync(ApiEndpoints.createOrder, data: payload);
      return true;
    }, fallback: false);
  }

  String branchSearchQuery = '';

  List<Branch> get filteredBranches {
    if (branchSearchQuery.isEmpty) return branches;
    final q = branchSearchQuery.toLowerCase();
    return branches.where((b) {
      return b.branchName.toLowerCase().contains(q) ||
             (b.address != null && b.address!.toLowerCase().contains(q));
    }).toList();
  }

  void filterBranches(String query) {
    branchSearchQuery = query;
    notifyListeners();
  }

  Future<T> _withLoading<T>(Future<T> Function() action, {T? fallback}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await action();
      return result;
    } catch (e) {
      Logger.e('CreateOrderViewModel Error', e);
      errorMessage = e.toString();
      return fallback as T;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}