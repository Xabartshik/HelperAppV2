import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CustomerQrScannerPage extends StatefulWidget {
  const CustomerQrScannerPage({super.key});

  @override
  State<CustomerQrScannerPage> createState() => _CustomerQrScannerPageState();
}

class _CustomerQrScannerPageState extends State<CustomerQrScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  bool _hasScanned = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Сканировать QR клиента', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C1C1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (capture) {
          if (_hasScanned) return;
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            _hasScanned = true;
            HapticFeedback.heavyImpact();
            Navigator.pop(context, barcodes.first.rawValue!);
          }
        },
      ),
    );
  }
}