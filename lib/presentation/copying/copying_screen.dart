import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share/share.dart';

import '../../app_module.dart';

class CopyingScreen extends ConsumerWidget {
  const CopyingScreen({Key? key}) : super(key: key);
  static const String routeName = 'CopyingScreen';

  @override
  Widget build(BuildContext context, ScopedReader watch) => Scaffold(
      appBar: AppBar(title: const Text('copying').tr(), actions: [
        IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(
                'check out my website https://example.com',
                subject: 'Look what I made!')),
      ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32.0, 26, 32, 32),
          child: Column(children: [
            Text('date'.tr(), style: Theme.of(context).textTheme.subtitle1),
            Column(children: _genDateListTile(context, watch))
          ])));

  List<Widget> _genDateListTile(BuildContext context, ScopedReader watch) {
    final uniqueList = Set.from(_genDatString()).toList();
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

  List<String> _genDatString() {
    return [
      'forAllTheTime'.tr(),
      'forTheCurrentMonth'.tr(),
      'forThePreviousMonth'.tr(),
      'forTheLastWeek'.tr(),
      'forTheLast3Days'.tr(),
    ];
  }
}
