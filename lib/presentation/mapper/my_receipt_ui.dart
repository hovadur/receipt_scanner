import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/mapper/my_receipt_item_ui.dart';

class MyReceiptUI {
  MyReceiptUI(
      {this.id,
      this.dateTime,
      this.totalSum,
      this.fn,
      this.fd,
      this.fpd,
      this.items,
      this.receipt});

  String id;
  String dateTime;
  String totalSum;
  String fn;
  String fd;
  String fpd;
  List<MyReceiptItemUI> items;
  Receipt receipt;
}
