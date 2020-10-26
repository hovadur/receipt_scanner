import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReceiptItemUI {
  String name;
  String quantity;
  String price;

  MyReceiptItemUI.fromReceiptItem(BuildContext context, ReceiptItem item)
      : name = item.name,
        quantity =
            AppLocalizations.of(context).qty + ' ' + item.quantity.toString(),
        price = NumberFormat.decimalPattern(
                Localizations.localeOf(context).languageCode)
            .format(item.price / 100);
}
