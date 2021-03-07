import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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

  final _barcodeDetector =
      GoogleMlKit.instance.barcodeScanner([Barcode.FORMAT_QR_Code]);
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
        detectInImage: _barcodeDetector.processImage,
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
    required Future<dynamic> Function(InputImage image) detectInImage,
    required int imageRotation,
  }) async {
    return detectInImage(InputImage.fromBytes(
        bytes: _concatenatePlanes(image.planes),
        inputImageData: InputImageData(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            imageRotation: _rotationIntToImageRotation(imageRotation))));
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final allBytes = WriteBuffer();
    for (final plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static InputImageRotation _rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return InputImageRotation.Rotation_0deg;
      case 90:
        return InputImageRotation.Rotation_90deg;
      case 180:
        return InputImageRotation.Rotation_180deg;
      default:
        assert(rotation == 270);
        return InputImageRotation.Rotation_270deg;
    }
  }
}
