import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';
import '../../presentation/budgets/budgets_ui.dart';
import '../../presentation/common/context_ext.dart';

class DrawerDropDown extends ConsumerWidget {
  const DrawerDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(dropDownStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => Text(context.translate().wentWrong),
        data: (value) => _build(context, watch, value));
  }

  Widget _build(
      BuildContext context, ScopedReader watch, List<BudgetUI> values) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
            value: watch(drawerDropDownNotifier).currentBudget,
            isExpanded: true,
            items: values
                .map((value) => DropdownMenuItem(
                    child: _budgetToWidget(context, value), value: value))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context
                    .read(drawerDropDownNotifier)
                    .saveCurrentBudget(value as BudgetUI);
              }
            }));
  }

  Widget _budgetToWidget(BuildContext context, BudgetUI value) {
    final color = Theme.of(context).colorScheme.primaryVariant;
    return Center(
        child: Column(
      children: [
        Text(value.name),
        Text(value.sum, style: TextStyle(color: color))
      ],
    ));
  }
}
