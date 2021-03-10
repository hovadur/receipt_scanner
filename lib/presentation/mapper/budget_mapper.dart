import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/budget.dart';
import '../budgets/budgets_ui.dart';

class BudgetMapper {
  BudgetUI map(BuildContext context, Budget value) {
    if (value.name == 'Personal') {
      value.name = 'personal'.tr();
    }
    final sum = NumberFormat.simpleCurrency(
            locale: context.locale.languageCode, name: '')
        .format(value.sum / 100);
    return BudgetUI(id: value.id, name: value.name, sum: sum, budget: value);
  }
}
