import 'package:flutter/material.dart';

import '../../database.dart';
import '../../presentation/budgets/budgets_ui.dart';
import '../../presentation/mapper/budget_mapper.dart';
import 'budgets_ui.dart';

class BudgetsNotifier extends ChangeNotifier {
  BudgetsNotifier(this._db);

  final Database _db;

  Stream<List<BudgetUI>> getBudgets(BuildContext context) =>
      _db.getBudgets().map((budgets) => budgets.map((budget) {
            return BudgetMapper().map(context, budget);
          }).toList());

  void deleteBudget(BudgetUI value) {
    _db.deleteBudget(value.budget);
  }
}
