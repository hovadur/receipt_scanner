import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/presentation/budgets/budgets_viewmodel.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/common/dismissible_card.dart';
import 'package:ctr/presentation/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'budget_add_screen.dart';
import 'budgets_ui.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({Key? key}) : super(key: key);
  static const String routeName = 'BudgetsScreen';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => BudgetsViewModel(),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(context.translate().budgets),
          ),
          drawer: const MainDrawer(),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: Text(context.translate().addBudget),
            onPressed: () {
              AppNavigator.of(context).push(const MaterialPage<Page>(
                  name: BudgetAddScreen.routeName, child: BudgetAddScreen()));
            },
          ),
          body: StreamBuilder<List<BudgetUI>>(
              stream: context.watch<BudgetsViewModel>().getBudgets(context),
              builder: (context, AsyncSnapshot<List<BudgetUI>> snapshot) {
                if (snapshot.hasError) {
                  return Text(context.translate().wentWrong);
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final value = snapshot.data?[index];
                      return value == null
                          ? const SizedBox()
                          : _buildCardItem(context, value);
                    });
              })));

  Widget _buildCardItem(BuildContext context, BudgetUI value) {
    return DismissibleCard(
      id: value.id,
      confirmDismiss: (_) async {
        if (value.id == '0') {
          final snackBar =
              SnackBar(content: Text(context.translate().cantBeDeleted));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          return true;
        }
      },
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          context.read<BudgetsViewModel>().deleteBudget(value);
        }
      },
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.fact_check)),
        title: Text(value.name),
        trailing: Text(value.sum),
        onTap: () {
          AppNavigator.of(context).push(MaterialPage<Page>(
              name: BudgetAddScreen.routeName,
              child: BudgetAddScreen(item: value.budget)));
        },
      ),
    );
  }
}
