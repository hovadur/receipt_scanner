import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/budgets/budgets_screen.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/drawer/drawer_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_screen.dart';
import 'package:ctr/presentation/signin/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer_dropdown.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => DrawerViewModel(context),
      builder: (context, _) => Drawer(child: _listView(context)));

  Widget _listView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _makeHeader(context),
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
          title: Text(context.watch<DrawerViewModel>().ui.signOutName),
          onTap: () {
            context.read<UserInteractor>().signOut();
            AppNavigator.of(context).clearAndPush(const MaterialPage<Page>(
                name: SignInScreen.routeName, child: SignInScreen()));
          },
        ),
      ],
    );
  }

  Widget _makeHeader(BuildContext context) {
    if (context.watch<DrawerViewModel>().ui.isSignIn) {
      return SafeArea(
          child: Center(
              child: Column(children: [
        const SizedBox(height: 16),
        Text(context.watch<DrawerViewModel>().ui.email),
        Text(context.watch<DrawerViewModel>().ui.displayName),
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
