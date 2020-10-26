import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/details/receipt_details_viewmodel.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  static const String routeName = 'ReceiptDetails';

  ReceiptDetailsScreen(this.receipt);

  final Receipt receipt;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ReceiptDetailsViewModel(context, receipt),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).details),
          ),
          body: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor)),
              child: _buildBody(context))));

  Widget _buildBody(BuildContext context) {
    final ui = context.watch<ReceiptDetailsViewModel>().ui;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text("Дата покупки"),
          trailing: Text(ui.dateTime),
        ),
        ListTile(
          leading: Text("Накопитель"),
          trailing: Text(ui.fn),
        ),
        ListTile(
          leading: Text("Документ"),
          trailing: Text(ui.fd),
        ),
        ListTile(
          leading: Text("Признак документа"),
          trailing: Text(ui.fpd),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            AppLocalizations.of(context).categorize,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: ui.items.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: _buildItem(context, ui.items[index]));
            }),
        Divider(),
        ListTile(
          leading: Text("Итого"),
          trailing: Text(ui.totalSum),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, MyReceiptItemUI item) {
    return ListTile(
        title: Text(item.quantity),
        subtitle: Text(item.name),
        trailing: Text(item.price));
  }
}
