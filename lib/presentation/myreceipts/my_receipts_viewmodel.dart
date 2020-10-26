import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';
import '../mapper/my_receipt_ui.dart';

class MyReceiptsViewModel with ChangeNotifier {
  Future<List<MyReceiptUI>> receipts(BuildContext context) =>
      Database().getReceipts().then((value) => value.map((item) {
            return ReceiptMapper().map(context, item);
          }).toList());
}
