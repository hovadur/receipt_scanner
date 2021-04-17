import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/dismissible_card.dart';
import '../../presentation/copying/copying_screen.dart';
import '../../presentation/details/receipt_details_screen.dart';
import '../../presentation/drawer/main_drawer.dart';
import '../../presentation/fromFile/from_file_screen.dart';
import '../../presentation/fromParam/from_param_screen.dart';
import '../../presentation/manual/manual_screen.dart';
import 'my_header_ui.dart';
import 'my_item_ui.dart';
import 'my_receipt_ui.dart';
import 'search.dart';

class MyReceiptsScreen extends StatelessWidget {
  const MyReceiptsScreen({Key? key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, watch, child) => Scaffold(
            appBar: AppBar(
              title: const Text('myReceipts').tr(),
              actions: [
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () =>
                        showSearch(context: context, delegate: Search())),
                IconButton(
                    icon: const Icon(Icons.file_copy),
                    onPressed: () => AppNavigator.of(context).push(
                        const MaterialPage<Page>(
                            name: CopyingScreen.routeName,
                            child: CopyingScreen())))
              ],
            ),
            drawer: const MainDrawer(),
            floatingActionButton: _buildFloatingButton(context),
            body: _buildBody(context, watch)));
  }

  Widget _buildFloatingButton(BuildContext context) {
    return SpeedDial(icon: Icons.add, children: [
      SpeedDialChild(
        label: 'fromFile'.tr(),
        child: Icon(Icons.attach_file),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: FromFileScreen.routeName, child: FromFileScreen()));
        },
      ),
      SpeedDialChild(
        label: 'manual'.tr(),
        child: Icon(Icons.approval),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: ManualScreen.routeName, child: ManualScreen()));
        },
      ),
      SpeedDialChild(
        label: 'fromParam'.tr(),
        child: Icon(Icons.compare_arrows),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: FromParamScreen.routeName, child: FromParamScreen()));
        },
      ),
    ]);
  }

  Widget _buildBody(BuildContext context, ScopedReader watch) {
    final stream = watch(myReceiptsStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (list) => ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final value = list[index];
              return _buildCardItem(context, value);
            }));
  }

  Widget _buildCardItem(BuildContext context, MyItemUI value) {
    if (value is MyReceiptUI) {
      return DismissibleCard(
        id: value.id,
        confirmDismiss: () async => true,
        onDismissed: () {
          context.read(myReceiptsNotifier).deleteReceipt(value);
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
