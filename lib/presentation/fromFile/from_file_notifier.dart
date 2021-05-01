import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class FromFileNotifier extends ChangeNotifier {
  String? _path;
  final _barcodeDetector = GoogleVision.instance.barcodeDetector(
      BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));

  String? get path => _path;

  void changeFile(String value) {
    _path = value;
    notifyListeners();
  }

  Future<String?> scanImage() async {
    final path = _path;
    if (path != null) {
      final imageFile = File(path);
      final visionImage = GoogleVisionImage.fromFile(imageFile);
      final List<Barcode> scanResults =
          await _barcodeDetector.detectInImage(visionImage);
      return scanResults.isNotEmpty ? scanResults[0].rawValue : null;
    }
  }

  @override
  void dispose() {
    _barcodeDetector.close();
    super.dispose();
  }
}
