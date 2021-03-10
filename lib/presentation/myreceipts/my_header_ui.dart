import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'my_item_ui.dart';

class MyHeaderUI extends MyItemUI {
  MyHeaderUI(this.dateTime, this.sum);

  DateTime dateTime;
  int sum;

  String getDateTime(BuildContext context) {
    return DateFormat.yMMMMd(context.locale.languageCode).format(dateTime);
  }

  String getSum(BuildContext context) {
    return NumberFormat.decimalPattern(context.locale.languageCode)
        .format(sum / 100);
  }
}
