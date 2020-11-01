import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualAddViewModel extends ChangeNotifier {
  String _sumError;
  String _qtyError;
  int _type = 1;
  String name;
  double _qty;
  int _sum;

  String get sumError => _sumError;

  String get qtyError => _qtyError;

  int get type => _type;

  void saveType(int type) {
    _type = type;
    notifyListeners();
  }

  void changeQty(String value, BuildContext context) {
    try {
      final String l = Localizations.localeOf(context).languageCode;
      final num qty = NumberFormat.decimalPattern(l).parse(value);
      _qty = qty.toDouble();
      _qtyError = null;
    } catch (_) {
      _qty = null;
      _qtyError = AppLocalizations.of(context).totalError;
    }
    notifyListeners();
  }

  void changeSum(String value, BuildContext context) {
    try {
      final String l = Localizations.localeOf(context).languageCode;
      final num sum = NumberFormat.decimalPattern(l).parse(value);
      _sum = (sum * 100).toInt();
      _sumError = null;
    } catch (_) {
      _sum = null;
      _sumError = AppLocalizations.of(context).qtyError;
    }
    notifyListeners();
  }

  ReceiptItem addProduct(BuildContext context) {
    return ReceiptItem(_type, name, 0, _qty, _sum);
  }
}
