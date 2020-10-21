import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:flutter/material.dart';

class ManualViewModel with ChangeNotifier {
  ManualViewModel() {
    _currentDate = DateTime.now();
    notifyListeners();
  }
  String _totalError;
  DateTime _currentDate = DateTime.now();
  double _total = 0;
  String get totalError => _totalError;
  DateTime get currentDate => _currentDate;
  void changeTotal(String value, context) {
    _total = double.tryParse(value) ?? 0;
    if (_total == 0.0) {
      _totalError = AppLocalizations.of(context).totalError;
    } else
      _totalError = null;
    notifyListeners();
  }

  void changeDateTime(String value) {
    var format = DateFormat('yyyy-MM-dd HH:mm');
    _currentDate = format.parse(value);
    notifyListeners();
  }
}
