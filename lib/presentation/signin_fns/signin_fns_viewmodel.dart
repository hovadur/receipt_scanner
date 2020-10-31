import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/data/validation_item.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/domain/string_ext.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

class SignInFnsViewModel with ChangeNotifier {
  ValidationItem _inn = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String get innError => _inn.error;

  String get passwordError => _password.error;

  void changeEmail(String value, context) {
    if (value != null && value.isValidINN()) {
      _inn = ValidationItem(value, null);
    } else {
      _inn = ValidationItem(value, AppLocalizations.of(context).invalidInn);
    }
    notifyListeners();
  }

  void changePassword(String value, context) {
    if (value == null || value.isEmpty) {
      _password =
          ValidationItem(value, AppLocalizations.of(context).invalidPassword);
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool _isValid(context) {
    changeEmail(_inn.value, context);
    changePassword(_password.value, context);
    if (_inn.error == null && _password.error == null)
      return true;
    else
      return false;
  }

  bool submit(context) {
    Fimber.d("submit");
    if (_isValid(context)) {
      try {
        IrkktRepo().login(_inn.value, _password.value);
        return true;
      } catch (_) {
        return false;
      }
    } else
      return false;
  }
}
