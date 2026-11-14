import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../l10n/strings.dart';
import '../../services/ekasa_service.dart';
import '../../services/receipt_ocr.dart';
import '../../services/receipt_scanner.dart';

class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
  );
  final ImagePicker _picker = ImagePicker();
  bool _handled = false;
  bool _invalid = false;
  bool _processing = false;
  bool _lookingUp = false;
  String? _raw;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled || _processing) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final data = ReceiptParser.parse(raw);
      if (data == null) {
        if (!_invalid && mounted) {
          setState(() {
            _invalid = true;
            _raw = raw;
          });
        }
        continue;
      }
      if (data.hasValues) {
        _handled = true;
        Navigator.of(context).pop(data);
        return;
      }
      final uid = data.receiptId;
      if (uid != null) {
        _resolveUid(uid, raw);
        return;
      }
      if (!_invalid && mounted) {
        setState(() {
          _invalid = true;
          _raw = raw;
        });
      }
    }
  }

  Future<void> _resolveUid(String uid, String raw) async {
    setState(() {
      _processing = true;
      _lookingUp = true;
    });
    final receipt = await EkasaService.instance.lookup(uid);
    if (!mounted) return;

    if (receipt != null && receipt.hasValues) {
      _handled = true;
      Navigator.of(context).pop(receipt);
      return;
    }

    setState(() {
      _processing = false;
      _lookingUp = false;
      _invalid = true;
      _raw = raw;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.t('qr.ekasaNotFound'))));
  }

  Future<void> _readImage(ImageSource source) async {
    if (_processing) return;
    XFile? photo;
    try {
      photo = await _picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2200,
      );
    } catch (_) {
      photo = null;
    }
    if (photo == null || !mounted) return;

    setState(() => _processing = true);
    final data = await ReceiptOcr.fromImagePath(photo.path);
    if (!mounted) return;

    if (data != null && data.hasValues) {
      Navigator.of(context).pop(data);
      return;
    }

    setState(() => _processing = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.t('qr.ocrFailed'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(context.t('qr.title')),
        actions: [
          IconButton(
            tooltip: context.t('qr.photo'),
            onPressed: _processing ? null : () => _readImage(ImageSource.camera),
            icon: const Icon(Icons.photo_camera_outlined),
          ),
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flashlight_on_outlined),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 3),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          if (_processing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 14),
                    Text(
                      context.t(_lookingUp ? 'qr.checking' : 'qr.reading'),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              children: [
                Text(
                  context.t(_invalid ? 'qr.qrUnknown' : 'qr.hint'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                if (_invalid && _raw != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'QR: ${_raw!.length > 64 ? '${_raw!.substring(0, 64)}…' : _raw!}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: _processing
                          ? null
                          : () => _readImage(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: Text(context.t('qr.photo')),
                    ),
                    OutlinedButton.icon(
                      onPressed: _processing
                          ? null
                          : () => _readImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: Text(context.t('qr.gallery')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        context.t('qr.manual'),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
