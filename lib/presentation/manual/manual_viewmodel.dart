import 'package:ctr/database.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';
import 'package:flutter/material.dart';

class ManualViewModel extends ChangeNotifier {
  ManualViewModel() {
    _dateTime = DateTime.now();
    notifyListeners();
  }

  DateTime _dateTime = DateTime.now();
  final List<ReceiptItem> _products = [];
  String _totalError;
  int _total = 0;

  DateTime get currentDate => _dateTime;

  int get productCount => _products.length;

  List<MyReceiptItemUI> getProducts(BuildContext context) => _products
      .map((item) => MyReceiptItemUI.fromReceiptItem(context, item))
      .toList();

  String get totalError => _totalError;

  void changeTotal(String value, BuildContext context) {
    try {
      final l = Localizations.localeOf(context).languageCode;
      final total = NumberFormat.decimalPattern(l).parse(value);
      _total = (total * 100).toInt();
      _totalError = null;
    } catch (_) {
      _totalError = AppLocalizations.of(context).totalError;
    }
    notifyListeners();
  }

  void changeDateTime(String value) {
    final format = DateFormat('yyyy-MM-dd HH:mm');
    _dateTime = format.parse(value);
    notifyListeners();
  }

  void addProduct(ReceiptItem item) {
    _products.add(item);
    notifyListeners();
  }

  void removeProduct() {
    _products.removeLast();
    notifyListeners();
  }

  bool apply() {
    if (_totalError != null || _total == 0) return false;
    final receipt =
        Receipt(dateTime: _dateTime, totalSum: _total, items: _products);
    Database().saveReceipt(receipt);
    return true;
  }
}
