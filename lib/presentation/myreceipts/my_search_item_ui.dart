import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/receipt.dart';

class MySearchItemUI {
  MySearchItemUI.fromReceiptItem(BuildContext context, this.item) {
    final locale = context.locale;
    type = item.type;
    name = item.name;
    final qty = 'qty'.tr();
    final qtyNum =
        NumberFormat.decimalPattern(locale.languageCode).format(item.quantity);
    quantity = '$qty $qtyNum';
    sum =
        NumberFormat.decimalPattern(locale.languageCode).format(item.sum / 100);
  }

  late int type;
  late String name;
  late String quantity;
  late String sum;
  ReceiptItem item;
}
