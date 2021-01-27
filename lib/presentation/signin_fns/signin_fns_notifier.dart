import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';

import '../../domain/data/repo/irkkt_repo.dart';
import '../../domain/data/validation_item.dart';
import '../../domain/string_ext.dart';
import '../../presentation/common/context_ext.dart';

class SignInFnsNotifier extends ChangeNotifier {
  SignInFnsNotifier(this._irkktRepo);

  final IrkktRepo _irkktRepo;
  ValidationItem _inn = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String? get innError => _inn.error;

  String? get passwordError => _password.error;

  void changeEmail(String? value, BuildContext context) {
    if (value != null && value.isValidINN()) {
      _inn = ValidationItem(value, null);
    } else {
      _inn = ValidationItem(value, context.translate().invalidInn);
    }
    notifyListeners();
  }

  void changePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      _password = ValidationItem(value, context.translate().invalidPassword);
    } else {
      _password = ValidationItem(value, null);
    }
    notifyListeners();
  }

  bool _isValid(BuildContext context) {
    changeEmail(_inn.value, context);
    changePassword(_password.value, context);
    if (_inn.error == null && _password.error == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> submit(BuildContext context) async {
    Fimber.d('submit');
    if (_isValid(context)) {
      try {
        await _irkktRepo.login(_inn.value ?? '', _password.value ?? '');
        return true;
      } catch (_) {
        return false;
      }
    } else {
      return false;
    }
  }
}
