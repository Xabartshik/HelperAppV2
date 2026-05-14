import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import 'order_assembly_viewmodel.dart';
import '../home/main_viewmodel.dart';
import '../../core/utils/logger.dart';

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
  final Color _pickColor = const Color(0xFF0D9488); 
  final Color _placeColor = const Color(0xFFF59E0B); 

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _message = '';
  bool _lastResultSuccess = false;

  final _manualCodeController = TextEditingController();
  late MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _initScanner();
  }

  void _initScanner() {
    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final state = ref.read(orderAssemblyViewModelProvider(args));

    // Квадратный режим (QR) нужен для размещения ячеек и для экспресс-выдачи
    final bool isQrMode = state.mode != AssemblyMode.pick || state.isExpress;

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      // Оптимизируем форматы: если не сбор, то ищем только QR-коды
      formats: isQrMode
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

    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final state = ref.read(orderAssemblyViewModelProvider(args));
    final vm = ref.read(orderAssemblyViewModelProvider(args).notifier);
    
    // Если это экспресс-заказ (режим выдачи), просто отдаем токен назад экрану сборки
    if (state.isExpress && state.mode == AssemblyMode.place) {
      HapticFeedback.mediumImpact();
      
      // Вместо возврата строки, вызываем метод верификации во ViewModel
      final result = await vm.verifyCustomerQr(code);
      
      if (!mounted) return;

      if (result.$1) {
        // Возвращаем true (bool), что совпадает с ожидаемым типом!
        Navigator.pop(context, true); 
      } else {
        // Если QR не прошел проверку на сервере, показываем ошибку не выходя из сканера
        setState(() {
          _lastResultSuccess = false;
          _message = result.$2;
          _showSuccessOverlay = true;
          _isProcessing = false;
        });
      }
      return; 
    }
    // ------------------------------------

    // --- СТАНДАРТНАЯ ЛОГИКА ДЛЯ СБОРА И РАЗМЕЩЕНИЯ ---
    HapticFeedback.lightImpact();
    
    setState(() {
      _isProcessing = true;
      _message = 'Обработка...';
    });
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
    final isQrMode = !isPick; // И ячейки, и экспресс используют QR
    final activeColor = isPick ? _pickColor : _placeColor;

    final modeTitle = isPick 
        ? 'Сбор товаров' 
        : (state.isExpress ? 'Выдача клиенту' : 'Размещение ячеек');
        
    final hint = isPick 
        ? 'Сканируйте штрих-код товара' 
        : (state.isExpress ? 'Наведите камеру на QR-код покупателя' : 'Сканируйте QR-код ячейки');

    // 1. Вычисляем размеры и позицию окна сканирования
    final screenSize = MediaQuery.of(context).size;
    // Если QR — делаем квадрат 260x260, если штрих-код товара — вытянутый прямоугольник (ширина экрана минус отступы)
    final double windowWidth = isQrMode ? 260.0 : screenSize.width - 48;
    final double windowHeight = isQrMode ? 260.0 : 160.0;
    
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2 - 40),
      width: windowWidth,
      height: windowHeight,
    );

    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 2. Камера теперь ограничена окном сканирования (scanWindow)
          MobileScanner(
            controller: _scannerController,
            scanWindow: scanWindow, // <--- Указываем окно для ML Kit
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _handleCode(barcodes.first.rawValue!);
              }
            },
          ),

          // 3. Рисуем прицел по нашему scanWindow
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(
                primaryColor: activeColor,
                scanWindow: scanWindow, // <--- Передаем вычисленный Rect
              ),
            ),
          ),

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
                          modeTitle,
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
                      hintText: isPick ? 'Введите штрих-код...' : 'Введите код...',
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

          if (_isProcessing && !_showSuccessOverlay)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),

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

// 4. Обновленный Painter, который рисует прицел ровно по переданному окну (Rect)
class ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;
  final Rect scanWindow; // Заменили isSquare на scanWindow

  ScannerOverlayPainter({
    required this.primaryColor,
    required this.scanWindow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = Colors.black54;
    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)));
    final Path backgroundWithCutout = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    final Paint paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double cornerLen = 25.0;
    const double radius = 20.0;

    // Рисуем уголки, используя координаты scanWindow
    canvas.drawPath(Path()..moveTo(scanWindow.left, scanWindow.top + cornerLen)..lineTo(scanWindow.left, scanWindow.top + radius)..quadraticBezierTo(scanWindow.left, scanWindow.top, scanWindow.left + radius, scanWindow.top)..lineTo(scanWindow.left + cornerLen, scanWindow.top), paint);
    canvas.drawPath(Path()..moveTo(scanWindow.right - cornerLen, scanWindow.top)..lineTo(scanWindow.right - radius, scanWindow.top)..quadraticBezierTo(scanWindow.right, scanWindow.top, scanWindow.right, scanWindow.top + radius)..lineTo(scanWindow.right, scanWindow.top + cornerLen), paint);
    canvas.drawPath(Path()..moveTo(scanWindow.left, scanWindow.bottom - cornerLen)..lineTo(scanWindow.left, scanWindow.bottom - radius)..quadraticBezierTo(scanWindow.left, scanWindow.bottom, scanWindow.left + radius, scanWindow.bottom)..lineTo(scanWindow.left + cornerLen, scanWindow.bottom), paint);
    canvas.drawPath(Path()..moveTo(scanWindow.right - cornerLen, scanWindow.bottom)..lineTo(scanWindow.right - radius, scanWindow.bottom)..quadraticBezierTo(scanWindow.right, scanWindow.bottom, scanWindow.right, scanWindow.bottom - radius)..lineTo(scanWindow.right, scanWindow.bottom - cornerLen), paint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => 
      primaryColor != oldDelegate.primaryColor || scanWindow != oldDelegate.scanWindow;
}