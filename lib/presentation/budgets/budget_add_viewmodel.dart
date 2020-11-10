import 'package:ctr/domain/entity/budget.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/mapper/budget_mapper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database.dart';

class BudgetAddViewModel extends ChangeNotifier {
  BudgetAddViewModel(BuildContext context, Budget budget) {
    _budget = budget;
    if (budget == null) {
      _sumController.text = '0';
    } else {
      final ui = BudgetMapper().map(context, budget);
      name = _budget.name;
      _nameController.text = name;
      _sum = _budget.sum;
      _sumController.text = ui.sum;
    }
  }

  Budget _budget;
  String _sumError;
  String name = '';
  int _sum = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sumController = TextEditingController();

  TextEditingController get nameController => _nameController;

  TextEditingController get sumController => _sumController;

  String get sumError => _sumError;

  void changeSum(String value, BuildContext context) {
    try {
      final l = Localizations.localeOf(context)?.languageCode;
      final sum = NumberFormat.decimalPattern(l).parse(value);
      _sum = (sum * 100).toInt();
      _sumError = null;
    } catch (_) {
      _sum = 0;
      _sumError = AppLocalizations.of(context).sumError;
    }
    notifyListeners();
  }

  Future<void> apply() async {
    final db = Database();
    if (_budget == null) {
      await db.saveBudget(Budget('', name, _sum));
    } else {
      await db.saveBudget(_budget
        ..name = name
        ..sum = _sum);
    }
  }
}
