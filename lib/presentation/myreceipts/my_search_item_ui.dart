import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/receipt.dart';
import '../../presentation/common/context_ext.dart';

class MySearchItemUI {
  MySearchItemUI.fromReceiptItem(BuildContext context, this.item) {
    final locale = Localizations.localeOf(context);
    type = item.type;
    name = item.name;
    final qty = context.translate().qty;
    final qtyNum =
        NumberFormat.decimalPattern(locale.languageCode).format(item.quantity);
    quantity = '$qty $qtyNum';
    sum = NumberFormat.decimalPattern(locale.languageCode)
        .format(item.sum / 100);
  }

  late int type;
  late String name;
  late String quantity;
  late String sum;
  ReceiptItem item;
}
