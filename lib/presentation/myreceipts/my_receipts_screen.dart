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
  Widget build(BuildContext context) => Scaffold(
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
                      name: CopyingScreen.routeName, child: CopyingScreen())))
        ],
      ),
      drawer: const MainDrawer(),
      floatingActionButton: _FloatingButton(),
      body: _Body());
}

class _FloatingButton extends StatelessWidget {
  _FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryVariant;
    return SpeedDial(icon: Icons.add, backgroundColor: color, children: [
      SpeedDialChild(
        label: 'fromFile'.tr(),
        backgroundColor: color,
        child: Icon(Icons.attach_file),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: FromFileScreen.routeName, child: FromFileScreen()));
        },
      ),
      SpeedDialChild(
        label: 'manual'.tr(),
        backgroundColor: color,
        child: Icon(Icons.approval),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: ManualScreen.routeName, child: ManualScreen()));
        },
      ),
      SpeedDialChild(
        label: 'fromParam'.tr(),
        backgroundColor: color,
        child: Icon(Icons.compare_arrows),
        onTap: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: FromParamScreen.routeName, child: FromParamScreen()));
        },
      ),
    ]);
  }
}

class _Body extends ConsumerWidget {
  _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(myReceiptsStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (list) => ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final value = list[index];
              return _CardItem(value);
            }));
  }
}

class _CardItem extends StatelessWidget {
  final MyItemUI _cardItem;
  _CardItem(this._cardItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_cardItem is MyReceiptUI) {
      final value = _cardItem as MyReceiptUI;
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
    } else if (_cardItem is MyHeaderUI) {
      final value = _cardItem as MyHeaderUI;
      return ListTile(
        title: Center(child: Text(value.getDateTime(context))),
        trailing: Text(value.getSum(context)),
      );
    } else
      return const SizedBox();
  }
}
