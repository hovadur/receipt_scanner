import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../presentation/budgets/budgets_ui.dart';

class DrawerDropDown extends ConsumerWidget {
  const DrawerDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(dropDownStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
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
                    value: value,
                    child: _budgetToWidget(context, value)))
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
