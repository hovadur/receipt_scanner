import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/dismissible_card.dart';
import '../../presentation/drawer/main_drawer.dart';
import 'budget_add_screen.dart';
import 'budgets_ui.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({Key? key}) : super(key: key);
  static const String routeName = 'BudgetsScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
      appBar: AppBar(
        title: const Text('budgets').tr(),
      ),
      drawer: const MainDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('addBudget').tr(),
        onPressed: () {
          AppNavigator.of(context).push(const MaterialPage<Page>(
              name: BudgetAddScreen.routeName, child: BudgetAddScreen()));
        },
      ),
      body: _streamBody(context, watch));

  Widget _streamBody(BuildContext context, ScopedReader watch) {
    final stream = watch(budgetsStreamProvider(context));
    return stream.when(
        loading: () => const LinearProgressIndicator(),
        error: (_, __) => const Text('wentWrong').tr(),
        data: (list) => ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              final value = list[index];
              return _buildCardItem(context, value);
            }));
  }

  Widget _buildCardItem(BuildContext context, BudgetUI value) {
    return DismissibleCard(
      id: value.id,
      confirmDismiss: (_) async {
        if (value.id == '0') {
          final snackBar = SnackBar(content: const Text('cantBeDeleted').tr());
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          return true;
        }
      },
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
          context.read(budgetsNotifier).deleteBudget(value);
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
