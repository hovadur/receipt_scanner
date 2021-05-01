import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.absoluteImageSize, this.barcodeLocations);

  final Size absoluteImageSize;
  final List<Barcode> barcodeLocations;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / absoluteImageSize.width;
    final scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(Barcode barcode) {
      return Rect.fromLTRB(
        barcode.boundingBox?.left ?? 0 * scaleX,
        barcode.boundingBox?.top ?? 0 * scaleY,
        barcode.boundingBox?.right ?? 0 * scaleX,
        barcode.boundingBox?.bottom ?? 0 * scaleY,
      );
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final barcode in barcodeLocations) {
      paint.color = Colors.green;
      canvas.drawRect(scaleRect(barcode), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.barcodeLocations != barcodeLocations;
  }
}
