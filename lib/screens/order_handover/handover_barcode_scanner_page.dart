// lib/screens/order_handover/handover_barcode_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; 
import 'package:go_router/go_router.dart';
import 'order_handover_viewmodel.dart';
import '../../core/utils/logger.dart';
import '../order_assembly/assembly_barcode_scanner_page.dart'; // для ScannerOverlayPainter

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

    final args = (taskId: widget.taskId, workerId: widget.workerId, assignmentId: 0); // assignmentId тут не нужен API, шлем 0
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
      
      // Автоматически завершаем задачу, если всё готово
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
        if (mounted) Navigator.pop(context, true); // Возвращаем true на родительский экран
      });
    } else {
      // Прячем оверлей успеха через секунду для непрерывного сканирования
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          setState(() {
             _showSuccessOverlay = false;
          });
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
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _handleCode(barcodes.first.rawValue!);
              }
            },
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(primaryColor: _handoverColor),
            ),
          ),
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).padding.top + 10, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1C1E),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Выдача товара', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Сканируйте штрих-код товара из списка', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.flash_on, color: Colors.white), onPressed: () => _scannerController.toggleTorch()),
                ],
              ),
            ),
          ),
          Positioned(
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
                      filled: true, fillColor: _bgOffBlack,
                      hintText: 'Штрихкод вручную...', hintStyle: const TextStyle(color: Colors.white38),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _handoverColor)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isProcessing ? null : () => _handleCode(_manualCodeController.text),
                    style: ElevatedButton.styleFrom(backgroundColor: _handoverColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)),
                    child: const Text('Применить', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          if (_isProcessing && !_showSuccessOverlay)
            Container(color: Colors.black54, child: const Center(child: CircularProgressIndicator())),
          if (_showSuccessOverlay)
            Container(
              color: Colors.black.withOpacity(0.85),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_lastResultSuccess ? Icons.check_circle : Icons.error_outline, color: _lastResultSuccess ? Colors.greenAccent : Colors.redAccent, size: 80),
                  const SizedBox(height: 20),
                  Text(_message, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ],
              ),
            ),
        ],
      ),
    );
  }
}