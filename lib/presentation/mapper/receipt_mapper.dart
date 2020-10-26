import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ReceiptMapper {
  MyReceiptUI map(BuildContext context, Receipt value) {
    final locale = Localizations.localeOf(context);
    final dateTime = DateFormat('MMM dd, yyyy - HH:mm', locale.languageCode)
        .format(value.dateTime);
    final totalSum = NumberFormat.compactCurrency(locale: locale.languageCode)
        .format(value.totalSum / 100);
    return MyReceiptUI(
        dateTime: dateTime,
        totalSum: totalSum,
        fn: value.fiscalDriveNumber,
        fd: value.fiscalDocumentNumber.toString(),
        fpd: value.fiscalSign.toString(),
        items: value.items
            .map((item) => MyReceiptItemUI.fromReceiptItem(context, item))
            .toList(),
        receipt: value);
  }
}
