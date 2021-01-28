import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/budget.dart';
import '../../presentation/common/context_ext.dart';
import '../budgets/budgets_ui.dart';

class BudgetMapper {
  BudgetUI map(BuildContext context, Budget value) {
    if (value.name == 'Personal') {
      value.name = context.translate().personal;
    }
    final locale = Localizations.localeOf(context);
    final sum =
        NumberFormat.simpleCurrency(locale: locale.languageCode, name: '')
            .format(value.sum / 100);
    return BudgetUI(id: value.id, name: value.name, sum: sum, budget: value);
  }
}
