import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../database.dart';
import '../../domain/entity/budget.dart';
import '../mapper/budget_mapper.dart';

class BudgetAddNotifier extends ChangeNotifier {
  BudgetAddNotifier(BuildContext context, Budget? budget, this._database) {
    _budget = budget;
    if (budget == null) {
      _sumController.text = '0';
    } else {
      final ui = BudgetMapper().map(context, budget);
      name = _budget?.name ?? '';
      _nameController.text = name;
      _sum = _budget?.sum ?? 0;
      _sumController.text = ui.sum;
    }
  }

  final Database _database;
  Budget? _budget;
  String? _sumError;
  String name = '';
  int _sum = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sumController = TextEditingController();

  TextEditingController get nameController => _nameController;

  TextEditingController get sumController => _sumController;

  String? get sumError => _sumError;

  void changeSum(String value, BuildContext context) {
    try {
      final l = context.locale.languageCode;
      final sum = NumberFormat.decimalPattern(l).parse(value);
      _sum = (sum * 100).toInt();
      _sumError = null;
    } catch (_) {
      _sum = 0;
      _sumError = 'sumError'.tr();
    }
    notifyListeners();
  }

  Future<void> apply() async {
    final budget = _budget;
    if (budget == null) {
      await _database.saveBudget(Budget('', name, _sum));
    } else {
      await _database.saveBudget(budget
        ..name = name
        ..sum = _sum);
    }
  }
}
