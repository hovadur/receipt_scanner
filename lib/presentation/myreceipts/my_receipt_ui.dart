import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/presentation/myreceipts/my_item_ui.dart';
import 'package:ctr/presentation/myreceipts/my_search_item_ui.dart';

class MyReceiptUI extends MyItemUI {
  MyReceiptUI(
      {required this.id,
      required this.dateTime,
      required this.totalSum,
      required this.fn,
      required this.fd,
      required this.fpd,
      required this.items,
      required this.receipt});

  String id;
  String dateTime;
  String totalSum;
  String fn;
  String fd;
  String fpd;
  List<MySearchItemUI> items;
  Receipt receipt;
}
