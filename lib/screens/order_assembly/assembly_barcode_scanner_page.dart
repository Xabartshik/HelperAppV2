import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'order_assembly_viewmodel.dart';
import '../../core/utils/logger.dart';

/// Экран сканирования для модуля сборки заказов.
/// Адаптирован из механизма инвентаризации, поддерживает режимы Сбора и Размещения.
class AssemblyBarcodeScannerPage extends ConsumerStatefulWidget {
  final int assignmentId;
  final int userId;

  const AssemblyBarcodeScannerPage({
    super.key,
    required this.assignmentId,
    required this.userId,
  });

  @override
  ConsumerState<AssemblyBarcodeScannerPage> createState() => _AssemblyBarcodeScannerPageState();
}

class _AssemblyBarcodeScannerPageState extends ConsumerState<AssemblyBarcodeScannerPage> {
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _primaryColor = const Color(0xFF7C3AED);
  final Color _pickColor = const Color(0xFF0D9488); // teal
  final Color _placeColor = const Color(0xFFF59E0B); // amber

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _message = '';
  bool _lastResultSuccess = false;

  final _manualCodeController = TextEditingController();

  @override
  void dispose() {
    _manualCodeController.dispose();
    super.dispose();
  }

  /// Обработка считанного кода (штрих-код товара или код ячейки)
  void _handleCode(String code) async {
    if (_isProcessing || code.trim().isEmpty) return;
    
    // Вибрация при считывании
    HapticFeedback.lightImpact();
    
    setState(() {
      _isProcessing = true;
      _message = 'Обработка...';
    });

    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final provider = orderAssemblyViewModelProvider(args);
    final vm = ref.read(provider.notifier);
    final state = ref.read(provider);

    (bool, String) result;

    if (state.mode == AssemblyMode.pick) {
      Logger.i('AssemblyScanner: сканирование товара $code');
      result = await vm.processScanPick(code);
    } else {
      Logger.i('AssemblyScanner: сканирование ячейки $code');
      result = await vm.processScanPlace(code);
    }
    
    if (!mounted) return;
    
    var (success, message) = result;
    bool shouldPop = false;

    // Проверка на завершение всех товаров (сигнал от VM)
    if (success && message.startsWith('FINISH:')) {
      shouldPop = true;
      message = message.substring(7); // Убираем префикс
    }

    setState(() {
      _lastResultSuccess = success;
      _message = message;
      _showSuccessOverlay = true;
      _isProcessing = false;
    });

    if (shouldPop) {
      // Краткая пауза для того, чтобы пользователь увидел «галочку» и сообщение
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final state = ref.watch(orderAssemblyViewModelProvider(args));
    
    final isPick = state.mode == AssemblyMode.pick;
    final activeColor = isPick ? _pickColor : _placeColor;
    final modeTitle = isPick ? 'Сбор товаров' : 'Размещение ячеек';
    final hint = isPick ? 'Сканируйте штрих-код товара' : 'Сканируйте код ячейки выдачи';

    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: Text(modeTitle),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Область камеры
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ReaderWidget(
                  onScan: (result) {
                    if (result.isValid && result.text != null) {
                      _handleCode(result.text!);
                    }
                  },
                  codeFormat: Format.any,
                  tryInverted: true, // Помогает с инвертированными кодами
                  tryRotate: true,   // Помогает, когда код под углом
                  showScannerOverlay: false,
                ),
                
                // Рамка сканера
                CustomPaint(
                  painter: ScannerOverlayPainter(primaryColor: activeColor),
                ),

                // Индикатор загрузки
                if (_isProcessing && !_showSuccessOverlay)
                  const Center(child: CircularProgressIndicator()),
                
                // Оверлей результата (как в инвентаризации)
                if (_showSuccessOverlay)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSuccessOverlay = false;
                        _manualCodeController.clear();
                      });
                    },
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.85),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _lastResultSuccess ? Icons.check_circle : Icons.error_outline, 
                            color: _lastResultSuccess ? Colors.greenAccent : Colors.redAccent, 
                            size: 80
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _message,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Нажмите, чтобы продолжить',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          
          // Нижняя панель с ручным вводом
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF1C1C1E),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    hint,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _manualCodeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _bgOffBlack,
                      hintText: isPick ? 'Штрих-код...' : 'Код ячейки...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: activeColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : () => _handleCode(_manualCodeController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Применить вручную', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Отрисовка рамки сканера (адаптировано из инвентаризации)
class ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;

  ScannerOverlayPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final scanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 320,
      height: 160,
    );
    
    final backgroundPaint = Paint()..color = Colors.black54;
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)));

    final backgroundWithCutout = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)), borderPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => primaryColor != oldDelegate.primaryColor;
}
