import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';
import '../mapper/my_receipt_ui.dart';

class MyReceiptsViewModel with ChangeNotifier {
  Stream<List<MyReceiptUI>> receipts(BuildContext context) =>
      Database().getReceipts().map((event) =>
          event.map((e) => ReceiptMapper().map(context, e)).toList());
}
