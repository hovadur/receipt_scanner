import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../mapper/my_receipt_ui.dart';

class MyReceiptsScreen extends StatelessWidget {
  static const String routeName = "MyReceiptsScreen";

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).myReceipts)),
      body: ChangeNotifierProvider(
          create: (_) => MyReceiptsViewModel(),
          builder: (context, _) => FutureBuilder<List<MyReceiptUI>>(
              future: context.watch<MyReceiptsViewModel>().receipts(context),
              builder: (context, AsyncSnapshot<List<MyReceiptUI>> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        MyReceiptUI receipt = snapshot.data[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: _buildCardItem(context, receipt));
                      });
                }
                return LinearProgressIndicator();
              })));

  Widget _buildCardItem(BuildContext context, MyReceiptUI receipt) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.fact_check)),
          title: Text(receipt.dateTime),
          trailing: Text(receipt.totalSum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt.receipt)));
          },
        ),
      ],
    ));
  }
}
