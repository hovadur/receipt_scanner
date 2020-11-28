import 'package:ctr/database.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualNotifier extends ChangeNotifier {
  ManualNotifier(BuildContext context, Receipt? receipt, this._db) {
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

  final Database _db;
  Receipt? _receipt;
  DateTime _dateTime = DateTime.now();
  List<ReceiptItem> _products = [];
  String? _totalError;
  int _total = 0;
  final TextEditingController _totalController = TextEditingController();

  TextEditingController get totalController => _totalController;

  DateTime get dateTime => _dateTime;

  int get productCount => _products.length;

  List<MySearchItemUI> getProducts(BuildContext context) => _products
      .map((item) => MySearchItemUI.fromReceiptItem(context, item))
      .toList();

  String? get totalError => _totalError;

  void changeTotal(String value, BuildContext context) {
    try {
      final l = Localizations.localeOf(context)?.languageCode;
      final total = NumberFormat.decimalPattern(l).parse(value);
      _total = (total * 100).toInt();
      _totalError = null;
    } catch (_) {
      _totalError = context.translate().totalError;
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
    final receipt = _receipt;
    if (receipt == null) {
      final receipt =
          Receipt(dateTime: _dateTime, totalSum: _total, items: _products);
      _db.saveReceipt(receipt, isBudget: true);
    } else {
      _db.deleteReceipt(receipt);
      receipt
        ..dateTime = _dateTime
        ..items = _products
        ..totalSum = _total;
      _db.saveReceipt(receipt, isBudget: true);
    }
    return true;
  }
}
