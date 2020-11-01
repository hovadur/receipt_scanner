import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'manual_add_screen.dart';
import 'manual_viewmodel.dart';

class ManualScreen extends StatelessWidget {
  static const String routeName = 'ManualScreen';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ManualViewModel(),
      builder: (context, _) => Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).manual)),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.approval),
            label: Text(AppLocalizations.of(context).apply),
            onPressed: () {
              if (context.read<ManualViewModel>().apply()) {
                AppNavigator.of(context).pop();
              }
            },
          ),
          body: SafeArea(
            minimum: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
            child: _buildBody(context),
          )));

  Widget _buildBody(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      DateTimePicker(
        locale: Localizations.localeOf(context),
        type: DateTimePickerType.dateTimeSeparate,
        initialValue: context
            .select((ManualViewModel value) => value.currentDate.toString()),
        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
        lastDate: context.select((ManualViewModel value) => value.currentDate),
        onChanged: (String value) =>
            context.read<ManualViewModel>().changeDateTime(value),
      ),
      const SizedBox(height: 8),
      TextField(
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: AppLocalizations.of(context).totalAmount,
            errorText:
                context.select((ManualViewModel value) => value.totalError)),
        onChanged: (String value) =>
            context.read<ManualViewModel>().changeTotal(value, context),
      ),
      const SizedBox(height: 8),
      Row(children: <Widget>[
        ElevatedButton.icon(
            onPressed: () {
              AppNavigator.of(context).push(MaterialPage(
                  name: ManualAddScreen.routeName,
                  child: ManualAddScreen(
                    onPressed: (item) {
                      context.read<ManualViewModel>().addProduct(item);
                    },
                  )));
              //context.read<ManualViewModel>().addProduct()
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).product)),
        const SizedBox(width: 8),
        ElevatedButton.icon(
            onPressed: () => context.read<ManualViewModel>().removeProduct(),
            icon: const Icon(Icons.remove),
            label: Text(AppLocalizations.of(context).product)),
      ]),
      const SizedBox(height: 8),
      ListView.builder(
          shrinkWrap: true,
          itemCount:
              context.select((ManualViewModel value) => value.productCount),
          itemBuilder: (BuildContext context, int index) {
            return Builder(builder: (context) {
              return _buildItem(context, index);
            });
          })
    ]);
  }

  Widget _buildItem(BuildContext context, int index) {
    final entries = context.category().entries.toList();
    final item = context.watch<ManualViewModel>().getProducts(context)[index];
    return ListTile(
        leading: CircleAvatar(child: Icon(entries.elementAt(item.type).key)),
        title: Text(item.quantity),
        subtitle: Text(item.name),
        trailing: Text(item.sum));
  }
}
