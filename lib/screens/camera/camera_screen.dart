import 'package:camera/camera.dart';
import 'package:ctr/domain/data/barcode_detector_painter.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/screens/camera/camera_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).scanning)),
      body: ChangeNotifierProvider(
          create: (_) => CameraViewModel(),
          builder: (context, _) => Container(
              constraints: const BoxConstraints.expand(),
              child: _buildPreview(context))));

  Widget _buildPreview(BuildContext context) {
    final camera = context.select((CameraViewModel value) => value.camera);
    if (camera == null) {
      return Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
          ),
        ),
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(camera),
          _buildResults(camera, context),
        ],
      );
    }
  }

  Widget _buildResults(CameraController camera, BuildContext context) {
    const Text noResultsText = Text('No results!');
    final scanResults =
        context.select((CameraViewModel value) => value.scanResults);
    if (scanResults == null || !camera.value.isInitialized ) {
      return noResultsText;
    }

    final Size imageSize = Size(
      camera.value.previewSize.height,
      camera.value.previewSize.width,
    );
    return CustomPaint(painter: BarcodeDetectorPainter(imageSize, scanResults));
  }
}
