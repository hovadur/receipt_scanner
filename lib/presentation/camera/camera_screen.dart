import 'package:camera/camera.dart';
import 'package:ctr/domain/data/barcode_detector_painter.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/drawer/main_drawer.dart';
import 'package:ctr/presentation/fromFile/from_file_screen.dart';
import 'package:ctr/presentation/fromParam/from_param_screen.dart';
import 'package:ctr/presentation/manual/manual_screen.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const String routeName = 'CameraScreen';

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer(
      builder: (context, watch, child) => Scaffold(
          appBar: AppBar(title: Text(context.translate().scanning)),
          drawer: const MainDrawer(),
          floatingActionButton: FloatingActionBubble(
              animation: _animation,
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),
              iconData: Icons.add,
              items: <Bubble>[
                Bubble(
                  title: context.translate().fromFile,
                  icon: Icons.attach_file,
                  onPress: () {
                    AppNavigator.of(context).push(const MaterialPage<Page>(
                        name: FromFileScreen.routeName,
                        child: FromFileScreen()));
                  },
                ),
                Bubble(
                  title: context.translate().manual,
                  icon: Icons.approval,
                  iconColor: Colors.white,
                  onPress: () {
                    AppNavigator.of(context).push(const MaterialPage<Page>(
                        name: ManualScreen.routeName, child: ManualScreen()));
                  },
                ),
                Bubble(
                  title: context.translate().fromParam,
                  icon: Icons.compare_arrows,
                  onPress: () {
                    AppNavigator.of(context).push(const MaterialPage<Page>(
                        name: FromParamScreen.routeName,
                        child: FromParamScreen()));
                  },
                ),
              ]),
          body: Container(
              constraints: const BoxConstraints.expand(),
              child: _buildPreview(context, watch))));

  Widget _buildPreview(BuildContext context, ScopedReader watch) {
    final camera = watch(cameraNotifier).camera;
    if (camera == null) {
      return Center(
        child: Text(
          context.translate().cameraInit,
          style: const TextStyle(color: Colors.green, fontSize: 30.0),
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
