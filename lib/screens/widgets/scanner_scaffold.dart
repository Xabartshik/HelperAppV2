import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScaffold extends StatefulWidget {
  final String title;
  final String? topText;
  final Widget? bottomContent;
  final void Function(BarcodeCapture) onDetect;
  final bool isFlashSupported;
  final List<Widget>? topActionButtons;

  const ScannerScaffold({
    super.key,
    required this.title,
    this.topText,
    this.bottomContent,
    required this.onDetect,
    this.isFlashSupported = false,
    this.topActionButtons,
  });

  @override
  State<ScannerScaffold> createState() => _ScannerScaffoldState();
}

class _ScannerScaffoldState extends State<ScannerScaffold> {
  static const Color _primaryColor = Color(0xFF7C3AED); // Фиолетовый акцент
  static const Color _bgOffBlack = Color(0xFF141414);
  static const Color _bgGray950 = Color(0xFF1C1C1E);
  final MobileScannerController _controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgOffBlack,
      body: Stack(
        children: [
          // 1. Камера на весь экран
          MobileScanner(
            controller: _controller,
            onDetect: widget.onDetect,
          ),

          // 2. Красивый стилизованный прицел-оверлей
          Positioned.fill(
            child: Container(
              color: Colors.black45, // Затемнение
              child: CustomPaint(
                painter: _ScannerOverlayPainter(
                  borderColor: _primaryColor,
                  cutoutWidth: 260,
                  cutoutHeight: 260,
                ),
              ),
            ),
          ),

          // 3. Заголовок и инструкции
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopPanel(context),
          ),

          // 4. Информация снизу (динамическая)
          if (widget.bottomContent != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomPanel(context),
            ),
        ],
      ),
    );
  }

  Widget _buildTopPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: const BoxDecoration(
        color: _bgGray950,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (widget.topActionButtons != null) ...widget.topActionButtons!,
              ],
            ),
            if (widget.topText != null && widget.topText!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                widget.topText!,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _bgGray950,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: widget.bottomContent!,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Custom Painter для рисования рамки прицела с закруглениями и углами
class _ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double cutoutWidth;
  final double cutoutHeight;

  _ScannerOverlayPainter({
    required this.borderColor,
    required this.cutoutWidth,
    required this.cutoutHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final cutoutSize = Size(cutoutWidth, cutoutHeight);
    final cutoutOffset = Offset(
      (size.width - cutoutSize.width) / 2,
      (size.height - cutoutSize.height) / 2,
    );
    final cutoutRect = cutoutOffset & cutoutSize;

    // Рисуем рамку прицела
    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, const Radius.circular(16)));

    // Ограничиваем рисование, чтобы углы не выходили за рамки
    canvas.save();
    canvas.clipPath(cutoutPath);

    // Рисуем закругленные углы прицела
    _drawCorners(canvas, cutoutRect, 20.0, paint);
    
    canvas.restore();
  }

  void _drawCorners(Canvas canvas, Rect rect, double cornerLength, Paint paint) {
    // Top Left
    canvas.drawPath(Path()
      ..moveTo(rect.left, rect.top + cornerLength)
      ..lineTo(rect.left, rect.top)
      ..lineTo(rect.left + cornerLength, rect.top), paint);

    // Top Right
    canvas.drawPath(Path()
      ..moveTo(rect.right - cornerLength, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, rect.top + cornerLength), paint);

    // Bottom Left
    canvas.drawPath(Path()
      ..moveTo(rect.left, rect.bottom - cornerLength)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left + cornerLength, rect.bottom), paint);

    // Bottom Right
    canvas.drawPath(Path()
      ..moveTo(rect.right - cornerLength, rect.bottom)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.right, rect.bottom - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}