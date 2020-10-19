import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/screens/myreceipts/my_receipts_screen.dart';
import 'package:ctr/screens/signin/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider(
      create: (_) => UserInteractor(),
      builder: (context, _) => Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountEmail: Text(
                        context.watch<UserInteractor>().getCurrentUser().email),
                    accountName: Text(
                        context.watch<UserInteractor>().getCurrentUser().name)),
                ListTile(
                  title: Text(AppLocalizations.of(context).myReceipts),
                  onTap: () {
                    AppNavigator.of(context).push(MaterialPage(
                        name: MyReceiptsScreen.routeName, child: MyReceiptsScreen()));
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).signOut),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    AppNavigator.of(context).clearAndPush(MaterialPage(
                        name: SignInScreen.routeName, child: SignInScreen()));
                  },
                ),
              ],
            ),
          ));
}
