import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'manual_viewmodel.dart';

class ManualScreen extends StatelessWidget {
  static const String routeName = "ManualScreen";
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ManualViewModel(),
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context).manual)),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text(AppLocalizations.of(context).addProduct),
          onPressed: () {},
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InputDatePickerFormField(firstDate: DateTime.now(), lastDate: DateTime.now())
        ]),
      ));
}
