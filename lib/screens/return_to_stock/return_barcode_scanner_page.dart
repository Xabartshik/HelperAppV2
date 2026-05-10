import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import 'package:go_router/go_router.dart';
import 'return_to_stock_viewmodel.dart';
import '../../core/utils/logger.dart';

class ReturnBarcodeScannerPage extends ConsumerStatefulWidget {
  final int assignmentId;
  final int taskId;
  final int workerId;
  final int lineId;
  final bool isCellScan; // Режим: true - сканим ячейку (QR), false - товар (Barcode)

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

class _ReturnBarcodeScannerPageState extends ConsumerState<ReturnBarcodeScannerPage> {
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _returnColor = const Color(0xFF3B82F6); // Синий цвет возврата
  final Color _cellColor = const Color(0xFFF59E0B);   // Оранжевый для ячеек

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _message = '';
  bool _lastResultSuccess = false;

  final _manualCodeController = TextEditingController();
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: widget.isCellScan 
          ? [BarcodeFormat.qrCode] 
          : [BarcodeFormat.ean13, BarcodeFormat.code128, BarcodeFormat.code39],
    );
  }

  @override
  void dispose() {
    _manualCodeController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _handleCode(String code) async {
    if (_isProcessing || code.trim().isEmpty) return;
    
    HapticFeedback.lightImpact();
    
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isCellScan ? _cellColor : _returnColor;
    final title = widget.isCellScan ? 'Сканирование ячейки' : 'Сканирование товара';
    final hint = widget.isCellScan ? 'Наведите камеру на QR-код ячейки' : 'Наведите камеру на штрих-код товара';

    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Камера на заднем фоне
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _handleCode(barcodes.first.rawValue!);
              }
            },
          ),

          // 2. Затемнение и область выреза
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                primaryColor: activeColor,
                isSquare: widget.isCellScan,
              ),
            ),
          ),

          // 3. Верхняя панель управления
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
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => _scannerController.toggleTorch(),
                  ),
                ],
              ),
            ),
          ),

          // 4. Нижняя панель для ручного ввода
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              child: const Center(child: CircularProgressIndicator()),
            ),

          // 6. Оверлей с результатом (успех/ошибка)
          if (_showSuccessOverlay)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showSuccessOverlay = false;
                  _manualCodeController.clear();
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.85),
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
    );
  }
}

// Painter для отрисовки затемнения и рамки
class ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;
  final bool isSquare;

  ScannerOverlayPainter({
    required this.primaryColor,
    this.isSquare = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Если квадрат — размер 260x260, если штрих-код — 320x160
    final double windowWidth = isSquare ? 260.0 : 320.0;
    final double windowHeight = isSquare ? 260.0 : 160.0;

    final double left = (size.width - windowWidth) / 2;
    final double top = (size.height - windowHeight) / 2 - 40; 
    final Rect rect = Rect.fromLTWH(left, top, windowWidth, windowHeight);

    final Paint backgroundPaint = Paint()..color = Colors.black54;
    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)));
    final Path backgroundWithCutout = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    final Paint paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double cornerLen = 25.0;
    const double radius = 20.0;

    // Отрисовка четырех уголков-рамок вокруг выреза
    canvas.drawPath(Path()..moveTo(rect.left, rect.top + cornerLen)..lineTo(rect.left, rect.top + radius)..quadraticBezierTo(rect.left, rect.top, rect.left + radius, rect.top)..lineTo(rect.left + cornerLen, rect.top), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.top)..lineTo(rect.right - radius, rect.top)..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + radius)..lineTo(rect.right, rect.top + cornerLen), paint);
    canvas.drawPath(Path()..moveTo(rect.left, rect.bottom - cornerLen)..lineTo(rect.left, rect.bottom - radius)..quadraticBezierTo(rect.left, rect.bottom, rect.left + radius, rect.bottom)..lineTo(rect.left + cornerLen, rect.bottom), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.bottom)..lineTo(rect.right - radius, rect.bottom)..quadraticBezierTo(rect.right, rect.bottom, rect.right, rect.bottom - radius)..lineTo(rect.right, rect.bottom - cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => 
      primaryColor != oldDelegate.primaryColor || isSquare != oldDelegate.isSquare;
}