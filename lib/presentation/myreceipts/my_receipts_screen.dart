import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/common/dismissible_card.dart';
import '../../presentation/copying/copying_screen.dart';
import '../../presentation/details/receipt_details_screen.dart';
import '../../presentation/drawer/main_drawer.dart';
import 'my_header_ui.dart';
import 'my_item_ui.dart';
import 'my_receipt_ui.dart';
import 'search.dart';

class MyReceiptsScreen extends ConsumerWidget {
  const MyReceiptsScreen({Key? key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
      appBar: AppBar(
        title: Text(context.translate().myReceipts),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () =>
                  showSearch(context: context, delegate: Search(context))),
          IconButton(
              icon: const Icon(Icons.file_copy),
              onPressed: () => AppNavigator.of(context).push(
                  const MaterialPage<Page>(
                      name: CopyingScreen.routeName, child: CopyingScreen())))
        ],
      ),
      drawer: const MainDrawer(),
      body: _buildBody(context, watch));

  Widget _buildBody(BuildContext context, ScopedReader watch) {
    final stream = watch(myReceiptsStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => Text(context.translate().wentWrong),
        data: (list) => ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final value = list[index];
              return value == null
                  ? const SizedBox()
                  : _buildCardItem(context, value);
            }));
  }

  Widget _buildCardItem(BuildContext context, MyItemUI value) {
    if (value is MyReceiptUI) {
      return DismissibleCard(
        id: value.id,
        confirmDismiss: (_) async => true,
        onDismissed: (DismissDirection direction) {
          if (direction == DismissDirection.startToEnd) {
            context.read(myReceiptsNotifier).deleteReceipt(value);
          }
        },
        child: ListTile(
          leading: value.items.isEmpty
              ? const CircleAvatar(child: Icon(Icons.approval))
              : const CircleAvatar(child: Icon(Icons.fact_check)),
          title: Text(value.dateTime),
          trailing: Text(value.totalSum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: value.receipt)));
          },
        ),
      );
    } else if (value is MyHeaderUI) {
      return ListTile(
        title: Center(child: Text(value.getDateTime(context))),
        trailing: Text(value.getSum(context)),
      );
    } else
      return const SizedBox();
  }
}
