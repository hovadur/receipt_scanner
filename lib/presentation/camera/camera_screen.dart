import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/data/barcode_detector_painter.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/details/receipt_details_screen.dart';
import '../../presentation/drawer/main_drawer.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const String routeName = 'CameraScreen';

  @override
  Widget build(BuildContext context) => Consumer(
      builder: (context, watch, child) => Scaffold(
          appBar: AppBar(title: const Text('scanning').tr()),
          drawer: const MainDrawer(),
          body: Container(
              constraints: const BoxConstraints.expand(),
              child: _buildPreview(context, watch))));

  Widget _buildPreview(BuildContext context, ScopedReader watch) {
    final camera = watch(cameraNotifier).camera;

    return camera == null
        ? Center(
            child: Text('cameraInit'.tr(),
                style: const TextStyle(color: Colors.green, fontSize: 30.0)))
        : Stack(fit: StackFit.expand, children: <Widget>[
            CameraPreview(camera),
            _buildResults(camera, context, watch)
          ]);
  }

  Widget _buildResults(
      CameraController camera, BuildContext context, ScopedReader watch) {
    const noResultsText = Text('No results!');
    final scanResults = watch(cameraNotifier).scanResults;
    if (!camera.value.isInitialized) {
      return noResultsText;
    }

    final imageSize = Size(
      camera.value.previewSize?.height ?? 0,
      camera.value.previewSize?.width ?? 0,
    );
    if (scanResults.isEmpty) {
      return CustomPaint(
          painter: BarcodeDetectorPainter(imageSize, scanResults));
    } else {
      final qr = scanResults[0].barcodeUnknown?.rawValue ?? '';
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        if (AppNavigator.of(context).getLast().name !=
            ReceiptDetailsScreen.routeName) {
          final receipt = context.read(cameraNotifier).apply(qr);
          if (receipt != null) {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: receipt)));
          }
        }
      });
      return Text(qr);
    }
  }
}
