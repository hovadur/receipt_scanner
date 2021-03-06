import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/receipt.dart';
import '../../presentation/myreceipts/my_search_item_ui.dart';

class ManualAddNotifier extends ChangeNotifier {
  ManualAddNotifier(BuildContext context, ReceiptItem? item) {
    _item = item;
    if (item == null) {
      _qtyController.text = '0';
      _sumController.text = '0';
    } else {
      final myItem = MySearchItemUI.fromReceiptItem(context, item);
      _nameController.text = item.name;
      final locale = context.locale;
      _qtyController.text = NumberFormat.decimalPattern(locale.languageCode)
          .format(item.quantity);
      _sumController.text = myItem.sum;
      _type = item.type;
      name = item.name;
      _qty = item.quantity;
      _sum = item.sum;
    }
  }

  String? _sumError;
  String? _qtyError;
  int _type = 1;
  String name = '';
  num _qty = 0;
  int _sum = 0;
  ReceiptItem? _item;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _sumController = TextEditingController();

  TextEditingController get nameController => _nameController;

  TextEditingController get qtyController => _qtyController;

  TextEditingController get sumController => _sumController;

  String? get sumError => _sumError;

  String? get qtyError => _qtyError;

  int get type => _type;

  void saveType(int type) {
    _type = type;
    notifyListeners();
  }

  void changeQty(String value, BuildContext context) {
    try {
      final l = context.locale.languageCode;
      final qty = NumberFormat.decimalPattern(l).parse(value);
      _qty = qty.toDouble();
      _qtyError = null;
    } catch (_) {
      _qty = 0;
      _qtyError = 'totalError'.tr();
    }
    notifyListeners();
  }

  void changeSum(String value, BuildContext context) {
    try {
      final l = context.locale.languageCode;
      final sum = NumberFormat.decimalPattern(l).parse(value);
      _sum = (sum * 100).toInt();
      _sumError = null;
    } catch (_) {
      _sum = 0;
      _sumError = 'sumError'.tr();
    }
    notifyListeners();
  }

  ReceiptItem getProduct(BuildContext context) {
    final item = _item;
    return item == null ? ReceiptItem(_type, name, 0, _qty, _sum) : item
      ..type = _type
      ..name = name
      ..quantity = _qty
      ..sum = _sum;
  }
}
