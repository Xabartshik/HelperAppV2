class ReturnTaskDetailsDto {
  final int assignmentId;
  final int taskId;
  final String taskNumber;
  final int status;
  final String role;
  final bool isCooperative;
  final String? partnerName;
  final int? partnerStatus;
  final List<ReturnItemDto> itemsToScan;

  ReturnTaskDetailsDto({
    required this.assignmentId,
    required this.taskId,
    required this.taskNumber,
    required this.status,
    required this.role,
    required this.isCooperative,
    this.partnerName,
    this.partnerStatus,
    required this.itemsToScan,
  });

factory ReturnTaskDetailsDto.fromJson(Map<String, dynamic> json) {
    // Безопасно извлекаем сырой список
    final List<dynamic>? rawItems = (json['itemsToScan'] ?? json['ItemsToScan']) as List<dynamic>?;

    return ReturnTaskDetailsDto(
      assignmentId: json['assignmentId'] ?? json['AssignmentId'] ?? 0,
      taskId: json['taskId'] ?? json['TaskId'] ?? 0,
      taskNumber: json['taskNumber'] ?? json['TaskNumber'] ?? '',
      status: json['status'] ?? json['Status'] ?? 0,
      role: json['role'] ?? json['Role'] ?? 'Main',
      isCooperative: json['isCooperative'] ?? json['IsCooperative'] ?? false,
      partnerName: json['partnerName'] ?? json['PartnerName'],
      partnerStatus: json['partnerStatus'] ?? json['PartnerStatus'],
      // ИСПРАВЛЕНИЕ: Добавляем .cast<ReturnItemDto>() и указываем тип пустого списка <ReturnItemDto>[]
      itemsToScan: rawItems
              ?.map((e) => ReturnItemDto.fromJson(e as Map<String, dynamic>))
              .toList()
              .cast<ReturnItemDto>() ?? <ReturnItemDto>[],
    );
  }
}

class ReturnItemDto {
  final int lineId;
  final int itemId;
  final String itemName;
  final String barcode;
  final String sourceCellCode;
  final String targetCellCode;
  final int quantity;
  final int scannedQuantity;

  ReturnItemDto({
    required this.lineId,
    required this.itemId,
    required this.itemName,
    required this.barcode,
    required this.sourceCellCode,
    required this.targetCellCode,
    required this.quantity,
    required this.scannedQuantity,
  });

factory ReturnItemDto.fromJson(Map<String, dynamic> json) {
    return ReturnItemDto(
      lineId: json['lineId'] ?? json['LineId'] ?? 0,
      itemId: json['itemId'] ?? json['ItemId'] ?? 0,
      itemName: json['itemName'] ?? json['ItemName'] ?? '',
      barcode: json['barcode'] ?? json['Barcode'] ?? '',
      sourceCellCode: json['sourceCellCode'] ?? json['SourceCellCode'] ?? '',
      targetCellCode: json['targetCellCode'] ?? json['TargetCellCode'] ?? 'Определить на месте',
      quantity: json['quantity'] ?? json['Quantity'] ?? 0,
      scannedQuantity: json['scannedQuantity'] ?? json['ScannedQuantity'] ?? 0,
    );
  }
}