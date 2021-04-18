import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
        appBar: AppBar(title: const Text('fromFile').tr()),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text(
                'emailCheque'.tr(),
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 8),
              ElevatedButton(
                  onPressed: () {
                    _getAndScanImage(context);
                  },
                  child: const Text('uploadFile').tr()),
              const SizedBox(height: 8),
              _File()
            ]),
      );

  Future<void> _getAndScanImage(BuildContext context) async {
    final _picker = ImagePicker();
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      context.read(fromFileNotifier).changeFile(pickedImage.path);
    }
  }
}

class _File extends ConsumerWidget {
  const _File({Key? key}) : super(key: key);
  Widget build(BuildContext context, ScopedReader watch) {
    final path = watch(fromFileNotifier).path;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (path == null) const Text('noFile').tr(),
          if (path != null)
            Image.file(File(path), fit: BoxFit.cover, width: 100),
          const SizedBox(height: 8),
          if (path != null)
            ElevatedButton(
                onPressed: () {
                  context.read(fromFileNotifier).scanImage().then((qr) {
                    if (qr == null) {
                      context.showError('invalidBarcode'.tr());
                    } else {
                      final receipt = Receipt.fromQr(qr);
                      AppNavigator.of(context).push(MaterialPage<Page>(
                          name: ReceiptDetailsScreen.routeName,
                          child: ReceiptDetailsScreen(receipt: receipt)));
                    }
                  }).catchError((e) {
                    context.showError('invalidBarcode'.tr());
                    Fimber.e(e.toString());
                  });
                },
                child: const Text('processFile').tr()),
        ]);
  }
}
