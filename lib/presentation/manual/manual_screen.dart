import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:ctr/presentation/manual/manual_add_screen.dart';
import 'package:ctr/presentation/manual/manual_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({Key key, this.receipt}) : super(key: key);
  static const String routeName = 'ManualScreen';

  final Receipt receipt;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ManualViewModel(context, receipt),
      builder: (context, _) => Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context).manual)),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.approval),
              label: Text(AppLocalizations.of(context).apply),
              onPressed: () {
                if (context.read<ManualViewModel>().apply()) {
                  AppNavigator.of(context).pop();
                }
              },
            ),
            body: _buildBody(context),
          ));

  Widget _buildBody(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            DateTimePicker(
              locale: Localizations.localeOf(context),
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: context
                  .select((ManualViewModel value) => value.dateTime.toString()),
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              onChanged: (String value) =>
                  context.read<ManualViewModel>().changeDateTime(value),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: context
                  .select((ManualViewModel value) => value.totalController),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).totalAmount,
                  errorText: context
                      .select((ManualViewModel value) => value.totalError)),
              onChanged: (String value) =>
                  context.read<ManualViewModel>().changeTotal(value, context),
            ),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              ElevatedButton.icon(
                  onPressed: () {
                    AppNavigator.of(context).push(MaterialPage<Page>(
                        name: ManualAddScreen.routeName,
                        child: ManualAddScreen(
                          onPressed: (item) {
                            context.read<ManualViewModel>().addProduct(item);
                          },
                        )));
                  },
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).product)),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                  onPressed: () =>
                      context.read<ManualViewModel>().removeProduct(),
                  icon: const Icon(Icons.remove),
                  label: Text(AppLocalizations.of(context).product)),
            ])
          ])),
      Expanded(
          child: ListView.builder(
              itemCount:
                  context.select((ManualViewModel value) => value.productCount),
              itemBuilder: (BuildContext context, int index) {
                return Builder(
                    builder: (context) => _buildItem(context, index));
              }))
    ]);
  }

  Widget _buildItem(BuildContext context, int index) {
    final entries = context.category().entries.toList();
    final item = context.watch<ManualViewModel>().getProducts(context)[index];
    return ListTile(
        onTap: () {
          AppNavigator.of(context).push(MaterialPage<Page>(
              name: ManualAddScreen.routeName,
              child: ManualAddScreen(
                onPressed: (item) {
                  context.read<ManualViewModel>().changeProduct(item);
                },
                item: item.item,
              )));
        },
        leading: CircleAvatar(child: Icon(entries.elementAt(item.type).key)),
        title: Text(item.quantity),
        subtitle: Text(item.name),
        trailing: Text(item.sum));
  }
}
