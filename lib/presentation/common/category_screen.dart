import 'package:ctr/l10n/app_localizations.dart';
import 'package:ctr/presentation/common/context_ext.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  static const String routeName = 'CategoryScreen';

  const CategoryScreen({@required this.onPressed});

  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    final categoryMap = context.category();
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(AppLocalizations.of(context).categories)),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {  },
        //   child: Icon(Icons.add),
        // ),
        body: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: categoryMap.length,
                itemBuilder: (BuildContext context, int index) {
                  final entries = categoryMap.entries.toList();
                  return ListTile(
                    leading:
                        CircleAvatar(child: Icon(entries.elementAt(index).key)),
                    title: Text(entries.elementAt(index).value),
                    onTap: () => onPressed(index),
                  );
                })));
  }
}
