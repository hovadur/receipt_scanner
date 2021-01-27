import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';
import '../../domain/entity/budget.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import 'budget_add_notifier.dart';
import 'budget_add_param.dart';

class BudgetAddScreen extends ConsumerWidget {
  const BudgetAddScreen({this.item, Key? key}) : super(key: key);
  static const String routeName = 'BudgetAddScreen';

  final Budget? item;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.translate().addBudget),
        ),
        body: SingleChildScrollView(child: _buildColumn(context, watch)));
  }

  Widget _buildColumn(BuildContext context, ScopedReader watch) {
    final notifier = budgetAddNotifier(BudgetAddParam(context, item));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 32),
          Text(context.translate().createNewBudget,
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text(context.translate().comeUpBudget, textAlign: TextAlign.center),
          Text(context.translate().forExampleBudget,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextField(
            controller: watch(notifier).nameController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            decoration:
                InputDecoration(labelText: context.translate().budgetName),
            onChanged: (String value) => context.read(notifier).name = value,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: watch(notifier).sumController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => apply(context, notifier),
            decoration: InputDecoration(
                labelText: context.translate().startingBalance,
                errorText: watch(notifier).sumError),
            onChanged: (String value) =>
                context.read(notifier).changeSum(value, context),
          ),
          SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    autofocus: true,
                    onPressed: () => apply(context, notifier),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 4.0),
                    ),
                    child: Text(context.translate().apply),
                  ))),
        ]));
  }

  void apply(BuildContext context,
      ChangeNotifierProvider<BudgetAddNotifier> notifier) async {
    await context.read(notifier).apply();
    AppNavigator.of(context).pop();
  }
}
