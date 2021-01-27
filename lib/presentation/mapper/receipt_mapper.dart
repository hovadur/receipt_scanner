import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/receipt.dart';
import '../myreceipts/my_receipt_ui.dart';
import '../myreceipts/my_search_item_ui.dart';

class ReceiptMapper {
  MyReceiptUI map(BuildContext context, Receipt value) {
    final locale = Localizations.localeOf(context);
    final dateTime =
        DateFormat.yMd(locale?.languageCode).add_Hm().format(value.dateTime);
    final totalSum = NumberFormat.decimalPattern(locale?.languageCode)
        .format(value.totalSum / 100);
    return MyReceiptUI(
        id: value.id,
        dateTime: dateTime,
        totalSum: totalSum,
        fn: value.fiscalDriveNumber,
        fd: value.fiscalDocumentNumber.toString(),
        fpd: value.fiscalSign.toString(),
        items: value.items
            .map((item) => MySearchItemUI.fromReceiptItem(context, item))
            .toList(),
        receipt: value);
  }
}
