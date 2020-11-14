import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/myreceipts/my_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';

class MyReceiptUI extends MyItemUI {
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
  List<MySearchItemUI> items;
  Receipt receipt;
}
