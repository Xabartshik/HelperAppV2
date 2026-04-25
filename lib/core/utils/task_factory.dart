import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/core/models/inventory/inventory_dtos.dart';
import 'package:helper_app/core/utils/logger.dart';

/// Фабрика для создания объектов задач из JSON, приходящего от агрегатора WorkerTasks.
/// Реализует принцип Open/Closed (SOLID): новые типы задач добавляются здесь,
/// не затрагивая основной сервис задач.
class TaskFactory {
  
  /// Основной входной метод для создания задачи любого типа.
  static TaskItemBase? createFromJson(Map<String, dynamic> json, int employeeId) {
    final rawType = (json['taskType'] as String?)?.toLowerCase().trim() ?? '';
    
    try {
      if (rawType == 'inventory' || rawType == 'инвентаризация') {
        return _parseInventoryTask(json, employeeId);
      } 
      
      if (rawType == 'orderassembly' || rawType == 'сборка заказа' || rawType == 'сборка') {
        return _parseOrderAssemblyTask(json, employeeId);
      }

      Logger.w('TaskFactory: Получен неизвестный тип задачи от сервера: "$rawType"');
      return null;
    } catch (e, stack) {
      Logger.e('TaskFactory: Ошибка при парсинге задачи типа "$rawType"', e, stack);
      return null;
    }
  }

  // --- Приватные методы парсинга конкретных типов задач ---

  static InventoryTaskItem _parseInventoryTask(Map<String, dynamic> json, int employeeId) {
    // Выделяем детали (TaskDetails), которые backend упаковал в объект
    final details = json['taskDetails'] as Map<String, dynamic>? ?? {};
    final linesJson = details['lines'] as List<dynamic>? ?? [];
    
    // Маппим список строк инвентаризации
    final lines = linesJson
        .map((l) => InventoryAssignmentLineWithItemDto.fromJson(l as Map<String, dynamic>))
        .map(_mapToInventoryLineItem)
        .toList();

    return InventoryTaskItem(
      taskId: json['taskId'] ?? 0,
      type: TaskType.inventory,
      branchId: json['branchId'] ?? 0,
      title: json['title'] ?? 'Инвентаризация',
      description: json['description'] ?? '',
      status: _mapStatus(json['status']),
      priority: json['priority'] ?? 5,
      createdAt: _parseDate(json['createdAt']),
      completedAt: null,
      assignedToEmployeeId: employeeId,
      assignedAt: _parseDate(json['createdAt']),
      assignmentId: details['assignmentId'] ?? json['taskId'],
      lines: lines,
    );
  }

  static OrderAssemblyTaskItem _parseOrderAssemblyTask(Map<String, dynamic> json, int employeeId) {
    final details = json['taskDetails'] as Map<String, dynamic>? ?? {};
    
    // Парсим информацию о размещении по ячейкам (Cell Placements)
    final placementsJson = details['cellPlacements'] as List<dynamic>? ?? [];
    final cellPlacements = placementsJson.map((cp) {
      final cpMap = cp as Map<String, dynamic>;
      final itemsJson = cpMap['items'] as List<dynamic>? ?? [];
      
      return CellPlacementInfo(
        targetPositionId: cpMap['targetPositionId'] ?? 0,
        items: itemsJson.map((i) {
          final iMap = i as Map<String, dynamic>;
          return PlacementLineInfo(
            lineId: iMap['lineId'] ?? 0,
            itemPositionId: iMap['itemPositionId'] ?? 0,
            quantity: (iMap['quantity'] as num?)?.toInt() ?? 0,
            status: iMap['status'] ?? 'pending',
          );
        }).toList(),
      );
    }).toList();

    return OrderAssemblyTaskItem(
      taskId: json['taskId'] ?? 0,
      type: TaskType.orderAssembly,
      branchId: json['branchId'] ?? 0,
      title: json['title'] ?? 'Сборка заказа',
      description: json['description'] ?? '',
      status: _mapStatus(json['status']),
      priority: json['priority'] ?? 5,
      createdAt: _parseDate(json['createdAt']),
      assignedToEmployeeId: employeeId,
      assignedAt: _parseDate(json['createdAt']),
      assignmentId: details['assignmentId'] ?? json['taskId'],
      orderId: details['orderId'] ?? 0,
      totalLines: details['totalLines'] ?? 0,
      cellPlacements: cellPlacements,
    );
  }

  // Вспомогательные мапперы

static InventoryLineItem _mapToInventoryLineItem(InventoryAssignmentLineWithItemDto dto) {
    return InventoryLineItem(
      lineId: dto.id, // Маппим id из DTO в lineId модели
      itemPositionId: dto.itemPositionId,
      expectedQuantity: dto.expectedQuantity,
      actualQuantity: dto.actualQuantity,
      // Преобразуем DTO код позиции в доменную модель PositionCodeInfo
      positionCode: PositionCodeInfo(
        branchId: dto.positionCode.branchId,
        zoneCode: dto.positionCode.zoneCode,
        firstLevelStorageType: dto.positionCode.firstLevelStorageType,
        flsNumber: dto.positionCode.fLSNumber, // Обратите внимание на регистр (fLSNumber)
        secondLevelStorage: dto.positionCode.secondLevelStorage,
        thirdLevelStorage: dto.positionCode.thirdLevelStorage,
      ),
    );
  }

static TaskStatus _mapStatus(dynamic status) {
    if (status == null) return TaskStatus.newStatus;
    final s = status.toString().toLowerCase();
    if (s == '1' || s == 'inprogress' || s == 'в работе') return TaskStatus.inProgress;
    if (s == '2' || s == 'completed' || s == 'завершено') return TaskStatus.completed;
    return TaskStatus.newStatus;
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    if (dateValue is String) {
      return DateTime.tryParse(dateValue) ?? DateTime.now();
    }
    return DateTime.now();
  }
}