import 'package:ctr/database.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:ctr/presentation/myreceipts/my_header_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';
import 'package:ctr/presentation/myreceipts/search_ui.dart';
import 'package:flutter/material.dart';

import 'my_item_ui.dart';

class MyReceiptsNotifier extends ChangeNotifier {
  final _db = Database();
  final _receiptMapper = ReceiptMapper();

  Stream<List<MyItemUI>> receipts(BuildContext context) async* {
    var dd = DateTime.fromMillisecondsSinceEpoch(0);
    var h = MyHeaderUI(dd, 0);
    var sum = 0;
    final list = <MyItemUI>[];
    await for (final event in _db.getReceipts()) {
      if (event.isEmpty)
        yield list;
      else {
        for (final e in event) {
          final d = e.dateTime;
          final diff = DateTime(d.year, d.month, d.day).difference(dd);
          if (diff.abs().inDays >= 1) {
            sum = 0;
            h = MyHeaderUI(e.dateTime, sum);
            yield list..add(h);
            final d = e.dateTime;
            dd = DateTime(d.year, d.month, d.day);
          }
          final receipt = _receiptMapper.map(context, e);
          h.sum += e.totalSum;
          yield list..add(receipt);
        }
      }
    }
  }

  Stream<List<SearchUI>> search(BuildContext context, String filter) =>
      _db.getReceipts().map((receipts) => receipts.expand((receipt) {
            final myReceipt = _receiptMapper.map(context, receipt);
            return receipt.items
                .where((element) =>
                    element.name.toLowerCase().contains(filter.toLowerCase()))
                .map((item) => SearchUI(
                    MySearchItemUI.fromReceiptItem(context, item), myReceipt))
                .toList();
          }).toList());

  void deleteReceipt(MyReceiptUI receiptUI) {
    _db.deleteReceipt(receiptUI.receipt);
    notifyListeners();
  }
}
