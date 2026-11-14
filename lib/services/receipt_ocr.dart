import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'receipt_scanner.dart';

/// Offline OCR fallback for receipts whose QR code carries no prices (Shell,
/// some OMV/MOL receipts). The text stays on the device.
class ReceiptOcr {
  ReceiptOcr._();

  static Future<ReceiptData?> fromImagePath(String path) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFilePath(path);
      final result = await recognizer.processImage(input);
      if (kDebugMode) debugPrint('Fuelix OCR text >>> ${result.text} <<<');
      return ReceiptParser.parseText(result.text);
    } catch (_) {
      return null;
    } finally {
      await recognizer.close();
    }
  }
}
