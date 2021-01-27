import 'package:flutter/material.dart';

import '../../database.dart';
import '../mapper/receipt_mapper.dart';
import 'my_header_ui.dart';
import 'my_item_ui.dart';
import 'my_receipt_ui.dart';
import 'my_search_item_ui.dart';
import 'search_ui.dart';

class MyReceiptsNotifier extends ChangeNotifier {
  MyReceiptsNotifier(this._db);

  final Database _db;
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
