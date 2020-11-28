import 'package:ctr/app_module.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:ctr/presentation/manual/ManualParam.dart';
import 'package:ctr/presentation/manual/manual_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class ManualScreen extends ConsumerWidget {
  const ManualScreen({Key? key, this.receipt}) : super(key: key);
  static const String routeName = 'ManualScreen';

  final Receipt? receipt;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = manualNotifier(ManualParam(context, receipt));
    return Scaffold(
      appBar: AppBar(title: Text(context.translate().manual)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.approval),
        label: Text(context.translate().apply),
        onPressed: () {
          if (context.read(notifier).apply()) {
            AppNavigator.of(context).pop();
          }
        },
      ),
      body: _buildBody(context, watch),
    );
  }

  Widget _buildBody(BuildContext context, ScopedReader watch) {
    final notifier = manualNotifier(ManualParam(context, receipt));
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            DateTimePicker(
              locale: Localizations.localeOf(context),
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: watch(notifier).dateTime.toString(),
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              onChanged: (String value) =>
                  context.read(notifier).changeDateTime(value),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: watch(notifier).totalController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: context.translate().totalAmount,
                  errorText: watch(notifier).totalError),
              onChanged: (String value) =>
                  context.read(notifier).changeTotal(value, context),
            ),
            const SizedBox(height: 8),
            Row(children: <Widget>[
              ElevatedButton.icon(
                  onPressed: () {
                    AppNavigator.of(context).push(MaterialPage<Page>(
                        name: ManualAddScreen.routeName,
                        child: ManualAddScreen(
                          onPressed: (item) {
                            context.read(notifier).addProduct(item);
                          },
                        )));
                  },
                  icon: const Icon(Icons.add),
                  label: Text(context.translate().product)),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                  onPressed: () => context.read(notifier).removeProduct(),
                  icon: const Icon(Icons.remove),
                  label: Text(context.translate().product)),
            ])
          ])),
      Expanded(
          child: ListView.builder(
              itemCount: watch(notifier).productCount,
              itemBuilder: (BuildContext context, int index) {
                return Builder(
                    builder: (context) => _buildItem(context, index, watch));
              }))
    ]);
  }

  Widget _buildItem(BuildContext context, int index, ScopedReader watch) {
    final notifier = manualNotifier(ManualParam(context, receipt));
    final entries = context.category().entries.toList();
    final item = watch(notifier).getProducts(context)[index];
    return ListTile(
        onTap: () {
          AppNavigator.of(context).push(MaterialPage<Page>(
              name: ManualAddScreen.routeName,
              child: ManualAddScreen(
                onPressed: (item) {
                  context.read(notifier).changeProduct(item);
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
