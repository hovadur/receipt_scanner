import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:flutter/material.dart';

class ManualViewModel with ChangeNotifier {
  ManualViewModel() {
    _currentDate = DateTime.now();
    _products.add(Product(null, 0, null));
    notifyListeners();
  }
  DateTime _currentDate = DateTime.now();
  List<Product> _products = [];
  String _totalError;
  double _total = 0;
  DateTime get currentDate => _currentDate;
  int get productCount => _products.length;
  String get totalError => _totalError;
  List<String> get productError => _products.map((e) => e.error).toList();
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

  void changeProductValue(String value, int index) {
    _products[index].name = value;
  }

  void changeProductPrice(String value, int index, context) {
    var price = double.tryParse(value) ?? 0;
    var p = _products[index];
    if (price == 0.0) {
      p.error = AppLocalizations.of(context).totalError;
    } else {
      p.error = null;
      p.price = price;
    }
    notifyListeners();
  }

  void addProduct() {
    _products.add(Product(null, 0, null));
    notifyListeners();
  }

  void removeProduct() {
    if (productCount != 1) _products.removeLast();
    notifyListeners();
  }

  void apply() {}
}

class Product {
  Product(this.name, this.price, this.error);
  String name;
  double price;
  String error;
}
