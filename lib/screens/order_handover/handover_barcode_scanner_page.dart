// lib/screens/order_handover/handover_barcode_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import 'package:go_router/go_router.dart';
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

class _HandoverBarcodeScannerPageState extends ConsumerState<HandoverBarcodeScannerPage> {
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _headerBg = const Color(0xFF1C1C1E);
  final Color _handoverColor = const Color(0xFFE11D48); 

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
      // Оптимизируем под штрих-коды товаров (1D), убираем QR[cite: 18]
      formats: [BarcodeFormat.ean13, BarcodeFormat.code128, BarcodeFormat.code39],
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
      _message = 'Сверка товара...';
    });

    final args = (taskId: widget.taskId, workerId: widget.workerId, assignmentId: 0); 
    final vm = ref.read(orderHandoverViewModelProvider(args).notifier);

    var (success, message) = await vm.processScan(code);
    
    if (!mounted) return;
    
    bool shouldPop = false;

    if (!success) {
      message = message.replaceAll('ApiException: ', '').replaceAll('Exception: ', '');
    }

    if (success && message.startsWith('FINISH:')) {
      shouldPop = true;
      message = message.substring(7);
      await vm.completeTask();
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
    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Камера
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _handleCode(barcodes.first.rawValue!);
              }
            },
          ),

          // 2. Затемнение и прямоугольный «прицел» для штрих-кодов[cite: 18]
          Positioned.fill(
            child: CustomPaint(
              painter: _HandoverOverlayPainter(primaryColor: _handoverColor),
            ),
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
                        Text('Сканируйте штрих-код на упаковке', 
                          style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white), 
                    onPressed: () => _scannerController.toggleTorch()
                  ),
                ],
              ),
            ),
          ),

          // 4. Нижняя панель
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

          // 5. Оверлеи состояния[cite: 18]
          if (_isProcessing && !_showSuccessOverlay)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator())),

          if (_showSuccessOverlay)
            GestureDetector(
              onTap: () => setState(() => _showSuccessOverlay = false),
              child: Container(
                color: Colors.black.withOpacity(0.9),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _lastResultSuccess ? Icons.check_circle_outline : Icons.error_outline, 
                      color: _lastResultSuccess ? Colors.greenAccent : Colors.redAccent, 
                      size: 90
                    ),
                    const SizedBox(height: 24),
                    Text(_message, 
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500), 
                      textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    const Text('Нажмите, чтобы продолжить', 
                      style: TextStyle(color: Colors.white38, fontSize: 14)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Прямоугольный оверлей, оптимизированный под штрих-коды[cite: 18]
class _HandoverOverlayPainter extends CustomPainter {
  final Color primaryColor;
  _HandoverOverlayPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    const double windowWidth = 320.0;
    const double windowHeight = 140.0; // Более узкое окно для штрих-кодов[cite: 18]
    final double left = (size.width - windowWidth) / 2;
    final double top = (size.height - windowHeight) / 2 - 60;
    final Rect rect = Rect.fromLTWH(left, top, windowWidth, windowHeight);

    final Paint backgroundPaint = Paint()..color = Colors.black54;
    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)));
    canvas.drawPath(Path.combine(PathOperation.difference, backgroundPath, cutoutPath), backgroundPaint);

    final Paint paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double cornerLen = 25.0;
    const double radius = 24.0;

    canvas.drawPath(Path()..moveTo(rect.left, rect.top + cornerLen)..lineTo(rect.left, rect.top + radius)..quadraticBezierTo(rect.left, rect.top, rect.left + radius, rect.top)..lineTo(rect.left + cornerLen, rect.top), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.top)..lineTo(rect.right - radius, rect.top)..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + radius)..lineTo(rect.right, rect.top + cornerLen), paint);
    canvas.drawPath(Path()..moveTo(rect.left, rect.bottom - cornerLen)..lineTo(rect.left, rect.bottom - radius)..quadraticBezierTo(rect.left, rect.bottom, rect.left + radius, rect.bottom)..lineTo(rect.left + cornerLen, rect.bottom), paint);
    canvas.drawPath(Path()..moveTo(rect.right - cornerLen, rect.bottom)..lineTo(rect.right - radius, rect.bottom)..quadraticBezierTo(rect.right, rect.bottom, rect.right, rect.bottom - radius)..lineTo(rect.right, rect.bottom - cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}