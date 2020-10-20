import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class DrawerViewModel with ChangeNotifier {
  DrawerViewModel(BuildContext context) {
    if (auth.FirebaseAuth.instance.currentUser != null) {
      _email = auth.FirebaseAuth.instance.currentUser.email;
      _displayName = auth.FirebaseAuth.instance.currentUser.displayName;
      _signOutName = AppLocalizations.of(context).signOut;
      _isSignIn = true;
      notifyListeners();
    } else {
      _signOutName = AppLocalizations.of(context).signIn;
    }

  }
  String _email = '';
  String _displayName = '';
  String _signOutName = '';
  bool _isSignIn = false;
  String get email => _email;
  String get displayName => _displayName;
  String get signOutName => _signOutName;
  bool get isSignIn => _isSignIn;
}
