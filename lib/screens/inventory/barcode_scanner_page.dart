import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'inventory_viewmodel.dart';

class BarcodeScannerPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> args;

  const BarcodeScannerPage({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends ConsumerState<BarcodeScannerPage> {
  final Color _bgOffBlack = const Color(0xFF141414);
  final Color _primaryColor = const Color(0xFF7C3AED);

  late String positionCode;
  late int assignmentId;
  late int workerId;

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _successMessage = '';

  final _testCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    positionCode = widget.args['positionCode'] as String;
    assignmentId = widget.args['assignmentId'] as int;
    workerId = widget.args['workerId'] as int;
  }

  @override
  void dispose() {
    _testCodeController.dispose();
    super.dispose();
  }

  void _handleCode(String code) async {
    if (_isProcessing) return;
    
    // Легкая вибрация для обратной связи об успешном захвате штрихкода (из требований)
    HapticFeedback.lightImpact();
    
    setState(() => _isProcessing = true);

    final provider = inventoryViewModelProvider((workerId: workerId, assignmentId: assignmentId));
    final vm = ref.read(provider.notifier);

    final result = await vm.processScannedCodeAsync(positionCode, code);
    
    if (result.$1 == false && result.$2.startsWith('REQUIRE_CONFIRMATION')) {
      // Требуется подтверждение добавления неизвестного товара
      final parts = result.$2.split('|');
      final itemName = parts[1];
      final itemId = int.parse(parts[2]);

      if (!mounted) return;
      
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1C1C1E),
          title: const Text('Товар не найден', style: TextStyle(color: Colors.white)),
          content: Text('Товар "$itemName" не найден в ожидаемых для данной позиции.\n\nУчесть товар?', style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), 
              child: const Text('Отмена', style: TextStyle(color: Colors.white54))
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              child: const Text('Учесть товар', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        vm.addUnexpectedItem(positionCode, itemId, itemName);
        if (mounted) {
          setState(() {
            _successMessage = '✓ $itemName: добавлен (1)';
            _showSuccessOverlay = true;
          });
        }
      } else {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else if (result.$1 == true) {
      if (mounted) {
        setState(() {
          _successMessage = result.$2;
          _showSuccessOverlay = true;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.$2), 
          backgroundColor: Colors.redAccent
        ));
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgOffBlack,
      appBar: AppBar(
        title: Text('Скан: $positionCode'),
        backgroundColor: const Color(0xFF1C1C1E),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ReaderWidget(
                  onScan: (result) {
                    if (result.isValid && result.text != null) {
                      _handleCode(result.text!);
                    }
                  },
                  showScannerOverlay: false, // Отключаем дефолтный оверлей библиотеки
                ),
                
                // Пользовательский прицел-оверлей
                CustomPaint(
                  painter: ScannerOverlayPainter(primaryColor: _primaryColor),
                ),

                if (_isProcessing && !_showSuccessOverlay)
                  const Center(child: CircularProgressIndicator()),
                
                if (_showSuccessOverlay)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showSuccessOverlay = false;
                        _isProcessing = false;
                        _testCodeController.clear();
                      });
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.8),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                          const SizedBox(height: 16),
                          Text(
                            _successMessage,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Нажмите в любом месте\nчтобы сканировать дальше',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF1C1C1E),
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Или введите код вручную:', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _testCodeController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF141414), // _bgOffBlack
                        border: OutlineInputBorder(),
                        hintText: 'Введите ItemId...',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _isProcessing ? null : () => _handleCode(_testCodeController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Применить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Color primaryColor;

  ScannerOverlayPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Точный расчет scanWindow по центру с учетом размера экрана типа "одно к двум"
    final scanWindow = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 320,
      height: 160,
    );
    
    final backgroundPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)));

    final backgroundWithCutout = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)), borderPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return primaryColor != oldDelegate.primaryColor;
  }
}
