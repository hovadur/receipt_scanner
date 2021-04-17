import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FromFileNotifier extends ChangeNotifier {
  String? _path;
  final _barcodeDetector =
      GoogleMlKit.vision.barcodeScanner([Barcode.FORMAT_QR_Code]);

  String? get path => _path;

  void changeFile(String value) {
    _path = value;
    notifyListeners();
  }

  Future<String?> scanImage() async {
    final path = _path;
    if (path != null) {
      final imageFile = File(path);
      final visionImage = InputImage.fromFile(imageFile);
      final List<Barcode> scanResults =
          await _barcodeDetector.processImage(visionImage);
      if (scanResults.isNotEmpty) {
        return scanResults[0].barcodeUnknown?.rawValue;
      } else {
        return null;
      }
    }
  }

  @override
  void dispose() {
    _barcodeDetector.close();
    super.dispose();
  }
}
