import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/drawer/drawer_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class DrawerViewModel with ChangeNotifier {
  DrawerViewModel(BuildContext context) {
    if (auth.FirebaseAuth.instance.currentUser != null) {
      _ui = DrawerUI(
          email: auth.FirebaseAuth.instance.currentUser.email,
          displayName: auth.FirebaseAuth.instance.currentUser.displayName,
          signOutName: AppLocalizations.of(context).signOut,
          isSignIn: true);
    } else {
      _ui.signOutName = AppLocalizations.of(context).signIn;
    }
    notifyListeners();
  }
  DrawerUI _ui = DrawerUI();
  DrawerUI get ui => _ui;
}
