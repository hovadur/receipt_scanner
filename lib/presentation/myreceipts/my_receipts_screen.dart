import 'package:easy_localization/easy_localization.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class MyReceiptsScreen extends HookWidget {
  const MyReceiptsScreen({Key? key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context) {
    final _animationController = useAnimationController(
        duration: const Duration(milliseconds: 260), initialValue: 0);

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    final _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
            floatingActionButton:
                _buildFloatingButton(context, _animation, _animationController),
            body: _buildBody(context, watch)));
  }

  Widget _buildFloatingButton(BuildContext context, Animation animation,
      AnimationController animationController) {
    return FloatingActionBubble(
        animation: animation,
        onPress: () => animationController.isCompleted
            ? animationController.reverse()
            : animationController.forward(),
        iconData: Icons.add,
        items: <Bubble>[
          Bubble(
            title: 'fromFile'.tr(),
            icon: Icons.attach_file,
            onPress: () {
              AppNavigator.of(context).push(const MaterialPage<Page>(
                  name: FromFileScreen.routeName, child: FromFileScreen()));
            },
          ),
          Bubble(
            title: 'manual'.tr(),
            icon: Icons.approval,
            onPress: () {
              AppNavigator.of(context).push(const MaterialPage<Page>(
                  name: ManualScreen.routeName, child: ManualScreen()));
            },
          ),
          Bubble(
            title: 'fromParam'.tr(),
            icon: Icons.compare_arrows,
            onPress: () {
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
