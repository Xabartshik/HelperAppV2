import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ShiftScannerPage extends StatefulWidget {
  const ShiftScannerPage({super.key});

  @override
  State<ShiftScannerPage> createState() => _ShiftScannerPageState();
}

class _ShiftScannerPageState extends State<ShiftScannerPage> {
  // Стилистические цвета из экрана сборки
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _headerBg = const Color(0xFF1C1C1E);
  final Color _accentColor = const Color(0xFF0D9488); // Бирюзовый акцент

  bool _isScanned = false;
  
  // Настраиваем контроллер в стиле экрана сборки
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
    formats: [BarcodeFormat.qrCode], // Обычно для смен используются QR
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      HapticFeedback.lightImpact(); // Виброотклик как при сборке
      _isScanned = true;
      // В реальности здесь может быть вызов API, пока просто возвращаем код
      Navigator.of(context).pop(barcodes.first.rawValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Камера (на весь экран)
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetect,
          ),

          // 2. Затемнение с «прицелом» (стиль из ScannerOverlayPainter)
          Positioned.fill(
            child: CustomPaint(
              painter: _StyleMatchedOverlayPainter(
                primaryColor: _accentColor,
              ),
            ),
          ),

          // 3. Верхняя панель (стиль оформления из экрана сборки)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              // Учитываем safe area сверху + отступы из стиля сборки
              padding: EdgeInsets.fromLTRB(
                  10, MediaQuery.of(context).padding.top + 10, 20, 20),
              decoration: BoxDecoration(
                color: _headerBg,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  // Кнопка назад вместо закрытия
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
                          'Учет времени',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Отсканируйте QR-код на входе',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  // Фонарик
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => _controller.toggleTorch(),
                  ),
                ],
              ),
            ),
          ),
          
          // Нижняя панель ввода намеренно не добавлена
        ],
      ),
    );
  }
}

/// Painter, реализующий логику отрисовки оверлея из экрана сборки
/// (затемнение фона + вырез с цветными уголками).
class _StyleMatchedOverlayPainter extends CustomPainter {
  final Color primaryColor;

  _StyleMatchedOverlayPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Размеры окна сканирования (сделаем квадратным для QR)
    const double windowSize = 260.0;

    final double left = (size.width - windowSize) / 2;
    // Чуть смещаем вверх от центра, как в оригинале сборки
    final double top = (size.height - windowSize) / 2 - 20;
    final Rect rect = Rect.fromLTWH(left, top, windowSize, windowSize);

    // 1. Отрисовка затемнения фона
    final Paint backgroundPaint = Paint()..color = Colors.black54;
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    // Вырез с закругленными углами
    final Path cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)));
    
    // Объединяем пути, вычитая вырез из фона
    final Path backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // 2. Отрисовка цветных уголков "прицела"
    final Paint paint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double cornerLen = 25.0; // Длина прямой части уголка
    const double radius = 24.0;    // Радиус закругления (должен совпадать с RRect выше)

    // Слева сверху
    canvas.drawPath(
        Path()
          ..moveTo(rect.left, rect.top + cornerLen)
          ..lineTo(rect.left, rect.top + radius)
          ..quadraticBezierTo(rect.left, rect.top, rect.left + radius, rect.top)
          ..lineTo(rect.left + cornerLen, rect.top),
        paint);

    // Справа сверху
    canvas.drawPath(
        Path()
          ..moveTo(rect.right - cornerLen, rect.top)
          ..lineTo(rect.right - radius, rect.top)
          ..quadraticBezierTo(
              rect.right, rect.top, rect.right, rect.top + radius)
          ..lineTo(rect.right, rect.top + cornerLen),
        paint);

    // Слева снизу
    canvas.drawPath(
        Path()
          ..moveTo(rect.left, rect.bottom - cornerLen)
          ..lineTo(rect.left, rect.bottom - radius)
          ..quadraticBezierTo(
              rect.left, rect.bottom, rect.left + radius, rect.bottom)
          ..lineTo(rect.left + cornerLen, rect.bottom),
        paint);

    // Справа снизу
    canvas.drawPath(
        Path()
          ..moveTo(rect.right - cornerLen, rect.bottom)
          ..lineTo(rect.right - radius, rect.bottom)
          ..quadraticBezierTo(
              rect.right, rect.bottom, rect.right, rect.bottom - radius)
          ..lineTo(rect.right, rect.bottom - cornerLen),
        paint);
  }

  @override
  bool shouldRepaint(covariant _StyleMatchedOverlayPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor;
}