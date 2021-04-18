import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/entity/receipt.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/category_screen.dart';
import '../../presentation/common/context_ext.dart';
import 'manual_add_notifier.dart';
import 'manual_add_param.dart';

class ManualAddScreen extends ConsumerWidget {
  const ManualAddScreen({required this.onPressed, this.item, Key? key})
      : super(key: key);
  static const String routeName = 'ManualAddScreen';

  final ValueChanged<ReceiptItem> onPressed;
  final ReceiptItem? item;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = manualAddNotifier(ManualAddParam(context, item));
    return Scaffold(
        appBar: AppBar(
          title: const Text('addProduct').tr(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('cont').tr(),
          onPressed: () => submit(context, notifier),
        ),
        body: SingleChildScrollView(child: _Column(onPressed, item)));
  }

  void submit(BuildContext context,
      ChangeNotifierProvider<ManualAddNotifier> notifier) {
    onPressed(context.read(notifier).getProduct(context));
    AppNavigator.of(context).pop();
  }
}

class _Column extends ConsumerWidget {
  const _Column(this.onPressed, this._item, {Key? key}) : super(key: key);

  final ValueChanged<ReceiptItem> onPressed;
  final ReceiptItem? _item;

  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = manualAddNotifier(ManualAddParam(context, _item));
    final entries = context.category().entries.toList();
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const SizedBox(height: 16),
      ListTile(
        leading: CircleAvatar(
            child: Icon(entries.elementAt(watch(notifier).type).key)),
        title: Text(entries.elementAt(watch(notifier).type).value),
        onTap: () => AppNavigator.of(context).push(MaterialPage<Page>(
            name: CategoryScreen.routeName,
            child: CategoryScreen(
              onPressed: (type) {
                context.read(notifier).saveType(type);
                Navigator.of(context).pop();
              },
            ))),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            TextField(
              controller: watch(notifier).nameController,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'product'.tr()),
              onChanged: (String value) => context.read(notifier).name = value,
            ),
            TextField(
              controller: watch(notifier).qtyController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'qtyy'.tr(), errorText: watch(notifier).qtyError),
              onChanged: (String value) =>
                  context.read(notifier).changeQty(value, context),
            ),
            TextField(
              controller: watch(notifier).sumController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(context, notifier),
              decoration: InputDecoration(
                  labelText: 'sum'.tr(), errorText: watch(notifier).sumError),
              onChanged: (String value) =>
                  context.read(notifier).changeSum(value, context),
            ),
          ]))
    ]);
  }

  void submit(BuildContext context,
      ChangeNotifierProvider<ManualAddNotifier> notifier) {
    onPressed(context.read(notifier).getProduct(context));
    AppNavigator.of(context).pop();
  }
}
