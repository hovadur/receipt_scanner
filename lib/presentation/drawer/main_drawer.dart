import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/budgets/budgets_screen.dart';
import '../../presentation/camera/camera_screen.dart';
import '../../presentation/myreceipts/my_receipts_screen.dart';
import '../../presentation/signin/signin_screen.dart';
import 'drawer_dropdown.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) =>
      Drawer(child: _listView(context, watch));

  Widget _listView(BuildContext context, ScopedReader watch) {
    final notifier = watch(drawerNotifier);
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _makeHeader(context, watch),
        ListTile(
          title: const Text('scanning').tr(),
          onTap: () {
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: CameraScreen.routeName, child: CameraScreen()));
          },
        ),
        ListTile(
          title: const Text('myReceipts').tr(),
          onTap: () {
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: MyReceiptsScreen.routeName, child: MyReceiptsScreen()));
          },
        ),
        const Divider(),
        ListTile(
          title: const Text('budgets').tr(),
          onTap: () {
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: BudgetsScreen.routeName, child: BudgetsScreen()));
          },
        ),
        const Divider(),
        ListTile(
          title: Text(notifier.ui.signOutName),
          onTap: () {
            context.read(userInteractor).signOut();
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: SignInScreen.routeName, child: SignInScreen()));
          },
        ),
      ],
    );
  }

  Widget _makeHeader(BuildContext context, ScopedReader watch) {
    final notifier = watch(drawerNotifier);
    return notifier.ui.isSignIn
        ? SafeArea(
            child: Center(
                child: Column(children: [
            const SizedBox(height: 16),
            Text(notifier.ui.email),
            const SizedBox(height: 8),
            Text(notifier.ui.displayName),
            const SizedBox(height: 8),
            const DrawerDropDown()
          ])))
        : SafeArea(
            child: Center(
                child: Column(children: [
            const SizedBox(height: 16),
            const Text('notAuthorized').tr()
          ])));
  }
}
