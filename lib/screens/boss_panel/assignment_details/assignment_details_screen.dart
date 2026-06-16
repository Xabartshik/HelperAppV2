import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/models/tasks/mobile_base_task_dto.dart';
import 'package:helper_app/core/tasks/task_registry.dart';
import 'package:helper_app/core/models/tasks/task_models.dart';
import 'package:helper_app/screens/boss_panel/boss_panel_viewmodel.dart';
import 'package:helper_app/screens/boss_panel/all_tasks/all_tasks_viewmodel.dart';
import 'assignment_details_viewmodel.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class AssignmentDetailsScreen extends ConsumerWidget {
  final int workerId;
  final int taskId;

  const AssignmentDetailsScreen({
    super.key,
    required this.workerId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assignmentDetailsViewModelProvider((workerId: workerId, taskId: taskId)));
    final bossState = ref.watch(bossPanelViewModelProvider);
    final allTasksState = ref.watch(allTasksViewModelProvider);

    // Вычисляем имя сотрудника по ID
    String? workerName;
    for (final emp in bossState.employeeWorkloads) {
      if (emp.employeeId == workerId) {
        workerName = emp.fullName;
        break;
      }
    }
    if (workerName == null) {
      for (final emp in allTasksState.branchEmployees) {
        if (emp.employeeId == workerId) {
          workerName = emp.fullName;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали назначения', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(state, workerName, context),
      backgroundColor: const Color(0xFF141414),
    );
  }

  Widget _buildBody(AssignmentDetailsState state, String? workerName, BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)));
    }
    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Ошибка: ${state.error}', style: const TextStyle(color: Colors.redAccent)),
          ],
        ),
      );
    }
    if (state.task == null) {
      return const Center(child: Text('Нет данных', style: TextStyle(color: Colors.white70)));
    }

    final task = state.task!;
    final adapter = TaskRegistry.resolveByTaskType(task.taskType);
    final parsedTask = adapter?.parseDetails(task, workerId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(task, workerName),
          const SizedBox(height: 24),
          if (parsedTask != null) _buildSpecificDetails(parsedTask) else _buildRawDetails(task),
        ],
      ),
    );
  }

  // Строит верхнюю общую карточку с информацией о назначении
  Widget _buildHeaderCard(MobileBaseTaskDto task, String? workerName) {
    final isHelper = task.taskDetails['role'] == 'Helper' || task.taskDetails['role'] == 1;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm:ss');
    
    final assignedAtStr = task.taskDetails['assignedAt']?.toString() ?? task.taskDetails['AssignedAt']?.toString();
    final startedAtStr = task.taskDetails['startedAt']?.toString() ?? task.taskDetails['StartedAt']?.toString();
    final completedAtStr = task.taskDetails['completedAt']?.toString() ?? task.taskDetails['CompletedAt']?.toString();

    final DateTime? assignedAt = assignedAtStr != null ? DateTime.tryParse(assignedAtStr) : null;
    final DateTime? startedAt = startedAtStr != null ? DateTime.tryParse(startedAtStr) : null;
    final DateTime? completedAt = completedAtStr != null ? DateTime.tryParse(completedAtStr) : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _translateTaskType(task.taskType),
                  style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const Spacer(),
              if (isHelper)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.handshake, size: 16, color: Colors.orangeAccent),
                      SizedBox(width: 4),
                      Text('Помощник', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(task.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 24),
          _buildInfoRow(Icons.person_outline, 'Исполнитель: ', workerName ?? 'ID $workerId'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time_outlined, 'Создана: ', task.createdAt != null ? dateFormat.format(task.createdAt!.toLocal()) : '-'),
          if (assignedAt != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.assignment_ind_outlined, 'Назначена: ', dateFormat.format(assignedAt.toLocal())),
          ],
          if (startedAt != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.play_circle_outline, 'Начата: ', dateFormat.format(startedAt.toLocal())),
          ],
          if (completedAt != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.check_circle_outline, 'Завершена: ', dateFormat.format(completedAt.toLocal())),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white54),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 15)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Маршрутизирует построение детальной информации на основе типа задачи
  Widget _buildSpecificDetails(TaskItemBase parsedTask) {
    if (parsedTask is OrderAssemblyTaskItem) {
      return _buildAssemblyDetails(parsedTask);
    } else if (parsedTask is OrderHandoverTaskItem) {
      return _buildHandoverDetails(parsedTask);
    } else if (parsedTask is InventoryTaskItem) {
      return _buildInventoryDetails(parsedTask);
    } else if (parsedTask is ReturnToStockTaskItem) {
      return _buildReturnDetails(parsedTask);
    }
    return const SizedBox.shrink();
  }

  // Строит UI детального состава задачи сборки
  Widget _buildAssemblyDetails(OrderAssemblyTaskItem task) {
    int linesCount = task.cellPlacements.fold(0, (sum, cell) => sum + cell.items.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Позиции сборки', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Прогресс сборки', style: TextStyle(color: Colors.white70)),
                  Text('${task.completedLinesCount} / $linesCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: linesCount > 0 ? task.completedLinesCount / linesCount : 0,
                backgroundColor: const Color(0xFF141414),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                borderRadius: BorderRadius.circular(8),
                minHeight: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...task.cellPlacements.map((cell) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_basket_outlined, color: Color(0xFF7C3AED), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Целевая ячейка: ${cell.cellDisplayName ?? cell.cellCode ?? cell.targetPositionId}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, height: 20),
              ...cell.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemName ?? 'Товар ${item.itemId ?? item.itemPositionId}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ШК: ${item.barcode ?? "-"} | Из ячейки: ${item.sourceCellCode ?? "-"}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        Text(
                          'Собрано: ${item.pickedQuantity ?? 0} / ${item.quantity} шт.',
                          style: TextStyle(
                            color: item.status == 'placed' || item.status == 'picked' ? Colors.greenAccent : Colors.orangeAccent,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ],
          ),
        )),
      ],
    );
  }

  // Строит UI деталей выдачи заказа
  Widget _buildHandoverDetails(OrderHandoverTaskItem task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Детали выдачи', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: task.lines.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, color: Color(0xFF7C3AED), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.itemName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ШК: ${l.barcode} | Ячейка: ${l.sourceCellCode}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Text(
                        'Выдано: ${l.scannedQuantity} / ${l.quantity} шт.',
                        style: TextStyle(
                          color: l.scannedQuantity >= l.quantity ? Colors.greenAccent : Colors.orangeAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  // Строит UI деталей инвентаризации
  Widget _buildInventoryDetails(InventoryTaskItem task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Линии инвентаризации', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...task.lines.map((l) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.itemName ?? 'Товар ${l.itemId ?? l.itemPositionId}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ячейка: ${l.positionCode?.shortDescription ?? "-"}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  Text(
                    'Факт: ${l.actualQuantity ?? "Не введено"} / Ожидалось: ${l.expectedQuantity} шт.',
                    style: TextStyle(
                      color: l.actualQuantity == null 
                          ? Colors.orangeAccent 
                          : (l.actualQuantity == l.expectedQuantity ? Colors.greenAccent : Colors.redAccent),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  // Строит UI деталей возврата товаров на полки
  Widget _buildReturnDetails(ReturnToStockTaskItem task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Позиции возврата', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: task.lines.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.keyboard_return_outlined, color: Color(0xFF7C3AED), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.itemName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'ШК: ${l.barcode}\nИз: ${l.sourceCellCode} → В: ${l.targetCellCode}',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      Text(
                        'Размещено: ${l.scannedQuantity} / ${l.quantity} шт.',
                        style: TextStyle(
                          color: l.scannedQuantity >= l.quantity ? Colors.greenAccent : Colors.orangeAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  // Отображает сырые JSON данные, если парсинг деталей недоступен
  Widget _buildRawDetails(MobileBaseTaskDto task) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Детали (JSON)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Text(
            const JsonEncoder.withIndent('  ').convert(task.taskDetails),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70),
          ),
        ),
      ],
    );
  }

  String _translateTaskType(String type) {
    switch (type) {
      case 'OrderAssembly': return 'Сборка заказа';
      case 'OrderHandover': return 'Выдача заказа';
      case 'ReturnToStock': return 'Возврат на полку';
      case 'Inventory': return 'Инвентаризация';
      default: return type;
    }
  }
}
