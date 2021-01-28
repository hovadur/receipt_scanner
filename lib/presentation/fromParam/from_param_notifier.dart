import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database.dart';
import '../../domain/entity/receipt.dart';
import '../../presentation/common/context_ext.dart';

class FromParamNotifier extends ChangeNotifier {
  FromParamNotifier(this._db);

  final Database _db;
  DateTime _dateTime = DateTime.now();
  String? _totalError;
  int _total = 0;
  String fn = '';
  String fd = '';
  String fpd = '';

  DateTime get dateTime => _dateTime;

  String? get totalError => _totalError;

  void changeDateTime(String value) {
    final format = DateFormat('yyyy-MM-dd HH:mm');
    _dateTime = format.parse(value);
    notifyListeners();
  }

  void changeTotal(String value, BuildContext context) {
    try {
      final l = Localizations.localeOf(context).languageCode;
      final total = NumberFormat.decimalPattern(l).parse(value);
      _total = (total * 100).toInt();
      _totalError = null;
    } catch (_) {
      _totalError = context.translate().totalError;
    }
    notifyListeners();
  }

  //t=20200727T1117&s=4850.00&fn=9287440300634471&i=13571&fp=3730902192&n=1
  Receipt? apply() {
    try {
      final month = _dateTime.month.toString().padLeft(2, '0');
      final day = _dateTime.day.toString().padLeft(2, '0');
      final hour = _dateTime.hour.toString().padLeft(2, '0');
      final minute = _dateTime.minute.toString().padLeft(2, '0');
      final total = _total.toString();
      final totalFirst = total.substring(0, total.length - 2);
      final totalEnd = total.substring(total.length - 2, total.length);
      final s =
          't=${_dateTime.year}$month${day}T$hour$minute&s=$totalFirst.$totalEnd&fn=$fn&i=$fd&fp=$fpd&n=1';
      final receipt = Receipt.fromQr(s);
      _db.saveReceipt(receipt, isBudget: true);
      return receipt;
    } catch (_) {}
    return null;
  }
}
