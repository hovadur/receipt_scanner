import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/entity/receipt.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/category_screen.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/details/receipt_details_param.dart';
import '../../presentation/manual/manual_screen.dart';
import '../../presentation/myreceipts/my_receipt_ui.dart';
import '../../presentation/myreceipts/my_search_item_ui.dart';
import '../../presentation/signin_fns/signin_fns_screen.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  const ReceiptDetailsScreen({required this.receipt, Key? key})
      : super(key: key);
  static const String routeName = 'ReceiptDetails';
  final Receipt receipt;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('details').tr(),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                AppNavigator.of(context).push(MaterialPage<Page>(
                    name: ManualScreen.routeName,
                    child: ManualScreen(receipt: receipt)));
              })
        ],
      ),
      body: _Body(receipt));
}

class _Body extends ConsumerWidget {
  const _Body(this._receipt, {Key? key}) : super(key: key);
  final Receipt _receipt;
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(
        receiptDetailsUIStreamProvider(ReceiptDetailsParam(context, _receipt)));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (ui) => Column(
              children: <Widget>[
                Expanded(
                  child: _ReceiptBody(_receipt, ui),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    ListTile(
                      leading: const Text('total').tr(),
                      trailing: Text(ui.totalSum),
                    ),
                    _IrkktBody(_receipt),
                  ],
                )
              ],
            ));
  }
}

class _IrkktBody extends ConsumerWidget {
  const _IrkktBody(this._receipt, {Key? key}) : super(key: key);
  final Receipt _receipt;

  Widget build(BuildContext context, ScopedReader watch) {
    final future = watch(receiptDetailsIrkktFutureProvider(
        ReceiptDetailsParam(context, _receipt)));
    return future.when(
        loading: () => Stack(children: [
              const LinearProgressIndicator(),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    child: const Text('checkReceiptInFNS').tr(),
                  ))
            ]),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (value) {
          if (value == 1) {
            return const Text('dataReceivedFromFNS').tr();
          }
          if (value == 3) {
            return const Text('tooManyRequests').tr();
          }
          if (value == 2) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                    text: TextSpan(
                        text: 'dontHaveFnsAccount'.tr(),
                        style: TextStyle(color: Theme.of(context).errorColor),
                        children: <TextSpan>[_nalogRu(context)])));
          }
          return const SizedBox();
        });
  }

  TextSpan _nalogRu(BuildContext context) {
    final notifier =
        receiptDetailsNotifier(ReceiptDetailsParam(context, _receipt));
    return TextSpan(
        text: 'nalogruAccount'.tr(),
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: SignInFnsScreen.routeName,
                child: SignInFnsScreen(
                  onPressed: () => context.read(notifier).update(),
                )));
          });
  }
}

class _ReceiptBody extends StatelessWidget {
  const _ReceiptBody(this._receipt, this._ui, {Key? key}) : super(key: key);
  final Receipt _receipt;
  final MyReceiptUI _ui;
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Text('dateTime').tr(),
          trailing: Text(_ui.dateTime),
        ),
        if (_ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('storage').tr(),
            trailing: Text(_ui.fn),
          ),
        if (_ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('document').tr(),
            trailing: Text(_ui.fd),
          ),
        if (_ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('documentAttribute').tr(),
            trailing: Text(_ui.fpd),
          ),
        Expanded(
            child: ListView.builder(
                itemCount: _ui.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _Item(_receipt, _ui.items[index], index));
                })),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(this._receipt, this._item, this._index, {Key? key})
      : super(key: key);
  final Receipt _receipt;
  final MySearchItemUI _item;
  final int _index;

  Widget build(BuildContext context) {
    final notifier =
        receiptDetailsNotifier(ReceiptDetailsParam(context, _receipt));
    final entries = context.category().entries.toList();
    return ListTile(
        leading: InkWell(
          onTap: () => AppNavigator.of(context).push(MaterialPage<Page>(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read(notifier).saveType(_index, type);
                  Navigator.of(context).pop();
                },
              ))),
          child: CircleAvatar(child: Icon(entries.elementAt(_item.type).key)),
        ),
        title: Text(_item.quantity),
        subtitle: Text(_item.name),
        trailing: Text(_item.sum));
  }
}
