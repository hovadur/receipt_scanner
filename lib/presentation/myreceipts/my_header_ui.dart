import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'my_item_ui.dart';

class MyHeaderUI extends MyItemUI {
  MyHeaderUI(this.dateTime, this.sum);

  DateTime dateTime;
  int sum;

  String getDateTime(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return DateFormat.yMd(locale?.languageCode).format(dateTime);
  }

  String getSum(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return NumberFormat.decimalPattern(locale?.languageCode).format(sum / 100);
  }
}
