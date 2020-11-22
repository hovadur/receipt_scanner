import 'package:ctr/domain/data/validation_item.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

class SignInNotifier extends ChangeNotifier {
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

  void submit(BuildContext context) {
    if (_isValid(context)) {
      Fimber.d('submit');
      final email = _email.value;
      final password = _password.value;
      if (email != null && password != null) {
        context.signIn(email, password);
      }
    }
  }
}