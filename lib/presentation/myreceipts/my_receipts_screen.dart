import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/search.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_module.dart';

class MyReceiptsScreen extends StatelessWidget {
  const MyReceiptsScreen({Key key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => viewModel = MyReceiptsViewModel(),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).myReceipts),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      showSearch(context: context, delegate: Search(context)))
            ],
          ),
          body: StreamBuilder<List<MyReceiptUI>>(
              stream: context.watch<MyReceiptsViewModel>().receipts(context),
              builder: (context, AsyncSnapshot<List<MyReceiptUI>> snapshot) {
                if (snapshot.hasError) {
                  return Text(AppLocalizations.of(context).wentWrong);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final receipt = snapshot.data[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: receipt == null
                              ? Container()
                              : _buildCardItem(context, receipt));
                    });
              })));

  Widget _buildCardItem(BuildContext context, MyReceiptUI receipt) {
    return Dismissible(
        key: Key(receipt.id),
        dragStartBehavior: DragStartBehavior.down,
        direction: DismissDirection.startToEnd,
        background: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Icon(Icons.delete, color: Colors.white),
                  Text(AppLocalizations.of(context).deleteEllipsis,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            )),
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).deleteConfirmation),
                content: Text(AppLocalizations.of(context).sureDelete),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(AppLocalizations.of(context).delete)),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(AppLocalizations.of(context).cancel),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) {
            context.read<MyReceiptsViewModel>().deleteReceipt(receipt);
          }
        },
        child: Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.fact_check)),
            title: Text(receipt.dateTime),
            trailing: Text(receipt.totalSum),
            onTap: () {
              AppNavigator.of(context).push(MaterialPage<Page>(
                  name: ReceiptDetailsScreen.routeName,
                  child: ReceiptDetailsScreen(receipt: receipt.receipt)));
            },
          ),
        ));
  }
}
