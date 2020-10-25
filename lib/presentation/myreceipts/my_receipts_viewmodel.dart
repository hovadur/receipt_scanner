import 'package:ctr/presentation/common/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database.dart';
import 'my_receipt_ui.dart';

class MyReceiptsViewModel with ChangeNotifier {
  Future<List<MyReceiptUI>> receipts(Locale locale) =>
      Database().getReceipts().then((value) => value.map((item) {
            final dateTime =
                DateFormat('MMM dd, yyyy - HH:mm', locale.languageCode)
                    .format(item.dateTime);
            final totalSum =
                NumberFormat.compactCurrency(locale: locale.languageCode)
                    .format(item.totalSum / 100);
            return MyReceiptUI(dateTime: dateTime, totalSum: totalSum);
          }).toList());
}
