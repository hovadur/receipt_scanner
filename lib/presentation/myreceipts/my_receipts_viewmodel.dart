import 'package:ctr/domain/entity/receipt.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class MyReceiptsViewModel with ChangeNotifier {
  Future<List<Receipt>> receipts() => Database().getReceipts();
}
