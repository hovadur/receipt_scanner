import 'package:ctr/domain/data/validation_item.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class SignInNotifier extends ChangeNotifier {
  SignInNotifier(this._userInteractor);

  final UserInteractor _userInteractor;

  // https://stackoverflow.com/a/32686261/9449426
  final emailCheck = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String? get emailError => _email.error;

  String? get passwordError => _password.error;

  void changeEmail(String? value, BuildContext context) {
    if (value != null && emailCheck.hasMatch(value)) {
      _email = ValidationItem(value, null);
    } else {
      _email = ValidationItem(value, context.translate().invalidEmail);
    }
    notifyListeners();
  }

  void changePassword(String? value, BuildContext context) {
    if (value == null || value.length < 8) {
      _password = ValidationItem(value, context.translate().invalidPassword);
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool _isValid(BuildContext context) {
    changeEmail(_email.value, context);
    changePassword(_password.value, context);
    if (_email.error == null && _password.error == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> submit(BuildContext context) async {
    if (_isValid(context)) {
      Fimber.d('submit');
      final email = _email.value;
      final password = _password.value;
      if (email != null && password != null) {
        final user = await _userInteractor.signIn(email, password);
        await Database().createUser(user);
        //context.signIn(email, password);
      }
    }
  }

  Future<bool> googleSignIn() async {
    final user = await _userInteractor.signInWithGoogle();
    if (user != null) {
      await Database().createUser(user);
      return true;
    }
    return false;
  }
}
