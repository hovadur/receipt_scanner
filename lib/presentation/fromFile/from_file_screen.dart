import 'dart:io';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_module.dart';
import '../../domain/entity/receipt.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/details/receipt_details_screen.dart';

class FromFileScreen extends ConsumerWidget {
  const FromFileScreen({Key? key}) : super(key: key);
  static const String routeName = 'FromFileScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
        appBar: AppBar(title: Text(context.translate().fromFile)),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                context.translate().emailCheque,
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    _getAndScanImage(context);
                  },
                  child: Text(context.translate().uploadFile)),
              const SizedBox(height: 8),
              _buildFile(context, watch)
            ]),
      );

  Widget _buildFile(BuildContext context, ScopedReader watch) {
    final path = watch(fromFileNotifier).path;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (path == null) Text(context.translate().noFile),
          if (path != null)
            Image.file(File(path), fit: BoxFit.cover, width: 100),
          const SizedBox(height: 8),
          if (path != null)
            ElevatedButton(
                onPressed: () {
                  context.read(fromFileNotifier).scanImage().then((qr) {
                    if (qr == null) {
                      context.showError(context.translate().invalidBarcode);
                    } else {
                      final receipt = Receipt.fromQr(qr);
                      AppNavigator.of(context).push(MaterialPage<Page>(
                          name: ReceiptDetailsScreen.routeName,
                          child: ReceiptDetailsScreen(receipt: receipt)));
                    }
                  }).catchError((e) {
                    context.showError(context.translate().invalidBarcode);
                    Fimber.e(e.toString());
                  });
                },
                child: Text(context.translate().processFile)),
        ]);
  }

  Future<void> _getAndScanImage(BuildContext context) async {
    final _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      context.read(fromFileNotifier).changeFile(pickedImage.path);
    }
  }
}
