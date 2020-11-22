import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/drawer/drawer_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';

class DrawerNotifier extends ChangeNotifier {
  DrawerNotifier(BuildContext context) {
    final user = context.read(userInteractor).getCurrentUser();
    if (user.id != ' ') {
      _ui = DrawerUI(
          email: user.email,
          displayName: user.name,
          signOutName: context.translate().signOut,
          isSignIn: true);
    } else {
      _ui.signOutName = context.translate().signIn;
    }
    notifyListeners();
  }

  DrawerUI _ui = DrawerUI();

  DrawerUI get ui => _ui;
}
