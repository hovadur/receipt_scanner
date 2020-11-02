import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceiptItemUI {
  MyReceiptItemUI.fromReceiptItem(BuildContext context, ReceiptItem item) {
    final locale = Localizations.localeOf(context);
    type = item.type;
    name = item.name;
    final qty = AppLocalizations.of(context).qty;
    final qtyNum =
        NumberFormat.decimalPattern(locale?.languageCode).format(item.quantity);
    quantity = '$qty $qtyNum';
    sum = NumberFormat.decimalPattern(locale?.languageCode)
        .format(item.sum / 100);
  }

  int type;
  String name;
  String quantity;
  String sum;
}
