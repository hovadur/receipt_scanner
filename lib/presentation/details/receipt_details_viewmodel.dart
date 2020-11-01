import 'package:ctr/database.dart';
import 'package:ctr/domain/data/error/irkkt_not_login.dart';
import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

class ReceiptDetailsViewModel extends ChangeNotifier {
  final Database _db = Database();
  Receipt _receipt;

  ReceiptDetailsViewModel(BuildContext context, Receipt receipt) {
    _receipt = receipt;
    _ui = ReceiptMapper().map(context, receipt);
    notifyListeners();
    if (receipt.items.isEmpty && receipt.qr.isNotEmpty) {
      _db.saveReceipt(receipt);
    }
  }

  MyReceiptUI _ui;

  MyReceiptUI get ui => _ui;

  Future<int> getIrkktReceipt(BuildContext context) async {
    if (_receipt.items.isEmpty && _receipt.qr.isNotEmpty) {
      try {
        final receiptKkt = await IrkktRepo().getTicket(_receipt.qr);
        await _db.deleteReceipt(_receipt);
        await _db.saveReceipt(receiptKkt);
        _receipt = receiptKkt;
        _ui = ReceiptMapper().map(context, receiptKkt);
        notifyListeners();
        return 1;
      } on IrkktNotLogin {
        return 2;
      }
    } else {
      return 0;
    }
  }

  void saveTypeAll(int type) {
    for (final e in _receipt.items) {
      e.type = type;
    }
    for (final e in _ui.items) {
      e.type = type;
    }
    notifyListeners();
    _db.saveReceipt(_receipt);
  }

  void saveType(int index, int type) {
    _receipt.items[index].type = type;
    _ui.items[index].type = type;
    notifyListeners();
    _db.saveReceipt(_receipt);
  }

  void deleteReceipt() {
    _db.deleteReceipt(_receipt);
  }

  void update() {
    notifyListeners();
  }
}
