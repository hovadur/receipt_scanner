import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../../app_module.dart';
import '../../domain/navigation/app_navigator.dart';
import '../../presentation/common/context_ext.dart';
import '../../presentation/details/receipt_details_screen.dart';
import 'search_param.dart';
import 'search_ui.dart';

class Search extends SearchDelegate {
  Search(BuildContext context)
      : super(
            searchFieldLabel: context.translate().search,
            keyboardType: TextInputType.text);

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
    return _buildBody(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) =>
      Consumer(builder: (context, watch, __) {
        final stream = watch(searchStreamProvider(SearchParam(context, query)));
        if (query.trim() == '') {
          return const SizedBox();
        } else {
          return stream.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => Text(context.translate().wentWrong),
              data: (list) => ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final receipt = list[index];
                    return _buildCardItem(context, receipt);
                  }));
        }
      });

  Widget _buildCardItem(BuildContext context, SearchUI ui) {
    final entries = context.category().entries.toList();
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading:
              CircleAvatar(child: Icon(entries.elementAt(ui.item.type).key)),
          title: Text(ui.item.name),
          trailing: Text(ui.item.sum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: ui.receipt.receipt)));
          },
        ),
      ],
    ));
  }
}
