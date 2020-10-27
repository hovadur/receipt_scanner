import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceiptItemUI {
  int type;
  String name;
  String quantity;
  String price;

  MyReceiptItemUI.fromReceiptItem(BuildContext context, ReceiptItem item) {
    final locale = Localizations.localeOf(context);
    type = item.type;
    name = item.name;
    quantity = AppLocalizations.of(context).qty +
        ' ' +
        NumberFormat.decimalPattern(locale.languageCode).format(item.quantity);
    price = NumberFormat.decimalPattern(locale.languageCode)
        .format(item.price / 100);
  }
}
