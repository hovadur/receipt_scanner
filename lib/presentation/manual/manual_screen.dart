import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              DateTimePicker(
                locale: Localizations.localeOf(context),
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: DateTime.now().toString(),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: DateTime.now(),
              )
            ]),
          )));
}
