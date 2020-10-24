import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ctr/database.dart';
import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CameraViewModel with ChangeNotifier {
  CameraViewModel() {
    try {
      _initializeCamera();
    } catch (e) {
      Fimber.e(e);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    if (camera != null) _camera.dispose();
    super.dispose();
  }

  CameraController _camera;
  bool _isDetecting = false;
  bool _isMounted = true;
  List<Barcode> _scanResults;

  List<Barcode> get scanResults => _scanResults;

  bool get isMounted => _isMounted;

  CameraController get camera => _camera;

  void _initializeCamera() async {
    final CameraDescription description =
        await _getCamera(CameraLensDirection.back);

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.high,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      final BarcodeDetector _barcodeDetector = FirebaseVision.instance
          .barcodeDetector(
              BarcodeDetectorOptions(barcodeFormats: BarcodeFormat.qrCode));
      _detect(
        image: image,
        detectInImage: _barcodeDetector.detectInImage,
        imageRotation: description.sensorOrientation,
      ).then(
        (List<Barcode> results) {
          _scanResults = results;
          if (_isMounted) {
            notifyListeners();
          }
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  static Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static Future<List<Barcode>> _detect({
    @required CameraImage image,
    @required
        Future<List<Barcode>> Function(FirebaseVisionImage image) detectInImage,
    @required int imageRotation,
  }) async {
    return detectInImage(
      FirebaseVisionImage.fromBytes(
        _concatenatePlanes(image.planes),
        _buildMetaData(image, _rotationIntToImageRotation(imageRotation)),
      ),
    );
  }

  static Uint8List _concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

  static FirebaseVisionImageMetadata _buildMetaData(
    CameraImage image,
    ImageRotation rotation,
  ) {
    return FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
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

  void getTicket(String qr) async {
    Receipt receipt = await IrkktRepo().getTicket(qr);
    Database().saveReceipt(receipt);
  }
}
