import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CustomerQrScannerPage extends StatefulWidget {
  const CustomerQrScannerPage({super.key});

  @override
  State<CustomerQrScannerPage> createState() => _CustomerQrScannerPageState();
}

class _CustomerQrScannerPageState extends State<CustomerQrScannerPage> {
  // Цветовая схема в стиле модуля инвентаризации/сборки
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _headerBg = const Color(0xFF1C1C1E);
  final Color _accentColor = const Color(0xFFF59E0B); // Оранжевый (стиль Place/Handover)

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    formats: [BarcodeFormat.qrCode],
  );

  bool _isProcessing = false;
  bool _showResultOverlay = false;
  bool _isSuccess = false;
  String _message = '';

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  /// Метод обработки отсканированного кода
  void _handleCode(String code) async {
    if (_isProcessing || _showResultOverlay) return;

    HapticFeedback.mediumImpact(); // Виброотклик[cite: 12, 13]
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // ИМИТАЦИЯ ЗАПРОСА К СЕРВЕРУ
      // Здесь должен быть ваш вызов: await _service.validateCustomerQr(code);
      await Future.delayed(const Duration(seconds: 1));
      
      // Для примера: если код содержит "error", имитируем 400 ошибку
      if (code.toLowerCase().contains('error')) {
        throw Exception("ApiException: 400. Неверный формат или срок действия истек");
      }

      setState(() {
        _isSuccess = true;
        _message = "Клиент успешно идентифицирован";
        _showResultOverlay = true;
      });

      // Автоматически закрываем экран через 1.5 секунды при успехе
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) Navigator.pop(context, code);
      });

    } catch (e) {
      // ОБРАБОТКА ОШИБОК СЕРВЕРА (400 и др.)[cite: 12]
      String errorText = e.toString().replaceAll('Exception: ', '').replaceAll('ApiException: ', '');
      
      if (errorText.contains('400')) {
        errorText = "⚠️ Ошибка доступа\n\nQR-код клиента недействителен или устарел.";
      } else if (errorText.contains('404')) {
        errorText = "Клиент не найден в базе данных.";
      }

      setState(() {
        _isSuccess = false;
        _message = errorText;
        _showResultOverlay = true;
      });
    } finally {
      setState(() {
        _isProcessing = false;
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

          // 2. Затемнение и «прицел» в стиле сборки[cite: 11, 12]
          Positioned.fill(
            child: CustomPaint(
              painter: _ScannerOverlayPainter(primaryColor: _accentColor),
            ),
          ),

          // 3. Верхняя панель управления[cite: 11, 12]
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 20, 20),
              decoration: BoxDecoration(
                color: _headerBg,
                borderRadius: const BorderRadius.only(
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Идентификация',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Наведите на QR-код клиента',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
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

          // 4. Индикатор загрузки (процессинг)[cite: 12]
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.orange)),
            ),

          // 5. Оверлей результата (ошибка или успех)[cite: 12]
          if (_showResultOverlay)
            GestureDetector(
              onTap: () => setState(() => _showResultOverlay = false),
              child: Container(
                color: Colors.black.withOpacity(0.9),
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                      color: _isSuccess ? Colors.greenAccent : Colors.redAccent,
                      size: 90,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    if (!_isSuccess) ...[
                      const SizedBox(height: 40),
                      const Text(
                        'Нажмите, чтобы попробовать снова',
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ]
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Отрисовка «прицела» сканера
class _ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;
  _ScannerOverlayPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    const double cutoutSize = 260.0;
    final double left = (size.width - cutoutSize) / 2;
    final double top = (size.height - cutoutSize) / 2 - 20;
    final Rect rect = Rect.fromLTWH(left, top, cutoutSize, cutoutSize);

    // Затемнение фона вокруг окна[cite: 11]
    final Paint backgroundPaint = Paint()..color = Colors.black54;
    final Path backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final Path cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)));
    canvas.drawPath(Path.combine(PathOperation.difference, backgroundPath, cutoutPath), backgroundPaint);

    // Уголки[cite: 11, 12]
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