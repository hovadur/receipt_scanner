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
      builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).manual)),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            icon: Icon(Icons.approval),
            label: Text(AppLocalizations.of(context).apply),
            onPressed: () {
              context.read<ManualViewModel>().apply();
            },
          ),
          body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              DateTimePicker(
                locale: Localizations.localeOf(context),
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: context.select(
                    (ManualViewModel value) => value.currentDate.toString()),
                firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                lastDate: context
                    .select((ManualViewModel value) => value.currentDate),
                onChanged: (String value) =>
                    context.read<ManualViewModel>().changeDateTime(value),
              ),
              SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).total,
                    errorText: context
                        .select((ManualViewModel value) => value.totalError)),
                onChanged: (String value) =>
                    context.read<ManualViewModel>().changeTotal(value, context),
              ),
              SizedBox(height: 8),
              Row(children: <Widget>[
                ElevatedButton.icon(
                    onPressed: () =>
                        context.read<ManualViewModel>().addProduct(),
                    icon: Icon(Icons.add),
                    label: Text(AppLocalizations.of(context).product)),
                SizedBox(width: 8),
                ElevatedButton.icon(
                    onPressed: () =>
                        context.read<ManualViewModel>().removeProduct(),
                    icon: Icon(Icons.remove),
                    label: Text(AppLocalizations.of(context).product)),
              ]),
              SizedBox(height: 8),
              Expanded(
                  child: ListView.builder(
                      itemCount: context.select(
                          (ManualViewModel value) => value.productCount),
                      itemBuilder: (BuildContext context, int index) {
                        return Builder(builder: (context) {
                          return _buildItem(index, context);
                        });
                      }))
            ]),
          )));
  Widget _buildItem(int index, BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).product),
                onChanged: (String value) => context
                    .read<ManualViewModel>()
                    .changeProductValue(value, index),
              ),
              const SizedBox(width: 8),
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).price,
                    errorText: context.select(
                        (ManualViewModel value) => value.productError[index])),
                onChanged: (String value) => context
                    .read<ManualViewModel>()
                    .changeProductPrice(value, index, context),
              ),
              const SizedBox(width: 8),
            ],
          )));
}
