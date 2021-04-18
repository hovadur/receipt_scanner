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
        data: (value) => _Item(value));
  }
}

class _Item extends ConsumerWidget {
  const _Item(this._values, {Key? key}) : super(key: key);
  final List<BudgetUI> _values;

  Widget build(BuildContext context, ScopedReader watch) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
            value: watch(drawerDropDownNotifier).currentBudget,
            isExpanded: true,
            items: _values
                .map((value) => DropdownMenuItem(
                    value: value, child: _BudgetToWidget(value)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context
                    .read(drawerDropDownNotifier)
                    .saveCurrentBudget(value as BudgetUI);
              }
            }));
  }
}

class _BudgetToWidget extends StatelessWidget {
  const _BudgetToWidget(this._value, {Key? key}) : super(key: key);
  final BudgetUI _value;

  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryVariant;
    return Center(
        child: Column(
      children: [
        Text(_value.name),
        Text(_value.sum, style: TextStyle(color: color))
      ],
    ));
  }
}
