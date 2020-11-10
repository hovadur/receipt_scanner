import 'package:ctr/domain/entity/budget.dart';
import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetMapper {
  BudgetUI map(BuildContext context, Budget value) {
    final locale = Localizations.localeOf(context);
    final sum = NumberFormat.decimalPattern(locale?.languageCode)
        .format(value.sum / 100);
    return BudgetUI(id: value.id, name: value.name, sum: sum, budget: value);
  }
}
