import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/drawer/drawer_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_screen.dart';
import 'package:ctr/presentation/signin/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => DrawerViewModel(context),
      builder: (context, _) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _makeHeader(context),
                ListTile(
                  title: Text(AppLocalizations.of(context).myReceipts),
                  onTap: () {
                    AppNavigator.of(context).push(MaterialPage(
                        name: MyReceiptsScreen.routeName,
                        child: MyReceiptsScreen()));
                  },
                ),
                ListTile(
                  title: Text(context
                      .select((DrawerViewModel value) => value.signOutName)),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    AppNavigator.of(context).clearAndPush(MaterialPage(
                        name: SignInScreen.routeName, child: SignInScreen()));
                  },
                ),
              ],
            ),
          ));
  Widget _makeHeader(BuildContext context) {
    if (context.select((DrawerViewModel value) => value.isSignIn)) {
      return UserAccountsDrawerHeader(
          accountEmail:
              Text(context.select((DrawerViewModel value) => value.email)),
          accountName: Text(
              context.select((DrawerViewModel value) => value.displayName)));
    } else {
      return DrawerHeader(
          child: Text(AppLocalizations.of(context).notAuthorized));
    }
  }
}
