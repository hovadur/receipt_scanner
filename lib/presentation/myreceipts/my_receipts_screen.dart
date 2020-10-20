import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/screens/myreceipts/my_receipts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyReceiptsScreen extends StatelessWidget {
  static const String routeName = "MyReceiptsScreen";
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).myReceipts)),
      body: ChangeNotifierProvider(
          create: (_) => MyReceiptsViewModel(),
          builder: (context, _) => FutureBuilder<List<Receipt>>(
              future: context.watch<MyReceiptsViewModel>().receipts(),
              builder: (context, AsyncSnapshot<List<Receipt>> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Receipt receipt = snapshot.data[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Card(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.album),
                                  title: Text(receipt.timestamp.toString()),
                                  subtitle: Text(receipt.totalSum.toString()),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      child: const Text('BUY TICKETS'),
                                      onPressed: () {/* ... */},
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      child: const Text('LISTEN'),
                                      onPressed: () {/* ... */},
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ],
                            )));
                      });
                }
                return LinearProgressIndicator();
              })));
}
