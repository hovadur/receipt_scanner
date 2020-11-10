import 'package:ctr/domain/entity/budget.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'budget_add_viewmodel.dart';

class BudgetAddScreen extends StatelessWidget {
  const BudgetAddScreen({this.item, Key key}) : super(key: key);
  static const String routeName = 'BudgetAddScreen';

  final Budget item;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => BudgetAddViewModel(context, item),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).addBudget),
          ),
          body: SingleChildScrollView(child: _buildColumn(context))));

  Widget _buildColumn(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 32),
          Text(AppLocalizations.of(context).createNewBudget,
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text(AppLocalizations.of(context).comeUpBudget,
              textAlign: TextAlign.center),
          Text(AppLocalizations.of(context).forExampleBudget,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          TextField(
            controller: context
                .select((BudgetAddViewModel value) => value.nameController),
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).budgetName),
            onChanged: (String value) =>
                context.read<BudgetAddViewModel>().name = value,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: context
                .select((BudgetAddViewModel value) => value.sumController),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => apply(context),
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context).startingBalance,
                errorText: context
                    .select((BudgetAddViewModel value) => value.sumError)),
            onChanged: (String value) =>
                context.read<BudgetAddViewModel>().changeSum(value, context),
          ),
          SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    autofocus: true,
                    onPressed: () => apply(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 4.0),
                    ),
                    child: Text(AppLocalizations.of(context).apply),
                  ))),
        ]));
  }

  void apply(BuildContext context) async {
    await context.read<BudgetAddViewModel>().apply();
    AppNavigator.of(context).pop();
  }
}
