import '../../domain/entity/budget.dart';

class BudgetUI {
  BudgetUI(
      {required this.id,
      required this.name,
      required this.sum,
      required this.budget});

  String id;
  String name;
  String sum;
  Budget budget;
}
