import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../home/main_viewmodel.dart'; // Проверьте путь

class BreakControlWidget extends ConsumerStatefulWidget {
  const BreakControlWidget({super.key});

  @override
  ConsumerState<BreakControlWidget> createState() => _BreakControlWidgetState();
}

class _BreakControlWidgetState extends ConsumerState<BreakControlWidget> {
  Timer? _localTimer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _localTimer?.cancel();
    super.dispose();
  }

  void _startLocalTimer(int totalMinutes) {
    if (_isTimerRunning) return;

    _secondsRemaining = totalMinutes * 60;
    _isTimerRunning = true;

    _localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          // Время вышло. Можно остановить таймер.
          // Если сотрудник не нажал кнопку сам, таймер просто остановится на нуле.
          timer.cancel();
          _isTimerRunning = false;
        }
      });
    });
  }

  void _stopLocalTimer() {
    _localTimer?.cancel();
    _isTimerRunning = false;
    _secondsRemaining = 0;
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainViewModelProvider);
    final notifier = ref.read(mainViewModelProvider.notifier);
    final status = state.breakStatus;

    if (status == null) {
      return const SizedBox(
        height: 36,
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 24, width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    // Лимиты и накопленное время[cite: 3]
    final int currentMins = status.accumulatedMinutes;
    final int requiredMins = notifier.maxBreakMinutes;
    final double progress = (currentMins / requiredMins).clamp(0.0, 1.0);
    final int displayMins = currentMins > requiredMins ? requiredMins : currentMins;

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );

    Widget leftContent;
    Widget rightContent;

    // СОСТОЯНИЕ 1: На перерыве
    if (status.isOnBreak) {
      // Запускаем таймер, если он еще не запущен
      if (!_isTimerRunning) {
        _startLocalTimer(notifier.breakDurationMinutes);
      }

      final isOvertime = _secondsRemaining == 0;
      final timeColor = isOvertime ? Colors.redAccent : Colors.orangeAccent;
      final timeText = isOvertime ? 'ВРЕМЯ ВЫШЛО!' : _formatTime(_secondsRemaining);

      leftContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, color: timeColor, size: 18),
          const SizedBox(width: 8),
          Text(
            timeText,
            style: TextStyle(color: timeColor, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      );

      rightContent = ElevatedButton.icon(
        onPressed: state.isBusy
            ? null
            : () {
                _stopLocalTimer(); // Останавливаем локальный таймер
                notifier.toggleBreak(); // Отправляем запрос на сервер[cite: 2]
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          shape: buttonShape,
        ),
        icon: const Icon(Icons.work, size: 18),
        label: const Text('К работе', style: TextStyle(fontSize: 13)),
      );
    } 
    // СОСТОЯНИЕ 2: Перерыв доступен
    else if (status.canStartBreak) {
      _stopLocalTimer(); // Очищаем таймер, если мы вернулись к работе (защита)

      leftContent = Text(
        'Доступен перерыв ($displayMins/$requiredMins мин)',
        style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
      );

      rightContent = ElevatedButton.icon(
        onPressed: state.isBusy ? null : () => notifier.toggleBreak(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          shape: buttonShape,
        ),
        icon: const Icon(Icons.coffee, size: 18),
        label: const Text('Перерыв', style: TextStyle(fontSize: 13)),
      );
    } 
    // СОСТОЯНИЕ 3: Перерыв недоступен
    else {
      _stopLocalTimer(); // Очищаем таймер (защита)

      String message = 'Недоступно';
      IconData icon = Icons.timer_outlined;
      Color contentColor = Colors.white70;

      if (status.hasActiveTasks) {
        message = 'Завершите задачи';
        icon = Icons.lock_outline;
        contentColor = Colors.orangeAccent;
      } else if (status.isLimitReached) {
        message = 'Лимит (ждите)';
        icon = Icons.people_outline;
        contentColor = Colors.redAccent;
      } else {
        message = 'Накопление...';
      }

      leftContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16, width: 16,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 2,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              color: const Color(0xFF7C3AED),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Накоплено: $displayMins/$requiredMins мин',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      );

      rightContent = Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: contentColor),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(color: contentColor, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: leftContent),
        const SizedBox(width: 12),
        rightContent,
      ],
    );
  }
}