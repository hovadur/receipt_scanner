import 'package:camera/camera.dart';
import 'package:ctr/domain/data/barcode_detector_painter.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/drawer/main_drawer.dart';
import 'package:ctr/presentation/fromFile/from_file_screen.dart';
import 'package:ctr/presentation/fromParam/from_param_screen.dart';
import 'package:ctr/presentation/manual/manual_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';

class CameraScreen extends ConsumerWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const String routeName = 'CameraScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
      appBar: AppBar(title: Text(context.translate().scanning)),
      drawer: const MainDrawer(),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.add),
          label: Text(context.translate().fromFile),
          onPressed: () {
            AppNavigator.of(context).push(const MaterialPage<Page>(
                name: FromFileScreen.routeName, child: FromFileScreen()));
          },
        ),
        const SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.add),
          label: Text(context.translate().manual),
          onPressed: () {
            AppNavigator.of(context).push(const MaterialPage<Page>(
                name: ManualScreen.routeName, child: ManualScreen()));
          },
        ),
        const SizedBox(height: 8),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.add),
          label: Text(context.translate().fromParam),
          onPressed: () {
            AppNavigator.of(context).push(const MaterialPage<Page>(
                name: FromParamScreen.routeName, child: FromParamScreen()));
          },
        ),
      ]),
      body: Container(
          constraints: const BoxConstraints.expand(),
          child: _buildPreview(context, watch)));

  Widget _buildPreview(BuildContext context, ScopedReader watch) {
    final camera = watch(cameraNotifier).camera;
    if (camera == null) {
      return Center(
        child: Text(
          context.translate().cameraInit,
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
          _buildResults(camera, context, watch),
        ],
      );
    }
  }

  Widget _buildResults(
      CameraController camera, BuildContext context, ScopedReader watch) {
    const noResultsText = Text('No results!');
    final scanResults = watch(cameraNotifier).scanResults;
    if (!camera.value.isInitialized) {
      return noResultsText;
    }

    final imageSize = Size(
      camera.value.previewSize.height,
      camera.value.previewSize.width,
    );
    if (scanResults.isEmpty) {
      return CustomPaint(
          painter: BarcodeDetectorPainter(imageSize, scanResults));
    } else {
      final qr = scanResults[0].rawValue;
      SchedulerBinding.instance?.addPostFrameCallback((_) {
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
