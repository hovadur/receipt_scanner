import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/entity/budget.dart';
import '../../domain/navigation/app_navigator.dart';
import 'budget_add_notifier.dart';
import 'budget_add_param.dart';

class BudgetAddScreen extends StatelessWidget {
  const BudgetAddScreen({this.item, Key? key}) : super(key: key);
  static const String routeName = 'BudgetAddScreen';

  final Budget? item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('addBudget').tr(),
        ),
        body: SingleChildScrollView(child: _Column(item)));
  }
}

class _Column extends ConsumerWidget {
  _Column(this.item, {Key? key}) : super(key: key);

  final Budget? item;

  Widget build(BuildContext context, ScopedReader watch) {
    final notifier = budgetAddNotifier(BudgetAddParam(context, item));
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 32),
          Text('createNewBudget'.tr(), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text('comeUpBudget'.tr(), textAlign: TextAlign.center),
          Text('forExampleBudget'.tr(), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextField(
            controller: watch(notifier).nameController,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'budgetName'.tr()),
            onChanged: (String value) => context.read(notifier).name = value,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: watch(notifier).sumController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => apply(context, notifier),
            decoration: InputDecoration(
                labelText: 'startingBalance'.tr(),
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
                    child: const Text('apply').tr(),
                  ))),
        ]));
  }

  void apply(BuildContext context,
      ChangeNotifierProvider<BudgetAddNotifier> notifier) async {
    await context.read(notifier).apply();
    AppNavigator.of(context).pop();
  }
}
