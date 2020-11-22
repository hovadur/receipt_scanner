import 'package:ctr/presentation/myreceipts/my_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipts_notifier.dart';
import 'package:ctr/presentation/myreceipts/search_param.dart';
import 'package:ctr/presentation/myreceipts/search_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final myReceiptsNotifier = ChangeNotifierProvider<MyReceiptsNotifier>((_) {
  return MyReceiptsNotifier();
});

final myReceiptsStreamProvider = StreamProvider.autoDispose
    .family<List<MyItemUI>, BuildContext>((ref, context) {
  final notifier = ref.watch(myReceiptsNotifier);
  return notifier.receipts(context);
});

final searchStreamProvider = StreamProvider.autoDispose
    .family<List<SearchUI>, SearchParam>((ref, param) {
  final notifier = ref.watch(myReceiptsNotifier);
  return notifier.search(param.context, param.filter);
});
