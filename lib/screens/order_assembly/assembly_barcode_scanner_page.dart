import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // <--- Добавили mobile_scanner
import 'order_assembly_viewmodel.dart';
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

class _AssemblyBarcodeScannerPageState extends ConsumerState<AssemblyBarcodeScannerPage> 
    with SingleTickerProviderStateMixin {
  
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _pickColor = const Color(0xFF0D9488); 
  final Color _placeColor = const Color(0xFFF59E0B); 

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
    
    // Инициализация контроллера MobileScanner
    _mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    // Инициализация анимации лазера
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

    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final state = ref.read(orderAssemblyViewModelProvider(args));
    final vm = ref.read(orderAssemblyViewModelProvider(args).notifier);

    // Виброотклик при захвате кода
    HapticFeedback.mediumImpact();
    
    setState(() {
      _isProcessing = true;
      _message = 'Обработка...';
    });

    // ЛОГИКА ЭКСПРЕСС-ВЫДАЧИ
    if (state.isExpress && state.mode == AssemblyMode.place) {
      final result = await vm.verifyCustomerQr(code);
      if (!mounted) return;

      if (result.$1) {
        Navigator.pop(context, true); 
      } else {
        setState(() {
          _lastResultSuccess = false;
          _message = result.$2;
          _showSuccessOverlay = true;
          _isProcessing = false;
        });
      }
      return; 
    }

    // СТАНДАРТНАЯ ЛОГИКА (СБОР/РАЗМЕЩЕНИЕ)
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
        if (mounted) Navigator.pop(context); 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = (assignmentId: widget.assignmentId, userId: widget.userId);
    final state = ref.watch(orderAssemblyViewModelProvider(args));
    
    final isPick = state.mode == AssemblyMode.pick;
    final isQrMode = !isPick; 
    final activeColor = isPick ? _pickColor : _placeColor;

    // Расчет окна сканирования
    final screenSize = MediaQuery.of(context).size;
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
          // 1. Умный выбор движка камеры в зависимости от режима
          isQrMode
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

          // 2. Анимированный оверлей
          AnimatedBuilder(
            animation: _laserController,
            builder: (context, child) {
              return Positioned.fill(
                child: CustomPaint(
                  painter: ScannerOverlayPainter(
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
          _buildHeader(isPick, state.isExpress, isQrMode),

          // 4. Нижняя панель
          _buildBottomPanel(isPick, activeColor),

          // 5. Оверлеи состояний
          if (_isProcessing && !_showSuccessOverlay)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator())),

          if (_showSuccessOverlay)
            _buildResultOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isPick, bool isExpress, bool isQrMode) {
    final title = isPick ? 'Сбор товаров' : (isExpress ? 'Выдача клиенту' : 'Размещение ячеек');
    final hint = isPick ? 'Штрих-код товара (ZXing)' : (isExpress ? 'QR-код покупателя (Mobile Scanner)' : 'QR-код ячейки (Mobile Scanner)');

    return Positioned(
      top: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 20, 20),
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(hint, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white), 
              onPressed: () {
                setState(() {
                  _isTorchOn = !_isTorchOn;
                });
                
                // Включаем встроенную вспышку для Mobile Scanner
                if (isQrMode) {
                  _mobileScannerController.toggleTorch();
                }
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(bool isPick, Color activeColor) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                hintText: isPick ? 'Введите штрих-код...' : 'Введите код...',
                hintStyle: const TextStyle(color: Colors.white38),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: activeColor)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : () => _handleCode(_manualCodeController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Применить вручную', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverlay() {
    return GestureDetector(
      onTap: () => setState(() { _showSuccessOverlay = false; _manualCodeController.clear(); }),
      child: Container(
        color: Colors.black.withValues(alpha: 0.9),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_lastResultSuccess ? Icons.check_circle : Icons.error_outline, 
                 color: _lastResultSuccess ? Colors.greenAccent : Colors.redAccent, size: 90),
            const SizedBox(height: 24),
            Text(_message, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            const Text('Нажмите, чтобы продолжить', style: TextStyle(color: Colors.white38, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;
  final Rect scanWindow;
  final double laserPosition;
  final bool isProcessing;

  ScannerOverlayPainter({
    required this.primaryColor,
    required this.scanWindow,
    required this.laserPosition,
    required this.isProcessing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Затемнение области вне сканирования
    final backgroundPaint = Paint()..color = Colors.black54;
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(20)));
    canvas.drawPath(Path.combine(PathOperation.difference, backgroundPath, cutoutPath), backgroundPaint);

    // 2. Рамка (вспышка белым при обработке)
    final Paint framePaint = Paint()
      ..color = isProcessing ? Colors.white : primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = isProcessing ? 5.0 : 3.0;

    _drawCorners(canvas, scanWindow, framePaint);

    // 3. Лазерная линия (только когда не обрабатываем код)
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
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) => true;
}