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

class ReceiptDetailsScreen extends ConsumerWidget {
  const ReceiptDetailsScreen({required this.receipt, Key? key})
      : super(key: key);

  static const String routeName = 'ReceiptDetails';

  final Receipt receipt;

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
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
      body: _streamBody(context, watch));

  Widget _streamBody(BuildContext context, ScopedReader watch) {
    final stream = watch(
        receiptDetailsUIStreamProvider(ReceiptDetailsParam(context, receipt)));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (ui) => Column(
              children: <Widget>[
                Expanded(
                  child: _receiptBody(context, ui),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    ListTile(
                      leading: const Text('total').tr(),
                      trailing: Text(ui.totalSum),
                    ),
                    _buildIrkktBody(context, watch),
                  ],
                )
              ],
            ));
  }

  Widget _buildIrkktBody(BuildContext context, ScopedReader watch) {
    final future = watch(receiptDetailsIrkktFutureProvider(
        ReceiptDetailsParam(context, receipt)));
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
        receiptDetailsNotifier(ReceiptDetailsParam(context, receipt));
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

  Widget _receiptBody(BuildContext context, MyReceiptUI ui) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Text('dateTime').tr(),
          trailing: Text(ui.dateTime),
        ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('storage').tr(),
            trailing: Text(ui.fn),
          ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('document').tr(),
            trailing: Text(ui.fd),
          ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: const Text('documentAttribute').tr(),
            trailing: Text(ui.fpd),
          ),
        Expanded(
            child: ListView.builder(
                itemCount: ui.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _buildItem(context, ui.items[index], index));
                })),
      ],
    );
  }

  Widget _buildItem(BuildContext context, MySearchItemUI item, int index) {
    final notifier =
        receiptDetailsNotifier(ReceiptDetailsParam(context, receipt));
    final entries = context.category().entries.toList();
    return ListTile(
        leading: InkWell(
          onTap: () => AppNavigator.of(context).push(MaterialPage<Page>(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read(notifier).saveType(index, type);
                  Navigator.of(context).pop();
                },
              ))),
          child: CircleAvatar(child: Icon(entries.elementAt(item.type).key)),
        ),
        title: Text(item.quantity),
        subtitle: Text(item.name),
        trailing: Text(item.sum));
  }
}
