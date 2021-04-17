import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

import '../../domain/data/repo/irkkt_repo.dart';
import '../../domain/data/validation_item.dart';
import '../../domain/string_ext.dart';

class SignInFnsNotifier extends ChangeNotifier {
  SignInFnsNotifier(this._irkktRepo);

  final IrkktRepo _irkktRepo;
  ValidationItem _inn = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);

  String? get innError => _inn.error;

  String? get passwordError => _password.error;

  void changeEmail(String? value) {
    _inn = value != null && value.isValidINN()
        ? ValidationItem(value, null)
        : ValidationItem(value, 'invalidInn'.tr());
    notifyListeners();
  }

  void changePassword(String? value) {
    _password = value == null || value.isEmpty
        ? ValidationItem(value, 'invalidPassword'.tr())
        : ValidationItem(value, null);
    notifyListeners();
  }

  bool _isValid() {
    changeEmail(_inn.value);
    changePassword(_password.value);
    return _inn.error == null && _password.error == null ? true : false;
  }

  Future<bool> submit() async {
    Fimber.d('submit');
    if (_isValid()) {
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
