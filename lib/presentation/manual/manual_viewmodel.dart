import 'package:ctr/database.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualViewModel extends ChangeNotifier {
  ManualViewModel(BuildContext context, Receipt receipt) {
    if (receipt != null) {
      final locale = Localizations.localeOf(context);
      _dateTime = receipt.dateTime;
      _products = receipt.items;
      _total = receipt.totalSum;
      _totalController.text = NumberFormat.decimalPattern(locale?.languageCode)
          .format(receipt.totalSum / 100);
    } else {
      _dateTime = DateTime.now();
    }
    _receipt = receipt;
    notifyListeners();
  }

  Receipt _receipt;
  DateTime _dateTime = DateTime.now();
  List<ReceiptItem> _products = [];
  String _totalError;
  int _total = 0;
  final TextEditingController _totalController = TextEditingController();

  TextEditingController get totalController => _totalController;

  DateTime get dateTime => _dateTime;

  int get productCount => _products.length;

  List<MySearchItemUI> getProducts(BuildContext context) => _products
      .map((item) => MySearchItemUI.fromReceiptItem(context, item))
      .toList();

  String get totalError => _totalError;

  void changeTotal(String value, BuildContext context) {
    try {
      final l = Localizations.localeOf(context)?.languageCode;
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

  void changeProduct(ReceiptItem item) {
    final i = _products.indexOf(item);
    _products[i] = item;
    notifyListeners();
  }

  void removeProduct() {
    _products.removeLast();
    notifyListeners();
  }

  bool apply() {
    if (_totalError != null || _total == 0) return false;
    final db = Database();
    if (_receipt == null) {
      final receipt =
          Receipt(dateTime: _dateTime, totalSum: _total, items: _products);
      db.saveReceipt(receipt);
    } else {
      _receipt
        ..dateTime = _dateTime
        ..items = _products
        ..totalSum = _total;
      db.saveReceipt(_receipt);
    }
    return true;
  }
}
