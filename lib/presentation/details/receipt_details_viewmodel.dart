import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_ui.dart';
import 'package:ctr/presentation/mapper/receipt_mapper.dart';
import 'package:flutter/material.dart';

class ReceiptDetailsViewModel with ChangeNotifier {
  ReceiptDetailsViewModel(BuildContext context, Receipt receipt) {
    _ui = ReceiptMapper().map(context, receipt);
  }

  MyReceiptUI _ui;

  MyReceiptUI get ui => _ui;
}
