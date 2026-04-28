import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';

/// Варианты доставки для оформления заказа.
enum DeliveryType {
  pickup('Самовывоз'),
  express('Экспресс'),
  courier('Курьер'),
  postamat('В постамат');

  const DeliveryType(this.label);
  final String label;
}

/// Заглушка модели филиала.
class Branch {
  const Branch({
    required this.id,
    required this.city,
    required this.name,
  });

  final int id;
  final String city;
  final String name;

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'] as int,
      city: (json['city'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}

/// Заглушка модели товара в наличии.
class AvailableItem {
  const AvailableItem({
    required this.itemId,
    required this.name,
    required this.price,
    required this.availableQuantity,
  });

  final int itemId;
  final String name;
  final double price;
  final int availableQuantity;

  factory AvailableItem.fromJson(Map<String, dynamic> json) {
    return AvailableItem(
      itemId: json['itemId'] as int,
      name: (json['name'] ?? '').toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      availableQuantity: (json['availableQuantity'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Заглушка модели постамата.
class Postamat {
  const Postamat({
    required this.id,
    required this.address,
  });

  final int id;
  final String address;

  factory Postamat.fromJson(Map<String, dynamic> json) {
    return Postamat(
      id: json['id'] as int,
      address: (json['address'] ?? '').toString(),
    );
  }
}

class CreateOrderViewModel extends ChangeNotifier {
  CreateOrderViewModel(this._apiClient);

  final ApiClient _apiClient;

  bool isLoading = false;
  String? errorMessage;

  int currentStep = 0;

  final List<Branch> _branches = [];
  final List<AvailableItem> _availableItems = [];
  final List<Postamat> _postamats = [];

  Branch? selectedBranch;
  DeliveryType selectedDeliveryType = DeliveryType.pickup;
  Postamat? selectedPostamat;
  bool prepayNow = false;

  /// Корзина: itemId -> quantity.
  final Map<int, int> cart = <int, int>{};

  String itemSearchQuery = '';

  bool isCheckingPostamatCapacity = false;
  bool? postamatCapacityOk;
  String? postamatCapacityError;

  List<Branch> get branches => List.unmodifiable(_branches);
  List<AvailableItem> get availableItems => List.unmodifiable(_availableItems);
  List<Postamat> get postamats => List.unmodifiable(_postamats);

  List<String> get availableCities {
    final cities = _branches.map((b) => b.city.trim()).where((c) => c.isNotEmpty).toSet().toList();
    cities.sort();
    return cities;
  }

  List<Branch> branchesByCity(String city) {
    return _branches.where((b) => b.city.toLowerCase() == city.toLowerCase()).toList();
  }

  double get totalAmount {
    var total = 0.0;
    for (final item in _availableItems) {
      final qty = cart[item.itemId] ?? 0;
      if (qty > 0) {
        total += item.price * qty;
      }
    }
    return total;
  }

  Future<void> initialize() async {
    await Future.wait([loadBranches(), loadPostamats()]);
  }

  Future<void> loadBranches() async {
    await _withLoading(() async {
      final response = await _apiClient.getAsync(ApiEndpoints.getBranches);
      final rows = (response as List<dynamic>).cast<Map<String, dynamic>>();
      _branches
        ..clear()
        ..addAll(rows.map(Branch.fromJson));
    });
  }

  Future<void> loadAvailableItems() async {
    if (selectedBranch == null) return;
    await _withLoading(() async {
      final endpoint = ApiEndpoints.getAvailableItems(
        selectedBranch!.id,
        query: itemSearchQuery,
      );
      final response = await _apiClient.getAsync(endpoint);
      final rows = (response as List<dynamic>).cast<Map<String, dynamic>>();
      _availableItems
        ..clear()
        ..addAll(rows.map(AvailableItem.fromJson));

      // Если на сервере остатки изменились, синхронизируем корзину.
      final validIds = _availableItems.map((e) => e.itemId).toSet();
      cart.removeWhere((itemId, _) => !validIds.contains(itemId));
      for (final item in _availableItems) {
        final currentQty = cart[item.itemId] ?? 0;
        if (currentQty > item.availableQuantity) {
          cart[item.itemId] = item.availableQuantity;
        }
      }
      cart.removeWhere((_, qty) => qty <= 0);
    });
  }

  Future<void> loadPostamats() async {
    await _withLoading(() async {
      final response = await _apiClient.getAsync(ApiEndpoints.getPostamats);
      final rows = (response as List<dynamic>).cast<Map<String, dynamic>>();
      _postamats
        ..clear()
        ..addAll(rows.map(Postamat.fromJson));
    });
  }

  void setStep(int step) {
    currentStep = step.clamp(0, 3);
    notifyListeners();
  }

  Future<void> nextStep() async {
    if (currentStep == 1 && selectedBranch != null && _availableItems.isEmpty) {
      await loadAvailableItems();
    }
    if (currentStep < 3) {
      currentStep++;
      notifyListeners();
      if (currentStep == 3) {
        unawaited(runPostamatCapacityCheckIfNeeded());
      }
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      notifyListeners();
    }
  }

  void selectBranch(Branch? branch) {
    selectedBranch = branch;
    _availableItems.clear();
    cart.clear();
    notifyListeners();
    if (branch != null) {
      unawaited(loadAvailableItems());
    }
  }

  void setDeliveryType(DeliveryType type) {
    selectedDeliveryType = type;
    if (type != DeliveryType.postamat) {
      selectedPostamat = null;
      postamatCapacityOk = null;
      postamatCapacityError = null;
      isCheckingPostamatCapacity = false;
    }
    notifyListeners();
  }

  void setSelectedPostamat(Postamat? postamat) {
    selectedPostamat = postamat;
    postamatCapacityOk = null;
    postamatCapacityError = null;
    notifyListeners();
  }

  void setPrepayNow(bool value) {
    prepayNow = value;
    notifyListeners();
  }

  Future<void> applyItemSearch(String query) async {
    itemSearchQuery = query.trim();
    await loadAvailableItems();
  }

  Future<void> clearItemSearch() async {
    itemSearchQuery = '';
    await loadAvailableItems();
  }

  int quantityFor(int itemId) => cart[itemId] ?? 0;

  void addToCart(int itemId) {
    _setCartQuantity(itemId, 1);
  }

  void increaseQuantity(AvailableItem item) {
    final next = (cart[item.itemId] ?? 0) + 1;
    _setCartQuantity(item.itemId, next, max: item.availableQuantity);
  }

  void decreaseQuantity(AvailableItem item) {
    final next = (cart[item.itemId] ?? 0) - 1;
    _setCartQuantity(item.itemId, next, max: item.availableQuantity);
  }

  String? setQuantityFromInput(AvailableItem item, String rawValue) {
    final parsed = int.tryParse(rawValue);
    if (parsed == null) return 'Введите целое число';
    if (parsed < 0) return 'Количество не может быть < 0';
    if (parsed > item.availableQuantity) return 'Макс: ${item.availableQuantity}';
    _setCartQuantity(item.itemId, parsed, max: item.availableQuantity);
    return null;
  }

  void _setCartQuantity(int itemId, int value, {int? max}) {
    final safeMax = max ?? 1 << 31;
    final normalized = value.clamp(0, safeMax);
    if (normalized == 0) {
      cart.remove(itemId);
    } else {
      cart[itemId] = normalized;
    }
    notifyListeners();
  }

  Future<void> runPostamatCapacityCheckIfNeeded() async {
    if (selectedDeliveryType != DeliveryType.postamat) {
      postamatCapacityOk = true;
      postamatCapacityError = null;
      notifyListeners();
      return;
    }

    if (selectedPostamat == null) {
      postamatCapacityOk = false;
      postamatCapacityError = 'Выберите постамат на шаге логистики.';
      notifyListeners();
      return;
    }

    isCheckingPostamatCapacity = true;
    postamatCapacityOk = null;
    postamatCapacityError = null;
    notifyListeners();

    try {
      final payload = {
        'postamatId': selectedPostamat!.id,
        'items': cart.entries
            .map((e) => {'itemId': e.key, 'quantity': e.value})
            .toList(),
      };
      final response = await _apiClient.postAsync(ApiEndpoints.checkPostamatCapacity, data: payload);
      final ok = response is bool
          ? response
          : (response is Map<String, dynamic> ? (response['fits'] as bool? ?? false) : false);

      postamatCapacityOk = ok;
      postamatCapacityError = ok
          ? null
          : 'Габариты/объем заказа не подходят для выбранного постамата. Вернитесь назад и выберите курьера.';
    } catch (_) {
      postamatCapacityOk = false;
      postamatCapacityError = 'Не удалось проверить вместимость постамата. Попробуйте позже.';
    } finally {
      isCheckingPostamatCapacity = false;
      notifyListeners();
    }
  }

  bool get canSubmitOrder {
    if (cart.isEmpty || selectedBranch == null) return false;
    if (selectedDeliveryType == DeliveryType.postamat) {
      return selectedPostamat != null && postamatCapacityOk == true && !isCheckingPostamatCapacity;
    }
    return true;
  }

  Future<bool> createOrder() async {
    if (!canSubmitOrder) return false;

    return _withLoading<bool>(() async {
      final payload = {
        'branchId': selectedBranch!.id,
        'deliveryType': selectedDeliveryType.name,
        'postamatId': selectedPostamat?.id,
        'prepayNow': prepayNow,
        'items': cart.entries
            .map((e) => {'itemId': e.key, 'quantity': e.value})
            .toList(),
      };
      await _apiClient.postAsync(ApiEndpoints.createOrder, data: payload);
      return true;
    }, fallback: false);
  }

  Future<T> _withLoading<T>(Future<T> Function() action, {T? fallback}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await action();
      return result;
    } catch (e) {
      errorMessage = e.toString();
      if (fallback != null) return fallback;
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
