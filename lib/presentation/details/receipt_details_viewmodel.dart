import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class ReceiptDetailsViewModel with ChangeNotifier {
  ReceiptDetailsViewModel(BuildContext context, Receipt receipt) {
    _ui = ReceiptMapper().map(context, receipt);
    notifyListeners();
    if (receipt.items.isEmpty) {
      Database db = Database();
      db.saveReceipt(receipt);
      IrkktRepo().getTicket(receipt.qr).then((Receipt receiptKkt) {
        db.removeReceipt(receipt);
        db.saveReceipt(receiptKkt);
        _ui = ReceiptMapper().map(context, receiptKkt);
        notifyListeners();
      });
    }
  }

  MyReceiptUI _ui;

  MyReceiptUI get ui => _ui;
}
