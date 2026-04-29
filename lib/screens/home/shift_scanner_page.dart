import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ShiftScannerPage extends StatefulWidget {
  const ShiftScannerPage({super.key});

  @override
  State<ShiftScannerPage> createState() => _ShiftScannerPageState();
}

class _ShiftScannerPageState extends State<ShiftScannerPage> {
  bool _isScanned = false;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: [
          // 1. Сама камера
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (_isScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _isScanned = true;
                  Navigator.of(context).pop(barcode.rawValue);
                  break;
                }
              }
            },
          ),

          // 2. Затемнение с «прицелом»
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              child: CustomPaint(
                painter: _ScannerOverlayPainter(),
              ),
            ),
          ),

          // 3. Верхняя панель
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 50, 20, 20),
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
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Смена',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Наведите камеру на QR-код',
                          style: TextStyle(color: Colors.white54, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => _controller.toggleTorch(),
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

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cutoutSize = 250.0;
    final double left = (size.width - cutoutSize) / 2;
    final double top = (size.height - cutoutSize) / 2;
    final Rect rect = Rect.fromLTWH(left, top, cutoutSize, cutoutSize);

    final Paint paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final double cornerLen = 25.0;
    final double radius = 20.0;

    // Рисуем уголки
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
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}