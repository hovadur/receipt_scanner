import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/budget.dart';

class BudgetAddParam extends Equatable {
  BudgetAddParam(this.context, this.budget);

  final BuildContext context;
  final Budget? budget;

  @override
  List<Object?> get props => [context, budget];
}
