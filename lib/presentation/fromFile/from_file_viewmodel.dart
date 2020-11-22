import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FromFileViewModel extends ChangeNotifier {
  String? _path;
  final _barcodeDetector = FirebaseVision.instance.barcodeDetector(
      const BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));

  String? get path => _path;

  void changeFile(String value) {
    _path = value;
    notifyListeners();
  }

  Future<String?> scanImage() async {
    final path = _path;
    if (path != null) {
      final imageFile = File(path);
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final scanResults = await _barcodeDetector.detectInImage(visionImage);
      if (scanResults.isNotEmpty) {
        return scanResults[0].rawValue;
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
