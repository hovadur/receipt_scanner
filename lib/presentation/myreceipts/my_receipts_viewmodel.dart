import 'package:ctr/database.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:ctr/presentation/myreceipts/search_ui.dart';
import 'package:flutter/material.dart';

class MyReceiptsViewModel extends ChangeNotifier {
  final _db = Database();
  final _receiptMapper = ReceiptMapper();

  Stream<List<MyReceiptUI>> receipts(BuildContext context) =>
      _db.getReceipts().map(
          (event) => event.map((e) => _receiptMapper.map(context, e)).toList());

  Stream<List<SearchUI>> search(BuildContext context, String filter) =>
      _db.getReceipts().map((receipts) => receipts.expand((receipt) {
            final myReceipt = _receiptMapper.map(context, receipt);
            return receipt.items
                .where((element) =>
                    element.name.toLowerCase().contains(filter.toLowerCase()))
                .map((item) => SearchUI(
                    MyReceiptItemUI.fromReceiptItem(context, item), myReceipt))
                .toList();
          }).toList());

  void deleteReceipt(MyReceiptUI receiptUI) {
    _db.deleteReceipt(receiptUI.receipt);
  }
}
