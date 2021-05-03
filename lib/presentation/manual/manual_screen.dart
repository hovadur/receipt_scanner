import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receipt_scanner/presentation/manual/manual_notifier.dart';

import '../../app_module.dart';
import '../../domain/entity/receipt.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import 'manual_add_screen.dart';
import 'manual_param.dart';

class ManualScreen extends StatelessWidget {
  const ManualScreen({Key? key, this.receipt}) : super(key: key);
  static const String routeName = 'ManualScreen';

  final Receipt? receipt;

  @override
  Widget build(BuildContext context) {
    final notifier = manualNotifier(ManualParam(context, receipt));
    return Scaffold(
      appBar: AppBar(title: const Text('manual').tr()),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.approval),
        label: const Text('apply').tr(),
        onPressed: () {
          if (context.read(notifier).apply()) {
            AppNavigator.of(context).pop();
          }
        },
      ),
      body: _Body(notifier),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this._notifier, {Key? key}) : super(key: key);
  final ChangeNotifierProvider<ManualNotifier> _notifier;

  Widget build(BuildContext context, ScopedReader watch) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            DateTimePicker(
              locale: context.locale,
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: watch(_notifier).dateTime.toString(),
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
              onChanged: (String value) =>
                  context.read(_notifier).changeDateTime(value),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: watch(_notifier).totalController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'totalAmount'.tr(),
                  errorText: watch(_notifier).totalError),
              onChanged: (String value) =>
                  context.read(_notifier).changeTotal(value, context),
            ),
            const SizedBox(height: 8),
            _Row(_notifier),
          ])),
      Expanded(
          child: ListView.builder(
              itemCount: watch(_notifier).productCount,
              itemBuilder: (BuildContext context, int index) {
                return Builder(builder: (context) => _Item(_notifier, index));
              }))
    ]);
  }
}

class _Row extends StatelessWidget {
  const _Row(this._notifier, {Key? key}) : super(key: key);
  final ChangeNotifierProvider<ManualNotifier> _notifier;

  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      ElevatedButton.icon(
          onPressed: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ManualAddScreen.routeName,
                child: ManualAddScreen(
                  onPressed: (item) {
                    context.read(_notifier).addProduct(item);
                  },
                )));
          },
          icon: const Icon(Icons.add),
          label: const Text('product').tr()),
      const SizedBox(width: 8),
      ElevatedButton.icon(
          onPressed: () => context.read(_notifier).removeProduct(),
          icon: const Icon(Icons.remove),
          label: const Text('product').tr()),
    ]);
  }
}

class _Item extends StatelessWidget {
  const _Item(this._notifier, this._index, {Key? key}) : super(key: key);
  final ChangeNotifierProvider<ManualNotifier> _notifier;
  final int _index;

  Widget build(BuildContext context) {
    final entries = context.category().entries.toList();
    final item = context.read(_notifier).getProducts(context)[_index];
    return ListTile(
        onTap: () {
          AppNavigator.of(context).push(MaterialPage<Page>(
              name: ManualAddScreen.routeName,
              child: ManualAddScreen(
                onPressed: (item) {
                  context.read(_notifier).changeProduct(item);
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
