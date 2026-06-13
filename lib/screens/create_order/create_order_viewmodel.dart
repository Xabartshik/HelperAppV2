import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:helper_app/core/models/config/app_config_dto.dart';
import '../../core/models/branch/cart_check_dto.dart';
import '../../core/models/branch/branch_stock_dto.dart';
import '../../core/models/branch/branch_dto.dart';
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
  express('Выдача в зал'),
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

enum PaymentType {
  prepaid('Предоплата онлайн'),
  postpaid('При получении (Постоплата)');

  const PaymentType(this.label);
  final String label;

  String toServerString() {
    switch (this) {
      case PaymentType.prepaid: return 'Prepaid';
      case PaymentType.postpaid: return 'Postpaid';
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
  int branchCount; // 0 означает отсутствует в продаже

  AvailableItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.availableQuantity,
    this.length = 100, 
    this.width = 100,
    this.height = 100,
    this.branchCount = 0,
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
  PaymentType selectedPaymentType = PaymentType.prepaid;
  
  List<Postamat> postamats = [];
  Postamat? selectedPostamat;
  DateTime? deliveryDate;
  String destinationAddress = '';
  DeliverySlot? selectedSlot;
  List<DeliverySlot> availableSlots = [];
  AppConfigDto? appConfig;

  bool isCheckingPostamatCapacity = false;
  bool? postamatCapacityOk;
  String? postamatCapacityError;

  List<BranchDto> availableBranches = [];
  List<BranchAvailabilityDto> partiallyAvailableBranches = [];
  bool isCartValidForSingleBranch = true;
  String? cartConflictMessage;
  List<AvailableItem> globalItems = [];

  /// Список частей разделенной корзины, ожидающих оформления.
  List<Map<int, int>> pendingSplitCarts = [];
  
  /// Общее число частей, на которые был разделен исходный заказ.
  int totalSplitsCount = 0;
  
  /// Индекс текущей оформляемой части заказа.
  int currentSplitIndex = 0;

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
    await _fetchGlobalItems();
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
      case 0: return cart.isNotEmpty;
      case 1: return selectedBranch != null && availableBranches.any((ab) => ab.branchId == selectedBranch!.branchId);
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
    notifyListeners();
  }

  Future<void> _fetchGlobalItems([String query = '']) async {
    await _withLoading(() async {
      final response = await _apiClient.getAsync('v1/Item');
      
      Map<int, Map<String, int>> branchCounts = {};
      try {
        final countsResponse = await _apiClient.getAsync('ItemPosition/branch-counts');
        if (countsResponse is Map) {
          branchCounts = countsResponse.map((key, value) {
            final valMap = value as Map;
            return MapEntry(
              int.parse(key.toString()),
              {
                'branchCount': valMap['branchCount'] as int? ?? 0,
                'totalAvailableQuantity': valMap['totalAvailableQuantity'] as int? ?? 0,
              },
            );
          });
        }
      } catch (e) {
        Logger.e('Failed to fetch item branch counts', e);
      }

      if (response is List) {
        globalItems = response.map((json) {
          final id = json['itemId'] as int? ?? 0;
          final name = json['name'] as String? ?? '';
          final price = (json['price'] as num?)?.toDouble() ?? 0.0;
          final stockInfo = branchCounts[id];
          return AvailableItem(
            itemId: id,
            name: name,
            price: price,
            availableQuantity: stockInfo?['totalAvailableQuantity'] ?? 0,
            branchCount: stockInfo?['branchCount'] ?? 0,
          );
        }).toList();

        if (query.isNotEmpty) {
          final q = query.toLowerCase();
          availableItems = globalItems.where((item) => item.name.toLowerCase().contains(q)).toList();
        } else {
          availableItems = List.from(globalItems);
        }
      }
    });
  }

  Future<void> searchItems(String query) async {
    await _fetchGlobalItems(query);
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

  Future<void> checkCartAvailability() async {
    if (cart.isEmpty) {
      availableBranches = branches.map((b) => BranchDto(
        branchId: b.branchId,
        branchName: b.branchName,
        branchType: b.branchType ?? '',
        address: b.address ?? '',
      )).toList();
      partiallyAvailableBranches = [];
      isCartValidForSingleBranch = true;
      cartConflictMessage = null;
      notifyListeners();
      return;
    }

    try {
      final itemsDto = cart.entries.map((e) => CartItemDto(itemId: e.key, requiredQuantity: e.value)).toList();
      final request = CartCheckRequestDto(items: itemsDto);
      final response = await _apiClient.postAsync('ItemPosition/check-cart-branches', data: request.toJson());
      
      final availability = BranchAvailabilityResponseDto.fromJson(response as Map<String, dynamic>);
      availableBranches = availability.availableBranches;
      partiallyAvailableBranches = availability.partiallyAvailableBranches;
      isCartValidForSingleBranch = availableBranches.isNotEmpty;

      if (!isCartValidForSingleBranch) {
        cartConflictMessage = 'Товары из вашей корзины отсутствуют в одном магазине в нужном количестве. Пожалуйста, разделите заказ или удалите отсутствующие товары.';
      } else {
        cartConflictMessage = null;
      }
      notifyListeners();
    } catch (e) {
      Logger.e('Ошибка проверки доступности корзины', e);
    }
  }

  Future<bool> wouldAddingItemCauseConflict(int itemId) async {
    if (cart.isEmpty) return false;
    
    final tempCart = Map<int, int>.from(cart);
    tempCart[itemId] = (tempCart[itemId] ?? 0) + 1;
    
    try {
      final itemsDto = tempCart.entries.map((e) => CartItemDto(itemId: e.key, requiredQuantity: e.value)).toList();
      final request = CartCheckRequestDto(items: itemsDto);
      final response = await _apiClient.postAsync('ItemPosition/check-cart-branches', data: request.toJson());
      final availability = BranchAvailabilityResponseDto.fromJson(response as Map<String, dynamic>);
      return availability.availableBranches.isEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<int, int>>> splitCartAutomatically() async {
    final itemIds = cart.keys.toList();
    final itemBranches = <int, List<int>>{};

    for (final b in branches) {
      final branchId = b.branchId;
      final isFull = availableBranches.any((ab) => ab.branchId == branchId);
      if (isFull) {
        return [Map<int, int>.from(cart)];
      }

      final partInfo = partiallyAvailableBranches.firstWhere(
        (pb) => pb.branch.branchId == branchId,
        orElse: () => BranchAvailabilityDto(
          branch: BranchDto(branchId: branchId),
          missingItems: [],
        ),
      );

      for (final itemId in itemIds) {
        final requiredQty = cart[itemId]!;
        final missing = partInfo.missingItems.firstWhere(
          (m) => m.itemId == itemId,
          orElse: () => MissingItemDto(itemId: itemId, requiredQuantity: requiredQty, availableQuantity: requiredQty),
        );

        if (missing.availableQuantity >= requiredQty) {
          itemBranches.putIfAbsent(itemId, () => []).add(branchId);
        }
      }
    }

    final remainingItems = Set<int>.from(cart.keys);
    final splits = <Map<int, int>>[];

    while (remainingItems.isNotEmpty) {
      int bestBranchId = -1;
      int maxFulfilledCount = -1;
      final bestBranchItems = <int>[];

      for (final b in branches) {
        int fulfilledCount = 0;
        final fulfilledItems = <int>[];
        for (final itemId in remainingItems) {
          final branchesWithItem = itemBranches[itemId] ?? [];
          if (branchesWithItem.contains(b.branchId)) {
            fulfilledCount++;
            fulfilledItems.add(itemId);
          }
        }

        if (fulfilledCount > maxFulfilledCount) {
          maxFulfilledCount = fulfilledCount;
          bestBranchId = b.branchId;
          bestBranchItems.clear();
          bestBranchItems.addAll(fulfilledItems);
        }
      }

      if (bestBranchId == -1 || bestBranchItems.isEmpty) {
        final fallbackCart = <int, int>{};
        for (final itemId in remainingItems) {
          fallbackCart[itemId] = cart[itemId]!;
        }
        splits.add(fallbackCart);
        break;
      }

      final splitCart = <int, int>{};
      for (final itemId in bestBranchItems) {
        splitCart[itemId] = cart[itemId]!;
        remainingItems.remove(itemId);
      }
      splits.add(splitCart);
    }

    return splits;
  }

  /// Инициализирует процесс поочередного оформления разделенных заказов.
  void startIndividualSplitCheckout(List<Map<int, int>> splits) {
    if (splits.isEmpty) return;
    pendingSplitCarts = List.from(splits);
    totalSplitsCount = splits.length;
    currentSplitIndex = 1;

    // Берем первую часть
    cart = pendingSplitCarts.removeAt(0);

    // Сбрасываем шаг и все выбранные логистические параметры
    currentStep = 1;
    selectedBranch = null;
    selectedPostamat = null;
    deliveryDate = null;
    selectedSlot = null;
    destinationAddress = '';

    checkCartAvailability();
    notifyListeners();
  }

  /// Переключает процесс на оформление следующей части разделенного заказа.
  /// Возвращает истину, если следующая часть существует и была успешно загружена.
  bool moveToNextSplit() {
    if (pendingSplitCarts.isNotEmpty) {
      cart = pendingSplitCarts.removeAt(0);
      currentSplitIndex++;

      // Сбрасываем выбранные шаги и параметры для следующей части
      currentStep = 1;
      selectedBranch = null;
      selectedPostamat = null;
      deliveryDate = null;
      selectedSlot = null;
      destinationAddress = '';

      checkCartAvailability();
      notifyListeners();
      return true;
    }
    return false;
  }

  bool updateCartQuantity(int itemId, int delta, int maxQuantity) {
    int current = cart[itemId] ?? 0;
    int newVal = current + delta;
    
    if (newVal < 0) return false;
    if (newVal > maxQuantity) return false;
    
    if (newVal == 0) {
      cart.remove(itemId);
    } else {
      cart[itemId] = newVal;
    }
    checkCartAvailability();
    notifyListeners();
    return true;
  }

  bool setManualQuantity(int itemId, int value, int maxQuantity) {
    if (value < 0) return false;
    
    bool restricted = false;
    if (value > maxQuantity) {
      value = maxQuantity;
      restricted = true;
    }

    if (value == 0) {
      cart.remove(itemId);
    } else {
      cart[itemId] = value;
    }
    checkCartAvailability();
    notifyListeners();
    return !restricted;
  }

  /// Получает информацию о распределении остатков конкретного товара по филиалам.
  Future<List<BranchStockDto>> fetchItemStockDistribution(int itemId) async {
    try {
      final response = await _apiClient.getAsync(ApiEndpoints.itemStockDistribution(itemId));
      if (response is List) {
        return response.map((json) => BranchStockDto.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      Logger.e('Failed to fetch item stock distribution', e);
    }
    return [];
  }

  double get cartTotalPrice {
    double total = 0;
    for (var entry in cart.entries) {
      final item = globalItems.firstWhere((i) => i.itemId == entry.key, orElse: () => availableItems.first);
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
  DateTime get firstAvailableDeliveryDate {
    final now = DateTime.now();
    // Берем лимит времени из конфига (по умолчанию 1.0 час, если конфиг не загружен)
    final limitHours = appConfig?.deliveryWindowLimitHours ?? 1.0;
    final limitMinutes = (limitHours * 60).toInt();
    
    final minRequiredTime = now.add(Duration(minutes: limitMinutes));
    final today = DateTime(now.year, now.month, now.day);
    
    // Проверяем, есть ли хотя бы одно окно СЕГОДНЯ, которое еще НЕ ЗАКОНЧИЛОСЬ
    bool hasSlotsToday = defaultSlots.any((slot) {
      final slotEndToday = today.add(Duration(hours: slot.startHour));
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
        final slotEndToday = today.add(Duration(hours: slot.startHour));
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
  
  void setPaymentType(PaymentType type) {
    selectedPaymentType = type;
    notifyListeners();
  }

  Future<int?> checkCapacityAndSubmit() async {
    if (selectedDeliveryType == DeliveryType.postamat) {
      await _checkPostamatCapacity();
      if (postamatCapacityOk != true) {
        return null; 
      }
    }
    
    return await submitOrder();
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
    if (selectedDeliveryType == DeliveryType.courier) {
      _calculateAvailableSlots(); 
      return destinationAddress.isNotEmpty && selectedSlot != null && deliveryDate != null;
    }
    if (selectedDeliveryType == DeliveryType.pickup) {
      return deliveryDate != null; 
    }
    
    return true; 
  }

  Future<int?> submitOrder() async {
    if (!canSubmitOrder) return null;

    return _withLoading<int?>(() async {
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
          // Собираем точное локальное время начала слота и переводим в UTC
          final localStart = DateTime(
            deliveryDate!.year, 
            deliveryDate!.month, 
            deliveryDate!.day, 
            selectedSlot!.startHour
          );
          dateToSubmit = localStart.toUtc().toIso8601String();
        } else {
          // Самовывоз: Конвертируем локальное выбранное время в UTC
          dateToSubmit = deliveryDate!.toUtc().toIso8601String();
        }
      }

      final payload = {
        'customerId': customerId, 
        'branchId': selectedBranch!.branchId,
        'deliveryDate': dateToSubmit, 
        'deliveryType': selectedDeliveryType.toServerString(),
        'paymentType': selectedPaymentType.toServerString(),
        
        'destinationAddress': (selectedDeliveryType == DeliveryType.courier || selectedDeliveryType == DeliveryType.express) 
            ? destinationAddress 
            : (selectedDeliveryType == DeliveryType.postamat ? selectedPostamat?.address : null),
        
        'postamatId': selectedDeliveryType == DeliveryType.postamat ? selectedPostamat?.id : null,
        'deliverySlotId': selectedDeliveryType == DeliveryType.courier ? selectedSlot?.id : null,
        'totalPrice': cartTotalPrice, 
        'positions': positions
      };
      
      Logger.i('Отправка заказа на сервер: $payload');
      
      final response = await _apiClient.postAsync(ApiEndpoints.createOrder, data: payload);
      
      if (response != null && response is int) {
        return response;
      } else if (response != null && response is Map<String, dynamic> && response['id'] != null) {
        return response['id'] as int;
      } else if (response != null && response is Map<String, dynamic> && response['orderId'] != null) {
        return response['orderId'] as int;
      }
      
      return null;
    }, fallback: null);
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