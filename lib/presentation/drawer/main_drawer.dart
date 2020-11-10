import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/budgets/budgets_screen.dart';
import 'package:ctr/presentation/camera/camera_screen.dart';
import 'package:ctr/presentation/drawer/drawer_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_screen.dart';
import 'package:ctr/presentation/signin/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => DrawerViewModel(context),
      builder: (context, _) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _makeHeader(context),
                ListTile(
                  title: Text(AppLocalizations.of(context).scanning),
                  onTap: () {
                    AppNavigator.of(context).clearAndPush(
                        const MaterialPage<Page>(
                            name: CameraScreen.routeName,
                            child: CameraScreen()));
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).myReceipts),
                  onTap: () {
                    AppNavigator.of(context).clearAndPush(
                        const MaterialPage<Page>(
                            name: MyReceiptsScreen.routeName,
                            child: MyReceiptsScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context).budgets),
                  onTap: () {
                    AppNavigator.of(context).clearAndPush(
                        const MaterialPage<Page>(
                            name: BudgetsScreen.routeName,
                            child: BudgetsScreen()));
                  },
                ),
                const Divider(),
                ListTile(
                  title: Text(context.watch<DrawerViewModel>().ui.signOutName),
                  onTap: () {
                    context.read<UserInteractor>().signOut();
                    AppNavigator.of(context).clearAndPush(
                        const MaterialPage<Page>(
                            name: SignInScreen.routeName,
                            child: SignInScreen()));
                  },
                ),
              ],
            ),
          ));

  Widget _makeHeader(BuildContext context) {
    if (context.watch<DrawerViewModel>().ui.isSignIn) {
      return UserAccountsDrawerHeader(
          accountEmail: Text(context.watch<DrawerViewModel>().ui.email),
          accountName: Text(context.watch<DrawerViewModel>().ui.displayName));
    } else {
      return DrawerHeader(
          child: Text(AppLocalizations.of(context).notAuthorized));
    }
  }
}
