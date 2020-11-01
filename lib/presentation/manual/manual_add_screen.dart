import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/category_screen.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/manual/manual_add_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManualAddScreen extends StatelessWidget {
  static const String routeName = 'ManualAddScreen';

  const ManualAddScreen({@required this.onPressed});

  final ValueChanged<ReceiptItem> onPressed;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => ManualAddViewModel(),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).addProduct),
          ),
          body: SafeArea(
              minimum: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
              child: _buildColumn(context))));

  Widget _buildColumn(BuildContext context) {
    final entries = context.category().entries.toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
              child: Icon(entries
                  .elementAt(
                      context.select((ManualAddViewModel value) => value.type))
                  .key)),
          title: Text(entries
              .elementAt(
                  context.select((ManualAddViewModel value) => value.type))
              .value),
          onTap: () => AppNavigator.of(context).push(MaterialPage(
              name: CategoryScreen.routeName,
              child: CategoryScreen(
                onPressed: (type) {
                  context.read<ManualAddViewModel>().saveType(type);
                  Navigator.of(context).pop();
                },
              ))),
        ),
        TextField(
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
          decoration:
              InputDecoration(labelText: AppLocalizations.of(context).product),
          onChanged: (String value) =>
              context.read<ManualAddViewModel>().name = value,
        ),
        const SizedBox(width: 8),
        TextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).qtyy,
              errorText:
                  context.select((ManualAddViewModel value) => value.qtyError)),
          onChanged: (String value) =>
              context.read<ManualAddViewModel>().changeQty(value, context),
        ),
        const SizedBox(width: 8),
        TextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context).sum,
              errorText:
                  context.select((ManualAddViewModel value) => value.sumError)),
          onChanged: (String value) =>
              context.read<ManualAddViewModel>().changeSum(value, context),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              autofocus: true,
              onPressed: () {
                onPressed(
                    context.read<ManualAddViewModel>().addProduct(context));
                AppNavigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
              ),
              child: Text(AppLocalizations.of(context).next),
            ),
          ),
        ),
      ],
    );
  }
}
