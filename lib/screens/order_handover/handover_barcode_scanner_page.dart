import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'order_handover_viewmodel.dart';

class HandoverBarcodeScannerPage extends ConsumerStatefulWidget {
  final int taskId;
  final int workerId;

  const HandoverBarcodeScannerPage({
    super.key,
    required this.taskId,
    required this.workerId,
  });

  @override
  ConsumerState<HandoverBarcodeScannerPage> createState() => _HandoverBarcodeScannerPageState();
}

class _HandoverBarcodeScannerPageState extends ConsumerState<HandoverBarcodeScannerPage> 
    with SingleTickerProviderStateMixin { 

  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _headerBg = const Color(0xFF1C1C1E);
  final Color _handoverColor = const Color(0xFFE11D48); 

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _message = '';
  bool _lastResultSuccess = false;
  
  bool _isTorchOn = false;

  final _manualCodeController = TextEditingController();
  late AnimationController _laserController;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _laserController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  void _handleCode(String code) async {
    if (_isProcessing || code.trim().isEmpty) return;
    
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isProcessing = true;
      _message = 'Сверка товара...';
    });

    final args = (taskId: widget.taskId, workerId: widget.workerId, assignmentId: 0); 
    final vm = ref.read(orderHandoverViewModelProvider(args).notifier);

    var (success, message) = await vm.processScan(code);
    
    if (!mounted) return;
    
    bool shouldPop = false;

    if (!success) {
      message = message.replaceAll('ApiException: ', '').replaceAll('Exception: ', '');
      if (message.contains('400') || message.toLowerCase().contains('формат')) {
        message = '⚠️ Неверный код!\n\nПроверьте объект сканирования.';
      }
    }

    if (success && message.startsWith('FINISH:')) {
      shouldPop = true;
      message = message.substring(7);
    }

    setState(() {
      _lastResultSuccess = success;
      _message = message;
      _showSuccessOverlay = true;
      _isProcessing = false;
    });

    if (shouldPop) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context, true); 
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && _lastResultSuccess) {
          setState(() => _showSuccessOverlay = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Окно настроено исключительно под 1D штрих-коды
    final screenSize = MediaQuery.of(context).size;
    final double windowWidth = screenSize.width - 48;
    const double windowHeight = 140.0; 
    
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2 - 60),
      width: windowWidth,
      height: windowHeight,
    );

    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Камера ZXing (идеальна для 1D)
          ReaderWidget(
            onScan: (result) {
              if (result.isValid && result.text != null) {
                _handleCode(result.text!);
              }
            },
            showScannerOverlay: false, 
            showFlashlight: false,
            showToggleCamera: false,
            showGallery: false,
            tryHarder: true, 
            resolution: ResolutionPreset.high,
            cropPercent: 0.8, 
          ),

          // 2. Анимированный оверлей
          AnimatedBuilder(
            animation: _laserController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: HandoverOverlayPainter(
                    primaryColor: _handoverColor,
                    scanWindow: scanWindow,
                    laserPosition: _laserController.value,
                    isProcessing: _isProcessing,
                  ),
                ),
              );
            },
          ),

          // 3. Верхняя панель
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 20, 20),
              decoration: BoxDecoration(
                color: _headerBg,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white), 
                    onPressed: () => Navigator.of(context).pop()
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Сверка товаров', 
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Сканируйте штрих-код на упаковке (ZXing)', 
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white), 
                    onPressed: () {
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                      // Для включения вспышки в ReaderWidget потребуется сторонний плагин, 
                      // например torch_light: TorchLight.toggleTorch();
                    }
                  ),
                ],
              ),
            ),
          ),

          // 4. Нижняя панель ручного ввода
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: BoxDecoration(
                color: _headerBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _manualCodeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true, 
                      fillColor: _bgOffBlack,
                      hintText: 'Введите штрих-код вручную...', 
                      hintStyle: const TextStyle(color: Colors.white38),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), 
                        borderSide: BorderSide(color: _handoverColor)
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : () => _handleCode(_manualCodeController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _handoverColor, 
                      padding: const EdgeInsets.symmetric(vertical: 16), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 54)
                    ),
                    child: const Text('Применить', 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),

          // 5. Оверлеи состояний
          if (_isProcessing && !_showSuccessOverlay)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator(color: Colors.white))),

          if (_showSuccessOverlay)
            GestureDetector(
              onTap: () => setState(() { _showSuccessOverlay = false; _manualCodeController.clear(); }),
              child: Container(
                color: Colors.black.withValues(alpha: 0.9),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _lastResultSuccess ? Icons.check_circle : Icons.error_outline, 
                      color: _lastResultSuccess ? Colors.greenAccent : Colors.redAccent, 
                      size: 90
                    ),
                    const SizedBox(height: 24),
                    Text(_message, 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), 
                      textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    const Text('Нажмите, чтобы продолжить', 
                      style: TextStyle(color: Colors.white54, fontSize: 14)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class HandoverOverlayPainter extends CustomPainter {
  final Color primaryColor;
  final Rect scanWindow;
  final double laserPosition;
  final bool isProcessing;

  HandoverOverlayPainter({
    required this.primaryColor,
    required this.scanWindow,
    required this.laserPosition,
    required this.isProcessing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = Colors.black54;
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)));
    canvas.drawPath(Path.combine(PathOperation.difference, backgroundPath, cutoutPath), backgroundPaint);

    final Paint framePaint = Paint()
      ..color = isProcessing ? Colors.white : primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isProcessing ? 5.0 : 3.0;

    _drawCorners(canvas, scanWindow, framePaint);

    if (!isProcessing) {
      final double y = scanWindow.top + (scanWindow.height * laserPosition);
      final laserPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            primaryColor.withValues(alpha: 0),
            primaryColor.withValues(alpha: 0.5),
            primaryColor,
            primaryColor.withValues(alpha: 0.5),
            primaryColor.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTRB(scanWindow.left, y - 1, scanWindow.right, y + 1));

      canvas.drawRect(
        Rect.fromLTWH(scanWindow.left + 10, y - 1, scanWindow.width - 20, 2),
        laserPaint,
      );
    }
  }

  void _drawCorners(Canvas canvas, Rect rect, Paint paint) {
    const double cornerLen = 25.0;
    const double radius = 20.0;

    canvas.drawPath(Path()..moveTo(rect.left, rect.top + cornerLen)..lineTo(rect.left, rect.top + radius)..quadraticBezierTo(rect.left, rect.top, rect.left + radius, rect.top)..lineTo(rect.left + cornerLen, rect.top), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.top)..lineTo(rect.right - radius, rect.top)..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + radius)..lineTo(rect.right, rect.top + cornerLen), paint);
    canvas.drawPath(Path()..moveTo(rect.left, rect.bottom - cornerLen)..lineTo(rect.left, rect.bottom - radius)..quadraticBezierTo(rect.left, rect.bottom, rect.left + radius, rect.bottom)..lineTo(rect.left + cornerLen, rect.bottom), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.bottom)..lineTo(rect.right - radius, rect.bottom)..quadraticBezierTo(rect.right, rect.bottom, rect.right, rect.bottom - radius)..lineTo(rect.right, rect.bottom - cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant HandoverOverlayPainter oldDelegate) => true;
}