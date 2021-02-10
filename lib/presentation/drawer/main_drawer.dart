import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/budgets/budgets_screen.dart';
import '../../presentation/camera/camera_screen.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/myreceipts/my_receipts_screen.dart';
import '../../presentation/signin/signin_screen.dart';
import 'drawer_dropdown.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) =>
      Drawer(child: _listView(context, watch));

  Widget _listView(BuildContext context, ScopedReader watch) {
    final notifier = watch(drawerNotifier(context));
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _makeHeader(context, watch),
        ListTile(
          title: Text(context.translate().scanning),
          onTap: () {
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: CameraScreen.routeName, child: CameraScreen()));
          },
        ),
        ListTile(
          title: Text(context.translate().myReceipts),
          onTap: () {
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: MyReceiptsScreen.routeName, child: MyReceiptsScreen()));
          },
        ),
        const Divider(),
        ListTile(
          title: Text(context.translate().budgets),
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
    final notifier = watch(drawerNotifier(context));
    if (notifier.ui.isSignIn) {
      return SafeArea(
          child: Center(
              child: Column(children: [
        const SizedBox(height: 16),
        Text(notifier.ui.email),
        const SizedBox(height: 8),
        Text(notifier.ui.displayName),
        const SizedBox(height: 8),
        const DrawerDropDown(),
      ])));
    } else {
      return SafeArea(
          child: Center(
              child: Column(children: [
        const SizedBox(height: 16),
        Text(context.translate().notAuthorized)
      ])));
    }
  }
}
