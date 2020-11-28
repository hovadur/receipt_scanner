import 'package:ctr/database.dart';
import 'package:ctr/domain/data/error/irkkt_not_login.dart';
import 'package:ctr/domain/data/repo/irkkt_repo.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:ctr/presentation/myreceipts/my_receipt_ui.dart';
import 'package:flutter/material.dart';

class ReceiptDetailsNotifier extends ChangeNotifier {
  ReceiptDetailsNotifier(
      BuildContext context, Receipt receipt, this._irkktRepo, this._db) {
    _receipt = receipt;
    _ui = ReceiptMapper().map(context, receipt);
    notifyListeners();
    if (receipt.items.isEmpty && receipt.qr.isNotEmpty) {
      _db.saveReceipt(receipt, isBudget: true);
    }
  }

  final Database _db;
  final IrkktRepo _irkktRepo;
  late Receipt _receipt;

  late MyReceiptUI _ui;

  Stream<MyReceiptUI> getUI(BuildContext context) => _db
      .getReceipt(_receipt.id)
      .map((event) => ReceiptMapper().map(context, _receipt));

  Future<int> getIrkktReceipt(BuildContext context) async {
    if (_receipt.items.isEmpty && _receipt.qr.isNotEmpty) {
      try {
        final receiptKkt = await _irkktRepo.getTicket(_receipt.qr);
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
