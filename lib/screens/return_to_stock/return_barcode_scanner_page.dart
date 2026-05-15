import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <--- Добавили Mobile Scanner
import 'return_to_stock_viewmodel.dart';
import '../../core/utils/logger.dart';

class ReturnBarcodeScannerPage extends ConsumerStatefulWidget {
  final int assignmentId;
  final int taskId;
  final int workerId;
  final int lineId;
  final bool isCellScan; 

  const ReturnBarcodeScannerPage({
    super.key,
    required this.assignmentId,
    required this.taskId,
    required this.workerId,
    required this.lineId,
    this.isCellScan = false,
  });

  @override
  ConsumerState<ReturnBarcodeScannerPage> createState() => _ReturnBarcodeScannerPageState();
}

class _ReturnBarcodeScannerPageState extends ConsumerState<ReturnBarcodeScannerPage> 
    with SingleTickerProviderStateMixin { 

  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _returnColor = const Color(0xFF3B82F6); 
  final Color _cellColor = const Color(0xFFF59E0B);   

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _message = '';
  bool _lastResultSuccess = false;
  
  bool _isTorchOn = false;

  final _manualCodeController = TextEditingController();
  late AnimationController _laserController;
  late MobileScannerController _mobileScannerController; // <--- Контроллер для QR

  @override
  void initState() {
    super.initState();
    
    // Инициализируем контроллер для QR-сканера
    _mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _mobileScannerController.dispose(); // <--- Очистка контроллера
    _laserController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  void _handleCode(String code) async {
    if (_isProcessing || code.trim().isEmpty) return;
    
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isProcessing = true;
      _message = 'Обработка...';
    });

    final args = (assignmentId: widget.assignmentId, taskId: widget.taskId, workerId: widget.workerId);
    final vm = ref.read(returnToStockViewModelProvider(args).notifier);

    (bool, String) result;
    if (widget.isCellScan) {
      Logger.i('ReturnScanner: сканирование ячейки $code');
      result = await vm.processScanCell(widget.lineId, code);
    } else {
      Logger.i('ReturnScanner: сканирование товара $code');
      result = await vm.processScanItem(widget.lineId, code);
    }
    
    if (!mounted) return;
    
    var (success, message) = result;
    bool shouldPop = false;

    if (!success) {
      message = message.replaceAll('ApiException: ', '').replaceAll('Exception: ', '');
      if (message.contains('400') || message.toLowerCase().contains('формат')) {
        message = '⚠️ Неверный код!\n\nПроверьте, что вы сканируете нужный объект.';
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
    final activeColor = widget.isCellScan ? _cellColor : _returnColor;
    final title = widget.isCellScan ? 'Сканирование ячейки' : 'Сканирование товара';
    final hint = widget.isCellScan 
        ? 'Наведите камеру на QR-код ячейки (Mobile Scanner)' 
        : 'Наведите камеру на штрих-код товара (ZXing)';

    final screenSize = MediaQuery.of(context).size;
    final double windowWidth = widget.isCellScan ? 260.0 : screenSize.width - 48; 
    final double windowHeight = widget.isCellScan ? 260.0 : 140.0;
    
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2 - 40),
      width: windowWidth,
      height: windowHeight,
    );

    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Умный выбор камеры
          widget.isCellScan
              ? MobileScanner(
                  controller: _mobileScannerController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        _handleCode(barcode.rawValue!);
                        break; 
                      }
                    }
                  },
                )
              : ReaderWidget(
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

          // 2. Анимированное затемнение и вырез
          AnimatedBuilder(
            animation: _laserController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: ReturnOverlayPainter(
                    primaryColor: activeColor,
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
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          hint,
                          style: const TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                      
                      // Управление встроенной вспышкой Mobile Scanner
                      if (widget.isCellScan) {
                        _mobileScannerController.toggleTorch();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // 4. Нижняя панель ручного ввода
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _manualCodeController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _bgOffBlack,
                      hintText: widget.isCellScan ? 'Введите код ячейки...' : 'Введите штрих-код...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: activeColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : () => _handleCode(_manualCodeController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Применить вручную', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),

          // 5. Индикатор загрузки
          if (_isProcessing && !_showSuccessOverlay)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),

          // 6. Оверлей результата
          if (_showSuccessOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showSuccessOverlay = false;
                  _manualCodeController.clear();
                });
              },
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
                    Text(
                      _message,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Нажмите, чтобы продолжить',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ReturnOverlayPainter extends CustomPainter {
  final Color primaryColor;
  final Rect scanWindow;
  final double laserPosition;
  final bool isProcessing;

  ReturnOverlayPainter({
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
  bool shouldRepaint(covariant ReturnOverlayPainter oldDelegate) => true;
}