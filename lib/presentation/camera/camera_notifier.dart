import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';

import '../../database.dart';
import '../../domain/entity/receipt.dart';

class CameraNotifier extends ChangeNotifier {
  CameraNotifier(this._db) {
    try {
      _initializeCamera();
    } catch (e) {
      Fimber.e(e.toString());
    }
  }

  final Database _db;

  @override
  void dispose() {
    _isMounted = false;
    _camera?.dispose().then((_) {
      _barcodeDetector.close();
    });
    super.dispose();
  }

  Receipt? apply(String qr) {
    try {
      final receipt = Receipt.fromQr(qr);
      _db.saveReceipt(receipt, isBudget: true);
      return receipt;
    } catch (_) {}
    return null;
  }

  final _barcodeDetector = GoogleVision.instance.barcodeDetector(
      BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));
  CameraController? _camera;
  bool _isDetecting = false;
  bool _isMounted = true;
  List<Barcode> _scanResults = [];

  List<Barcode> get scanResults => _scanResults;

  CameraController? get camera => _camera;

  Future<void> _initializeCamera() async {
    final description = await _getCamera(CameraLensDirection.back);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.high,
    );
    await _camera?.initialize();

    await _camera?.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      _detect(
        image: image,
        detectInImage: _barcodeDetector.detectInImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (dynamic results) {
          _scanResults = results;
          if (_isMounted) {
            notifyListeners();
          }
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  static Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static Future<dynamic> _detect({
    required CameraImage image,
    required Future<List<Barcode>> Function(GoogleVisionImage image)
        detectInImage,
    required int imageRotation,
  }) async {
    return detectInImage(GoogleVisionImage.fromBytes(
        _concatenatePlanes(image.planes),
        _buildMetaData(image, _rotationIntToImageRotation(imageRotation))));
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static ImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;
    }
  }

  static GoogleVisionImageMetadata _buildMetaData(
    CameraImage image,
    ImageRotation rotation,
  ) {
    return GoogleVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return GoogleVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }
}
