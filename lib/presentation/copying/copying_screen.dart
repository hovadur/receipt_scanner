import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:share/share.dart';

import '../../app_module.dart';
import '../../presentation/common/context_ext.dart';

class CopyingScreen extends ConsumerWidget {
  const CopyingScreen({Key? key}) : super(key: key);
  static const String routeName = 'CopyingScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
      appBar: AppBar(title: Text(context.translate().copying), actions: [
        IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(
                'check out my website https://example.com',
                subject: 'Look what I made!')),
      ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
          child: Column(children: [
            Text(context.translate().date,
                style: Theme.of(context).textTheme.subtitle1),
            Column(children: _genDateListTile(context, watch))
          ])));

  List<Widget> _genDateListTile(BuildContext context, ScopedReader watch) {
    final uniqueList = Set.from(_genDatString(context)).toList();
    return uniqueList.map((val) {
      final idx = uniqueList.indexOf(val);
      return RadioListTile(
        value: idx,
        groupValue: watch(copyingNotifier).selectedDate,
        title: Text(val),
        onChanged: (int? value) {
          context.read(copyingNotifier).setSelectedDate(idx);
        },
        selected: watch(copyingNotifier).selectedDate == idx,
      );
    }).toList();
  }

  List<String> _genDatString(BuildContext context) {
    return [
      context.translate().forAllTheTime,
      context.translate().forTheCurrentMonth,
      context.translate().forThePreviousMonth,
      context.translate().forTheLastWeek,
      context.translate().forTheLast3Days,
    ];
  }
}
