import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/drawer/drawer_ui.dart';
import 'package:flutter/material.dart';

class DrawerViewModel with ChangeNotifier {
  DrawerViewModel(BuildContext context) {
    var user = UserInteractor().getCurrentUser();
    if (user != null) {
      _ui = DrawerUI(
          email: user.email,
          displayName: user.name,
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
