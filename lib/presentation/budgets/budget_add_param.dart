import 'package:ctr/domain/entity/budget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BudgetAddParam extends Equatable {
  BudgetAddParam(this.context, this.budget);

  final BuildContext context;
  final Budget? budget;

  @override
  List<Object?> get props => [context, budget];
}
