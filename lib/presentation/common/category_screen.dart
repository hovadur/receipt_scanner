import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../presentation/common/context_ext.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({required this.onPressed, Key? key}) : super(key: key);

  static const String routeName = 'CategoryScreen';

  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    final categoryMap = context.category();
    return Scaffold(
        appBar: AppBar(title: const Text('categories').tr()),
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
