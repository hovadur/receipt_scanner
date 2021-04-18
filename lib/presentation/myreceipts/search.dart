import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/details/receipt_details_screen.dart';
import 'search_param.dart';
import 'search_ui.dart';

class Search extends SearchDelegate {
  Search()
      : super(
            searchFieldLabel: 'search'.tr(), keyboardType: TextInputType.text);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle:
                TextStyle(color: theme.primaryTextTheme.subtitle1?.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            subtitle1: theme.textTheme.subtitle1
                ?.copyWith(color: theme.primaryTextTheme.subtitle1?.color)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _Body(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _Body(query);
  }
}

class _Body extends ConsumerWidget {
  const _Body(this._query, {Key? key}) : super(key: key);
  final String _query;
  Widget build(BuildContext context, ScopedReader watch) {
    final stream = watch(searchStreamProvider(SearchParam(context, _query)));
    return _query.trim() == ''
        ? const SizedBox()
        : stream.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('wentWrong').tr(),
            data: (list) => ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final receipt = list[index];
                  return _CardItem(receipt);
                }));
  }
}

class _CardItem extends StatelessWidget {
  const _CardItem(this._ui, {Key? key}) : super(key: key);
  final SearchUI _ui;

  Widget build(BuildContext context) {
    final entries = context.category().entries.toList();
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading:
              CircleAvatar(child: Icon(entries.elementAt(_ui.item.type).key)),
          title: Text(_ui.item.name),
          trailing: Text(_ui.item.sum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: _ui.receipt.receipt)));
          },
        ),
      ],
    ));
  }
}
