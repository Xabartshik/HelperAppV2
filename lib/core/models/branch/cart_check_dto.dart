import 'branch_dto.dart';

/// Элемент корзины в запросе.
class CartItemDto {
  final int itemId;
  final int requiredQuantity;

  CartItemDto({
    required this.itemId,
    required this.requiredQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'requiredQuantity': requiredQuantity,
    };
  }
}

/// Запрос проверки корзины.
class CartCheckRequestDto {
  final List<CartItemDto> items;

  CartCheckRequestDto({
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

/// Недостающий товар.
class MissingItemDto {
  final int itemId;
  final int requiredQuantity;
  final int availableQuantity;

  MissingItemDto({
    required this.itemId,
    required this.requiredQuantity,
    required this.availableQuantity,
  });

  factory MissingItemDto.fromJson(Map<String, dynamic> json) {
    return MissingItemDto(
      itemId: json['itemId'] as int? ?? 0,
      requiredQuantity: json['requiredQuantity'] as int? ?? 0,
      availableQuantity: json['availableQuantity'] as int? ?? 0,
    );
  }
}

/// Информация о частичном наличии в филиале.
class BranchAvailabilityDto {
  final BranchDto branch;
  final List<MissingItemDto> missingItems;

  BranchAvailabilityDto({
    required this.branch,
    required this.missingItems,
  });

  factory BranchAvailabilityDto.fromJson(Map<String, dynamic> json) {
    return BranchAvailabilityDto(
      branch: BranchDto.fromJson(json['branch'] as Map<String, dynamic>),
      missingItems: (json['missingItems'] as List? ?? [])
          .map((i) => MissingItemDto.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Ответ с результатами проверки наличия.
class BranchAvailabilityResponseDto {
  final List<BranchDto> availableBranches;
  final List<BranchAvailabilityDto> partiallyAvailableBranches;

  BranchAvailabilityResponseDto({
    required this.availableBranches,
    required this.partiallyAvailableBranches,
  });

  factory BranchAvailabilityResponseDto.fromJson(Map<String, dynamic> json) {
    return BranchAvailabilityResponseDto(
      availableBranches: (json['availableBranches'] as List? ?? [])
          .map((b) => BranchDto.fromJson(b as Map<String, dynamic>))
          .toList(),
      partiallyAvailableBranches: (json['partiallyAvailableBranches'] as List? ?? [])
          .map((pb) => BranchAvailabilityDto.fromJson(pb as Map<String, dynamic>))
          .toList(),
    );
  }
}
