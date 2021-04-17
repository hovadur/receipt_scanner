import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import '../../database.dart';
import '../../domain/data/validation_item.dart';
import '../../domain/interactor/user_interactor.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier(this._userInteractor, this._db);

  final UserInteractor _userInteractor;
  final Database _db;

  // https://stackoverflow.com/a/32686261/9449426
  final emailCheck = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String? get emailError => _email.error;

  String? get passwordError => _password.error;

  void changeEmail(String? value) {
    _email = value != null && emailCheck.hasMatch(value)
        ? ValidationItem(value, null)
        : ValidationItem(value, 'invalidEmail'.tr());
    notifyListeners();
  }

  void changePassword(String? value) {
    _password = value == null || value.length < 8
        ? ValidationItem(value, 'invalidPassword'.tr())
        : ValidationItem(value, null);
    notifyListeners();
  }

  bool _isValid() {
    changeEmail(_email.value);
    changePassword(_password.value);
    return _email.error == null && _password.error == null ? true : false;
  }

  Future<void> submit() async {
    if (_isValid()) {
      Fimber.d('submit');
      final email = _email.value;
      final password = _password.value;
      if (email != null && password != null) {
        final user = await _userInteractor.signIn(email, password);
        await _db.createUser(user);
        //context.signIn(email, password);
      }
    }
  }

  Future<bool> googleSignIn() async {
    final user = await _userInteractor.signInWithGoogle();
    if (user != null) {
      await _db.createUser(user);
      return true;
    }
    return false;
  }
}
