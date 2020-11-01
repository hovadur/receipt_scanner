import 'package:camera/camera.dart';
import 'package:ctr/domain/data/barcode_detector_painter.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/camera/camera_viewmodel.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/drawer/drawer.dart';
import 'package:ctr/presentation/manual/manual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key key}) : super(key: key);
  static const String routeName = 'CameraScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).scanning)),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context).manual),
        onPressed: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: ManualScreen.routeName, child: ManualScreen()));
        },
      ),
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
          AppLocalizations.of(context).cameraInit,
          style: const TextStyle(
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
    if (scanResults == null || !camera.value.isInitialized) {
      return noResultsText;
    }

    final Size imageSize = Size(
      camera.value.previewSize.height,
      camera.value.previewSize.width,
    );
    if (scanResults.isEmpty) {
      return CustomPaint(
          painter: BarcodeDetectorPainter(imageSize, scanResults));
    } else {
      final qr = scanResults[0].rawValue;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (AppNavigator.of(context).getLast().name !=
            ReceiptDetailsScreen.routeName) {
          try {
            final receipt = Receipt.fromQr(qr);
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: receipt)));
          } catch (_) {}
        }
      });
      return Text(qr);
    }
  }
}
