import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:helper_app/core/models/user/current_user.dart';
import 'package:helper_app/core/models/user/mobile_app_user_dto.dart';
import 'package:helper_app/core/models/user/worker_role.dart';
import 'package:helper_app/core/network/api_client.dart';
import 'main_viewmodel.dart';
import '../../core/services/auth_service.dart';
import '../../core/models/tasks/task_card_vm.dart';
import '../../core/models/tasks/task_models.dart';
import '../../core/services/signalr_service.dart'; 
import '../../core/services/notification_service.dart';
import '../../core/tasks/task_navigation_dispatcher.dart';
import '../../screens/widgets/break_control_widget.dart';
import '../../screens/widgets/pool_summary_widget.dart'; // ДОБАВЛЕН ИМПОРТ ВИДЖЕТА ПУЛА

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  static const Color _bgGray900 = Color(0xFF2C2C2E);
  static const Color _primaryColor = Color(0xFF7C3AED);

  final SignalRService _signalRService = SignalRService();
  final TaskNavigationDispatcher _taskNavigationDispatcher = const TaskNavigationDispatcher();
  int? _connectedEmployeeId;

  @override
  void initState() {
    super.initState();
    LocalNotificationService.init();
    _setupSignalR();
  }

  void _setupSignalR() async {
    _signalRService.onNotificationReceived = (title, message, type) {
      if (type == 'priority_escalated_1') {
        ref.read(mainViewModelProvider.notifier).refreshTasks();
        return; 
      }

      LocalNotificationService.showNotification(title, message, type);

      if (type == 'high_priority' || type == 'helper_required' || type == 'priority_escalated_3') {
        _showCriticalTaskOverlay(context, title, message, type);
      } 
      else {
        _showNotificationSnackbar(title, message, type);
      }
      
      ref.read(mainViewModelProvider.notifier).refreshTasks(); 
    };

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null && currentUser.employeeId != null) {
        _connectedEmployeeId = currentUser.employeeId;
        
        final String rawBaseUrl = await ref.read(apiClientProvider).getBaseUrlAsync();
        final String serverUrl = rawBaseUrl.replaceAll(RegExp(r'/api/?$'), '');
        
        await _signalRService.initConnection(_connectedEmployeeId!, serverUrl);
      }
    });
  }

  @override
  void dispose() {
    if (_connectedEmployeeId != null) {
      _signalRService.stopConnection(_connectedEmployeeId!);
    }
    super.dispose();
  }

  void _showNotificationSnackbar(String title, String message, String type) {
    Color bgColor = Colors.blue.shade700;
    IconData icon = Icons.info;

    if (type == 'new_task') {
      bgColor = Colors.green.shade700;
      icon = Icons.add_task;
    } else if (type == 'priority_escalated_2') {
      bgColor = Colors.orange.shade700;
      icon = Icons.trending_up;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(message, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCriticalTaskOverlay(BuildContext context, String title, String message, String type) {
    final isHelper = type == 'helper_required';
    final bgColor = isHelper ? Colors.orange.shade900 : Colors.red.shade900;
    final icon = isHelper ? Icons.handshake : Icons.warning_amber_rounded;
    
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false, 
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _bgGray900,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: bgColor, width: 3),
                boxShadow: [
                  BoxShadow(color: bgColor.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Icon(icon, color: bgColor, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bgColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text('ПРИНЯТО К ИСПОЛНЕНИЮ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onScanCustomerQrPressed(BuildContext context, WidgetRef ref) async {
    final String? scannedQr = await context.push<String>('/customer-qr-scanner');
    
    if (scannedQr == null || scannedQr.isEmpty) return;

    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator(color: _primaryColor)),
    );

    try {
      final currentUser = ref.read(currentUserProvider);
      final apiClient = ref.read(apiClientProvider);

      if (currentUser?.employeeId == null || currentUser?.branchId == null) {
        throw Exception("Данные сотрудника не найдены");
      }

      final newTaskId = await apiClient.initCustomerHandoverAsync(
        scannedQr,
        currentUser!.employeeId!,
        currentUser.branchId!,
        0,
      );

      if (context.mounted) Navigator.pop(context);

      if (newTaskId != null && context.mounted) {
        ref.read(mainViewModelProvider.notifier).refreshTasks(isSilent: true);
        
        context.push('/order-handover/active', extra: {
          'taskId': newTaskId,
          'assignmentId': 0, 
          'taskStatusIndex': TaskStatus.assigned.index, 
          'assignmentStatusIndex': AssignmentStatus.assigned.index,
        });
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('ApiException: ', '')),
            backgroundColor: Colors.redAccent.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainViewModelProvider);
    final viewModel = ref.read(mainViewModelProvider.notifier);
    final currentUser = ref.watch(currentUserProvider);

    final isBoss = currentUser?.role == MobileUserRole.admin ||
        currentUser?.role == MobileUserRole.supervisor;

    final bool isOnBreak = state.breakStatus?.isOnBreak == true;

    return Scaffold(
      backgroundColor: _bgOffBlack,
      floatingActionButton: (state.isActiveShift && !isOnBreak && !isBoss)
          ? FloatingActionButton.extended(
              onPressed: () => _onScanCustomerQrPressed(context, ref),
              backgroundColor: _primaryColor,
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              label: const Text(
                'ВЫДАТЬ ЗАКАЗ', 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, currentUser, isBoss, viewModel),
            if (!state.hasNetwork) _buildNetworkWarning(),
            _buildShiftBanner(context, state, viewModel),
            _buildTasksToolbar(state, viewModel, isOnBreak), // Передаем isOnBreak[cite: 4]
            if (state.errorMessage.isNotEmpty) _buildErrorText(state.errorMessage),
            
            Expanded(
              child: IgnorePointer(
                ignoring: !state.isActiveShift || isOnBreak,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: (state.isActiveShift && !isOnBreak) ? 1.0 : 0.3,
                  child: _buildTaskListContent(state),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskListContent(MainState state) {
    if (state.breakStatus?.isOnBreak == true) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.coffee, size: 64, color: Colors.orangeAccent),
            SizedBox(height: 16),
            Text(
              'Вы на перерыве',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Задачи временно скрыты',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (state.taskCards.isEmpty && !state.isBusy) {
      return const Center(
        child: Text(
          'Задач не найдено',
          style: TextStyle(color: Color(0xFFA1A1AA), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.taskCards.length,
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemBuilder: (context, index) =>
          _buildTaskCard(context, ref, state.taskCards[index]),
    );
  }

  Widget _buildHeader(BuildContext context, CurrentUser? user, bool isBoss, MainViewModel vm) {
    final initials = (user?.fullName?.isNotEmpty == true) 
        ? user!.fullName![0].toUpperCase() 
        : '?';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: _bgGray950,
        border: Border(bottom: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _primaryColor.withValues(alpha: 0.2),
            foregroundColor: _primaryColor,
            radius: 22,
            child: Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.fullName ?? 'Пользователь',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.workerRole?.displayName ?? 'Не указана',
                  style: const TextStyle(fontSize: 13, color: Colors.white54),
                ),
              ],
            ),
          ),
          if (isBoss)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: _primaryColor),
              tooltip: 'Панель руководителя',
              onPressed: () => context.push('/boss-panel'),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFF6B6B), size: 22),
            tooltip: 'Выйти',
            onPressed: () => vm.logout(),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBanner(BuildContext context, MainState state, MainViewModel vm) {
    if (state.isShiftLoading) {
      return Container(
        height: 90,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(color: _primaryColor),
      );
    }

    final isWorking = state.isActiveShift;
    
    final gradient = isWorking
        ? LinearGradient(colors: [Colors.teal.shade800, Colors.teal.shade900])
        : LinearGradient(colors: [const Color(0xFF5B21B6), const Color(0xFF4C1D95)]); 

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isWorking ? Colors.teal : _primaryColor).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isWorking ? Icons.how_to_reg : Icons.qr_code_scanner, 
              color: Colors.white, size: 28
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isWorking ? 'Вы на смене' : 'Смена не начата',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isWorking ? 'Хорошей работы и будьте внимательны.' : 'Отсканируйте QR на проходной для старта.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              final qrResult = await context.push<String>('/shift-scanner');
              
              if (qrResult != null && qrResult.isNotEmpty) {
                final checkType = isWorking ? 'out' : 'in';
                await vm.processQrCheckIn(qrResult, checkType);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isWorking ? Colors.redAccent : Colors.white,
              foregroundColor: isWorking ? Colors.white : _primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              isWorking ? 'Сдать смену' : 'Начать работу',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTasksToolbar(MainState state, MainViewModel viewModel, bool isOnBreak) {
    return Container(
      color: _bgGray950,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.isActiveShift) ...[
            const BreakControlWidget(), 
            const SizedBox(height: 16),
          ],

          // ДОБАВЛЯЕМ PoolSummaryWidget (если на смене и не на перерыве)
          if (state.isActiveShift && !isOnBreak) ...[
            const PoolSummaryWidget(),
            const SizedBox(height: 8),
          ],
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Мои задачи',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (state.isBusy)
                const SizedBox(
                  width: 20, height: 20, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: _primaryColor)
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70),
                  onPressed: state.isActiveShift ? () => viewModel.refreshTasks() : null,
                  tooltip: 'Обновить задачи',
                ),
            ],
          ),
          const SizedBox(height: 5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _sortChip(
                  label: 'По приоритету',
                  selected: state.sortMode == TaskSortMode.byPriority,
                  onTap: () => viewModel.setSortMode(TaskSortMode.byPriority),
                ),
                const SizedBox(width: 8),
                _sortChip(
                  label: 'По дедлайну',
                  selected: state.sortMode == TaskSortMode.byDeadline,
                  onTap: () => viewModel.setSortMode(TaskSortMode.byDeadline),
                ),
                const SizedBox(width: 8),
                _sortChip(
                  label: 'По типу',
                  selected: state.sortMode == TaskSortMode.byType,
                  onTap: () => viewModel.setSortMode(TaskSortMode.byType),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortChip({required String label, required bool selected, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _primaryColor.withValues(alpha: 0.2) : _bgGray900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _primaryColor : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _primaryColor : Colors.white70,
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNetworkWarning() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color(0xFFFF6B6B),
      child: const Text(
        '⚠️ Нет подключения к сети',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(text, style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13), textAlign: TextAlign.center),
    );
  }

  Widget _buildTaskCard(BuildContext context, WidgetRef ref, TaskCardVm task) {
    final type = (task.rawTask?.type != null) ? taskTypeToRussian(task.rawTask!.type) : task.kind;
    final borderColor = _priorityBorderColor(task.priority);
    final deadlineInfo = _deadlineInfo(task.deadline, task.status);

    return GestureDetector(
      onTap: () async {
        final currentUser = ref.read(currentUserProvider);
        final navigated = await _taskNavigationDispatcher.navigate(
          context,
          task,
          currentUser?.employeeId ?? 0,
        );

        if (!navigated && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не реализована навигация для типа задачи: $type')),
          );
        }

        if (context.mounted) {
          ref.read(mainViewModelProvider.notifier).refreshTasks();
        }
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _bgGray900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _bgGray950,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(type, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, height: 1.25),
            ),
            if (task.subtitle != null && task.subtitle!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(task.subtitle!, style: const TextStyle(fontSize: 13, color: Color(0xFFA1A1AA), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _metric(label: 'Статус', value: task.statusText, valueColor: _statusColor(task.status))),
                Expanded(child: _metric(label: 'Приоритет', value: '${task.priority}', valueColor: borderColor)),
                Expanded(child: _metric(label: 'Прогресс', value: '${task.completedSteps}/${task.totalSteps}', valueColor: Colors.white)),
              ],
            ),
            if (deadlineInfo != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: deadlineInfo.$2.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: deadlineInfo.$2.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined, color: deadlineInfo.$2, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        deadlineInfo.$1,
                        style: TextStyle(color: deadlineInfo.$2, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metric({required String label, required String value, required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
      ],
    );
  }

  (String, Color)? _deadlineInfo(DateTime? deadlineUtc, TaskStatus status) {
    if (deadlineUtc == null) return null;
    final now = DateTime.now().toLocal();
    final left = deadlineUtc.difference(now);
    final dateText = _formatDate(deadlineUtc);

    if (status == TaskStatus.completed) {
      return ('Дедлайн: $dateText', Colors.white70);
    }
    if (left.isNegative) {
      return ('ПРОСРОЧЕНО • до $dateText', Colors.redAccent);
    }
    if (left.inHours < 6) {
      return ('СРОЧНО • осталось ${left.inHours} ч ${left.inMinutes.remainder(60)} мин', Colors.orangeAccent);
    }
    if (left.inHours < 24) {
      return ('Сегодня дедлайн • до $dateText', const Color(0xFFF59E0B));
    }
    return ('Дедлайн: $dateText', Colors.white70);
  }

  Color _priorityBorderColor(int priority) {
    switch (priority) {
      case 3: return Colors.redAccent;
      case 2: return const Color(0xFFF59E0B);
      case 1: return const Color(0xFF22C55E);
      default: return const Color(0xFFA1A1AA);
    }
  }

  Color _statusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.completed: return const Color(0xFF22C55E);
      case TaskStatus.paused: return const Color(0xFFF59E0B);
      case TaskStatus.cancelled:
      case TaskStatus.blocked: return Colors.redAccent;
      default: return _primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}.${local.month.toString().padLeft(2, '0')} ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}