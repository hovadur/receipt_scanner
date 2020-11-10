import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/dismissible_card.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/search.dart';
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
                      final value = snapshot.data[index];
                      return value == null
                          ? const SizedBox()
                          : _buildCardItem(context, value);
                    });
              })));

  Widget _buildCardItem(BuildContext context, MyReceiptUI value) {
    return DismissibleCard(
      id: value.id,
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          context.read<MyReceiptsViewModel>().deleteReceipt(value);
        }
      },
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.fact_check)),
        title: Text(value.dateTime),
        trailing: Text(value.totalSum),
        onTap: () {
          AppNavigator.of(context).push(MaterialPage<Page>(
              name: ReceiptDetailsScreen.routeName,
              child: ReceiptDetailsScreen(receipt: value.receipt)));
        },
      ),
    );
  }
}
