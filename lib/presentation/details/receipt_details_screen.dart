import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/categorize/category_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
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
          leading: Text(AppLocalizations.of(context).dateTime),
          trailing: Text(ui.dateTime),
        ),
        ListTile(
          leading: Text(AppLocalizations.of(context).storage),
          trailing: Text(ui.fn),
        ),
        ListTile(
          leading: Text(AppLocalizations.of(context).document),
          trailing: Text(ui.fd),
        ),
        ListTile(
          leading: Text(AppLocalizations.of(context).documentAttribute),
          trailing: Text(ui.fpd),
        ),
        InkWell(
          onTap: () => AppNavigator.of(context).push(MaterialPage(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read<ReceiptDetailsViewModel>().saveTypeAll(type);
                  Navigator.of(context).pop();
                },
              ))),
          child: Text(
            AppLocalizations.of(context).categoryAll,
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
                  child: _buildItem(context, ui.items[index], index));
            }),
        Divider(),
        ListTile(
          leading: Text(AppLocalizations.of(context).total),
          trailing: Text(ui.totalSum),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, MyReceiptItemUI item, int index) {
    final entries = context.category().entries.toList();
    return ListTile(
        leading: InkWell(
          child: CircleAvatar(child: Icon(entries.elementAt(item.type).key)),
          onTap: () => AppNavigator.of(context).push(MaterialPage(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read<ReceiptDetailsViewModel>().saveType(index, type);
                  Navigator.of(context).pop();
                },
              ))),
        ),
        title: Text(item.quantity),
        subtitle: Text(item.name),
        trailing: Text(item.sum));
  }
}
