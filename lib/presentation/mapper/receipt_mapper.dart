import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            .map((item) => MyReceiptItemUI.fromReceiptItem(context, item))
            .toList(),
        receipt: value);
  }
}
