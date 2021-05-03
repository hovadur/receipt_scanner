import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../database.dart';
import '../../domain/entity/receipt.dart';
import '../mapper/receipt_mapper.dart';
import 'my_header_ui.dart';
import 'my_item_ui.dart';
import 'my_receipt_ui.dart';
import 'my_search_item_ui.dart';
import 'search_ui.dart';

class MyReceiptsNotifier extends ChangeNotifier {
  MyReceiptsNotifier(this._db, BuildContext context) {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(context, pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  static const _pageSize = 2;
  final Database _db;
  final _receiptMapper = ReceiptMapper();
  DateTime? _dateTime = null;

  final PagingController<DocumentSnapshot?, MyItemUI> _pagingController =
      PagingController(firstPageKey: null);

  PagingController<DocumentSnapshot?, MyItemUI> get pagingController =>
      _pagingController;

  Future<void> _fetchPage(
      BuildContext context, DocumentSnapshot? pageKey) async {
    final startDateTime = _dateTime;
    var dd = startDateTime == null
        ? DateTime.fromMillisecondsSinceEpoch(0)
        : startDateTime;
    var h = MyHeaderUI(dd, 0);
    var sum = 0;
    final list = <MyItemUI>[];
    await for (final snapshot in _db.getReceiptsSnapshots(pageKey, _pageSize)) {
      final s = snapshot.docs;
      final event = s.map((e) => Receipt.fromDocumentSnapshot(e)).toList();
      final isLastPage = event.length < _pageSize;
      for (final e in event) {
        final d = e.dateTime;
        _dateTime = d;
        final diff = DateTime(d.year, d.month, d.day).difference(dd);
        if (diff.abs().inDays >= 1) {
          sum = 0;
          h = MyHeaderUI(e.dateTime, sum);
          list.add(h);
          final d = e.dateTime;
          dd = DateTime(d.year, d.month, d.day);
        }
        final receipt = _receiptMapper.map(context, e);
        h.sum += e.totalSum;
        list.add(receipt);
      }
      if (isLastPage) {
        _pagingController.appendLastPage(list);
      } else {
        final nextPageKey = s.last;
        _pagingController.appendPage(list, nextPageKey);
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
