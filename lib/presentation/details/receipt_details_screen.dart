import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/category_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/details/receipt_details_viewmodel.dart';
import 'package:ctr/presentation/manual/manual_screen.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:ctr/presentation/signin_fns/signin_fns_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  const ReceiptDetailsScreen({@required this.receipt, Key key})
      : super(key: key);

  static const String routeName = 'ReceiptDetails';

  final Receipt receipt;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ReceiptDetailsViewModel(context, receipt),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).details),
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
          body: StreamBuilder<MyReceiptUI>(
              stream: context.watch<ReceiptDetailsViewModel>().getUI(context),
              builder: (context, AsyncSnapshot<MyReceiptUI> snapshot) {
                if (snapshot.hasError) {
                  return Text(AppLocalizations.of(context).wentWrong);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return _streamBody(context, snapshot.data);
              })));

  Widget _streamBody(BuildContext context, MyReceiptUI ui) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _receiptBody(context, ui),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            ListTile(
              leading: Text(AppLocalizations.of(context).total),
              trailing: Text(ui.totalSum),
            ),
            _buildIrkktBody(context),
          ],
        )
      ],
    );
  }

  Widget _buildIrkktBody(BuildContext context) {
    return FutureBuilder<int>(
        future:
            context.watch<ReceiptDetailsViewModel>().getIrkktReceipt(context),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasError) {
            return Text(AppLocalizations.of(context).wentWrong);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 1) {
              return Text(AppLocalizations.of(context).dataReceivedFromFNS);
            }
            if (snapshot.data == 2) {
              return RichText(
                  text: TextSpan(
                      text: AppLocalizations.of(context).dontHaveFnsAccount,
                      style: TextStyle(color: Theme.of(context).errorColor),
                      children: <TextSpan>[_nalogRu(context)]));
            }
            return const SizedBox();
          }
          return Stack(children: [
            const LinearProgressIndicator(),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  child: Text(AppLocalizations.of(context).checkReceiptInFNS),
                ))
          ]);
        });
  }

  TextSpan _nalogRu(BuildContext context) {
    return TextSpan(
        text: AppLocalizations.of(context).nalogruAccount,
        style: const TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: SignInFnsScreen.routeName,
                child: SignInFnsScreen(
                  onPressed: () {
                    context.read<ReceiptDetailsViewModel>().update();
                  },
                )));
          });
  }

  Widget _receiptBody(BuildContext context, MyReceiptUI ui) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text(AppLocalizations.of(context).dateTime),
          trailing: Text(ui.dateTime),
        ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: Text(AppLocalizations.of(context).storage),
            trailing: Text(ui.fn),
          ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: Text(AppLocalizations.of(context).document),
            trailing: Text(ui.fd),
          ),
        if (ui.fn.isNotEmpty)
          ListTile(
            leading: Text(AppLocalizations.of(context).documentAttribute),
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
    final entries = context.category().entries.toList();
    return ListTile(
        leading: InkWell(
          onTap: () => AppNavigator.of(context).push(MaterialPage<Page>(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read<ReceiptDetailsViewModel>().saveType(index, type);
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
