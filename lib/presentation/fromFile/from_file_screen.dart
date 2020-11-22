import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'from_file_viewmodel.dart';

class FromFileScreen extends StatelessWidget {
  const FromFileScreen({Key? key}) : super(key: key);
  static const String routeName = 'FromFileScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(context.translate().fromFile)),
      body: ChangeNotifierProvider(
        create: (_) => FromFileViewModel(),
        builder: (context, _) => Column(
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
              _buildFile(context)
            ]),
      ));

  Widget _buildFile(BuildContext context) {
    final path = context.select((FromFileViewModel value) => value.path);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (path == null) Text(context.translate().noFile),
          if (path != null) Text(path, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          if (path != null)
            ElevatedButton(
                onPressed: () {
                  context.read<FromFileViewModel>().scanImage().then((qr) {
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
      context.read<FromFileViewModel>().changeFile(pickedImage.path);
    }
  }
}
