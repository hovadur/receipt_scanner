import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/mapper/budget_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class BudgetsViewModel extends ChangeNotifier {
  final Database _db = Database();

  Stream<List<BudgetUI>> getBudgets(BuildContext context) =>
      _db.getBudgets().map((budgets) => budgets.map((budget) {
            if (budget.name == 'Personal') {
              budget.name = AppLocalizations.of(context).personal;
            }
            return BudgetMapper().map(context, budget);
          }).toList());

  void deleteBudget(BudgetUI value) {
    _db.deleteBudget(value.budget);
  }
}