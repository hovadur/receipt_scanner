import 'package:ctr/domain/data/validation_item.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:fimber/fimber_base.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel with ChangeNotifier {
  // https://stackoverflow.com/a/32686261/9449426
  final emailCheck = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String get emailError => _email.error;

  String get passwordError => _password.error;

  void changeEmail(String value, context) {
    if (value != null && emailCheck.hasMatch(value)) {
      _email = ValidationItem(value, null);
    } else {
      _email = ValidationItem(value, AppLocalizations.of(context).invalidEmail);
    }
    notifyListeners();
  }

  void changePassword(String value, context) {
    if (value == null || (value != null && value.length < 8)) {
      _password =
          ValidationItem(value, AppLocalizations.of(context).invalidPassword);
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool _isValid(context) {
    changeEmail(_email.value, context);
    changePassword(_password.value, context);
    if (_email.error == null && _password.error == null)
      return true;
    else
      return false;
  }

  void submit(context) {
    if (_isValid(context)) {
      Fimber.d("submit");
    }
  }

  Future<auth.User> signInWithGoogle() async {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    auth.UserCredential authResult =
        await _auth.signInWithCredential(credential);
    var _user = authResult.user;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    auth.User currentUser = _auth.currentUser;
    assert(_user.uid == currentUser.uid);
    Fimber.d("User Name: ${_user.displayName}");
    Fimber.d("User Email ${_user.email}");
    return _user;
  }
}
