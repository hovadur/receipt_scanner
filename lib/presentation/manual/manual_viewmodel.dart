import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';
import 'package:flutter/material.dart';

class ManualViewModel with ChangeNotifier {
  ManualViewModel() {
    _currentDate = DateTime.now();
    notifyListeners();
  }

  DateTime _currentDate = DateTime.now();
  List<ReceiptItem> _products = [];
  String _totalError;
  double _total = 0;

  DateTime get currentDate => _currentDate;

  int get productCount => _products.length;

  List<MyReceiptItemUI> getProducts(BuildContext context) => _products
      .map((item) => MyReceiptItemUI.fromReceiptItem(context, item))
      .toList();

  String get totalError => _totalError;

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

  void addProduct(ReceiptItem item) {
    _products.add(item);
    notifyListeners();
  }

  void removeProduct() {
    _products.removeLast();
    notifyListeners();
  }

  void apply() {}
}
