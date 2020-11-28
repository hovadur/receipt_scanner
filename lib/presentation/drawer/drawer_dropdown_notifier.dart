import 'package:ctr/domain/data/repo/settings_repo.dart';
import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/mapper/budget_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class DrawerDropDownNotifier extends ChangeNotifier {
  DrawerDropDownNotifier(this._settingsRepo, this._db);

  final SettingsRepo _settingsRepo;
  final Database _db;
  BudgetUI? _currentBudget;

  BudgetUI? get currentBudget => _currentBudget;

  Stream<List<BudgetUI>> getBudgets(BuildContext context) =>
      _db.getBudgets().asyncMap((budgets) async {
        final currentId = _settingsRepo.getCurrentBudget();
        return budgets.map((budget) {
          final ui = BudgetMapper().map(context, budget);
          if (budget.id == currentId) {
            _currentBudget = ui;
          }
          return ui;
        }).toList();
      });

  void saveCurrentBudget(BudgetUI budget) async {
    await _settingsRepo.setCurrentBudget(budget.id);
    notifyListeners();
  }
}
