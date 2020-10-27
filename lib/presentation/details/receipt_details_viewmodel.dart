import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

import '../../database.dart';

class ReceiptDetailsViewModel with ChangeNotifier {
  Database _db = Database();
  Receipt _receipt;

  ReceiptDetailsViewModel(BuildContext context, Receipt receipt) {
    _receipt = receipt;
    _ui = ReceiptMapper().map(context, receipt);
    notifyListeners();
    if (receipt.items.isEmpty) {
      _db.saveReceipt(receipt);
      IrkktRepo().getTicket(receipt.qr).then((Receipt receiptKkt) {
        _db.removeReceipt(receipt);
        _db.saveReceipt(receiptKkt);
        _receipt = receiptKkt;
        _ui = ReceiptMapper().map(context, receiptKkt);
        notifyListeners();
      });
    }
  }

  MyReceiptUI _ui;

  MyReceiptUI get ui => _ui;

  void saveTypeAll(int type) {
    _receipt.items.forEach((e) => e.type = type);
    _ui.items.forEach((e) => e.type = type);
    notifyListeners();
    _db.saveReceipt(_receipt);
  }

  void saveType(int index, int type) {
    _receipt.items[index].type = type;
    _ui.items[index].type = type;
    notifyListeners();
    _db.saveReceipt(_receipt);
  }
}
