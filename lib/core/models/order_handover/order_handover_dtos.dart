class HandoverTaskDetailsDto {
  final int assignmentId;
  final int taskId;
  final String taskNumber;
  final int orderId;
  final String handoverType; 
  final String targetName; 
  final int status;
  final bool isCooperative;
  final String? partnerName;
  final int? partnerStatus;
  final List<HandoverItemDto> itemsToScan;

  HandoverTaskDetailsDto({
    required this.assignmentId,
    required this.taskId,
    required this.taskNumber,
    required this.orderId,
    required this.handoverType,
    required this.targetName,
    required this.status,
    required this.isCooperative,
    this.partnerName,
    this.partnerStatus,
    required this.itemsToScan,
  });

  factory HandoverTaskDetailsDto.fromJson(Map<String, dynamic> json) {
    return HandoverTaskDetailsDto(
      assignmentId: json['assignmentId'] ?? 0,
      taskId: json['taskId'] ?? 0,
      taskNumber: json['taskNumber'] ?? '',
      orderId: json['orderId'] ?? 0,
      handoverType: json['handoverType'] ?? '',
      targetName: json['targetName'] ?? 'Неизвестно',
      status: json['status'] ?? 0,
      isCooperative: json['isCooperative'] ?? false,
      partnerName: json['partnerName'],
      partnerStatus: json['partnerStatus'], // <-- И ЗДЕСЬ
      itemsToScan: (json['itemsToScan'] as List?)
              ?.map((e) => HandoverItemDto.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HandoverItemDto {
  final int lineId;
  final int itemId;
  final String itemName;
  final String barcode;
  final String sourceCellCode;
  final int quantity;
  final int scannedQuantity;

  HandoverItemDto({
    required this.lineId,
    required this.itemId,
    required this.itemName,
    required this.barcode,
    required this.sourceCellCode,
    required this.quantity,
    required this.scannedQuantity,
  });

  factory HandoverItemDto.fromJson(Map<String, dynamic> json) {
    return HandoverItemDto(
      lineId: json['lineId'] ?? 0,
      itemId: json['itemId'] ?? 0,
      itemName: json['itemName'] ?? '',
      barcode: json['barcode'] ?? '',
      sourceCellCode: json['sourceCellCode'] ?? '',
      quantity: json['quantity'] ?? 0,
      scannedQuantity: json['scannedQuantity'] ?? 0,
    );
  }
}