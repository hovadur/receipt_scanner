import 'package:ctr/database.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

class MyReceiptsViewModel extends ChangeNotifier {
  Stream<List<MyReceiptUI>> receipts(BuildContext context) =>
      Database().getReceipts().map((event) =>
          event.map((e) => ReceiptMapper().map(context, e)).toList());
}
