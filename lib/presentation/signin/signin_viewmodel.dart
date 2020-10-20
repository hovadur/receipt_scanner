import 'package:ctr/domain/data/validation_item.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

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
}