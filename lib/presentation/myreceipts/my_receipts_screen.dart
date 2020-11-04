import 'package:ctr/domain/navigation/app_navigator.dart';
import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:ctr/presentation/details/receipt_details_screen.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_viewmodel.dart';
import 'package:ctr/presentation/myreceipts/search_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

MyReceiptsViewModel viewModel;

class MyReceiptsScreen extends StatelessWidget {
  const MyReceiptsScreen({Key key}) : super(key: key);
  static const String routeName = 'MyReceiptsScreen';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (_) => viewModel = MyReceiptsViewModel(),
      builder: (context, _) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).myReceipts),
            actions: [
              IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      showSearch(context: context, delegate: Search(context)))
            ],
          ),
          body: StreamBuilder<List<MyReceiptUI>>(
              stream: context.watch<MyReceiptsViewModel>().receipts(context),
              builder: (context, AsyncSnapshot<List<MyReceiptUI>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final receipt = snapshot.data[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: receipt == null
                              ? Container()
                              : _buildCardItem(context, receipt));
                    });
              })));

  Widget _buildCardItem(BuildContext context, MyReceiptUI receipt) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.fact_check)),
          title: Text(receipt.dateTime),
          trailing: Text(receipt.totalSum),
          onTap: () {
            AppNavigator.of(context).push(MaterialPage<Page>(
                name: ReceiptDetailsScreen.routeName,
                child: ReceiptDetailsScreen(receipt: receipt.receipt)));
          },
        ),
      ],
    ));
  }
}

class Search extends SearchDelegate {
  Search(BuildContext context)
      : super(
            searchFieldLabel: AppLocalizations.of(context).search,
            keyboardType: TextInputType.text);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle:
                TextStyle(color: theme.primaryTextTheme.subtitle1.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            subtitle1: theme.textTheme.subtitle1
                .copyWith(color: theme.primaryTextTheme.subtitle1.color)));
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

  Widget _buildBody(BuildContext context) => ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, _) {
        if (query == null || query.trim() == '') {
          return Container();
        } else {
          return StreamBuilder<List<SearchUI>>(
              stream:
                  context.watch<MyReceiptsViewModel>().search(context, query),
              builder: (context, AsyncSnapshot<List<SearchUI>> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      final receipt = snapshot.data[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: receipt == null
                              ? Container()
                              : _buildCardItem(context, receipt));
                    });
              });
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
