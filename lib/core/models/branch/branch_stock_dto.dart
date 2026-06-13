/// Модель остатка товара в конкретном филиале.
class BranchStockDto {
  final int branchId;
  final String branchName;
  final String address;
  final int availableQuantity;

  BranchStockDto({
    required this.branchId,
    required this.branchName,
    required this.address,
    required this.availableQuantity,
  });

  factory BranchStockDto.fromJson(Map<String, dynamic> json) {
    return BranchStockDto(
      branchId: json['branchId'] as int? ?? 0,
      branchName: json['branchName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      availableQuantity: json['availableQuantity'] as int? ?? 0,
    );
  }
}
