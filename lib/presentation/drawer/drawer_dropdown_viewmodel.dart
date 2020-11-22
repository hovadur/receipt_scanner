import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/mapper/budget_mapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database.dart';

class DrawerDropDownViewModel extends ChangeNotifier {
  final Database _db = Database();
  BudgetUI? _currentBudget;

  BudgetUI? get currentBudget => _currentBudget;

  Stream<List<BudgetUI>> getBudgets(BuildContext context) =>
      _db.getBudgets().asyncMap((budgets) async {
        final prefs = await SharedPreferences.getInstance();
        final currentId = prefs.getString('currentBudget') ?? '0';
        return budgets.map((budget) {
          final ui = BudgetMapper().map(context, budget);
          if (budget.id == currentId) {
            _currentBudget = ui;
          }
          return ui;
        }).toList();
      });

  void saveCurrentBudget(BudgetUI budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentBudget', budget.id);
    notifyListeners();
  }
}
