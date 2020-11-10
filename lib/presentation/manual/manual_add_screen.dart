import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/category_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/manual/manual_add_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualAddScreen extends StatelessWidget {
  const ManualAddScreen({@required this.onPressed, this.item, Key key})
      : super(key: key);
  static const String routeName = 'ManualAddScreen';

  final ValueChanged<ReceiptItem> onPressed;
  final ReceiptItem item;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ManualAddViewModel(context, item),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).addProduct),
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).cont),
            onPressed: () => submit(context),
          ),
          body: SingleChildScrollView(child: _buildColumn(context))));

  Widget _buildColumn(BuildContext context) {
    final entries = context.category().entries.toList();
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      const SizedBox(height: 16),
      ListTile(
        leading: CircleAvatar(
            child: Icon(entries
                .elementAt(
                    context.select((ManualAddViewModel value) => value.type))
                .key)),
        title: Text(entries
            .elementAt(context.select((ManualAddViewModel value) => value.type))
            .value),
        onTap: () => AppNavigator.of(context).push(MaterialPage<Page>(
            name: CategoryScreen.routeName,
            child: CategoryScreen(
              onPressed: (type) {
                context.read<ManualAddViewModel>().saveType(type);
                Navigator.of(context).pop();
              },
            ))),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(children: [
            TextField(
              controller: context
                  .select((ManualAddViewModel value) => value.nameController),
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).product),
              onChanged: (String value) =>
                  context.read<ManualAddViewModel>().name = value,
            ),
            TextField(
              controller: context
                  .select((ManualAddViewModel value) => value.qtyController),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).qtyy,
                  errorText: context
                      .select((ManualAddViewModel value) => value.qtyError)),
              onChanged: (String value) =>
                  context.read<ManualAddViewModel>().changeQty(value, context),
            ),
            TextField(
              controller: context
                  .select((ManualAddViewModel value) => value.sumController),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(context),
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).sum,
                  errorText: context
                      .select((ManualAddViewModel value) => value.sumError)),
              onChanged: (String value) =>
                  context.read<ManualAddViewModel>().changeSum(value, context),
            ),
          ]))
    ]);
  }

  void submit(BuildContext context) {
    onPressed(context.read<ManualAddViewModel>().getProduct(context));
    AppNavigator.of(context).pop();
  }
}
