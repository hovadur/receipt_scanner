import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/interactor/user_interactor.dart';
import '../../presentation/drawer/drawer_ui.dart';

class DrawerNotifier extends ChangeNotifier {
  DrawerNotifier(UserInteractor userInteractor) {
    final user = userInteractor.getCurrentUser();
    if (user.id != ' ') {
      _ui = DrawerUI(
          email: user.email,
          displayName: user.name,
          signOutName: 'signOut'.tr(),
          isSignIn: true);
    } else {
      _ui.signOutName = 'signIn'.tr();
    }
    notifyListeners();
  }

  DrawerUI _ui = DrawerUI();

  DrawerUI get ui => _ui;
}
