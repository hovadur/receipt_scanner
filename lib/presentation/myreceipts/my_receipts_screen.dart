import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReceiptsScreen extends StatelessWidget {
  const MyReceiptsScreen({Key key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).myReceipts)),
      body: ChangeNotifierProvider(
          create: (_) => MyReceiptsViewModel(),
          builder: (context, _) => StreamBuilder<List<MyReceiptUI>>(
              stream: context.watch<MyReceiptsViewModel>().receipts(context),
              builder: (context, AsyncSnapshot<List<MyReceiptUI>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final MyReceiptUI receipt = snapshot.data[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: _buildCardItem(context, receipt));
                    });
              })));

  Widget _buildCardItem(BuildContext context, MyReceiptUI receipt) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.fact_check)),
          title: Text(receipt.dateTime),
          trailing: Text(receipt.totalSum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: receipt.receipt)));
          },
        ),
      ],
    ));
  }
}
