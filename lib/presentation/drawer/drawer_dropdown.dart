import 'package:ctr/presentation/budgets/budgets_ui.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'drawer_dropdown_viewmodel.dart';

class DrawerDropDown extends StatelessWidget {
  const DrawerDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => DrawerDropDownViewModel(),
      builder: (context, _) => StreamBuilder<List<BudgetUI>>(
          stream: context.watch<DrawerDropDownViewModel>().getBudgets(context),
          builder: (context, AsyncSnapshot<List<BudgetUI>> snapshot) {
            if (snapshot.hasError) {
              return Text(context.translate().wentWrong);
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            final value = snapshot.data;
            return value == null ? const SizedBox() : _build(context, value);
          }));

  Widget _build(BuildContext context, List<BudgetUI> values) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
            value: context
                .select((DrawerDropDownViewModel value) => value.currentBudget),
            isExpanded: true,
            items: values
                .map((value) => DropdownMenuItem(
                    child: _budgetToWidget(context, value), value: value))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context
                    .read<DrawerDropDownViewModel>()
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
