import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';

class Receipt {
  String id;
  int type = 1;
  DateTime dateTime;
  int totalSum;
  int fiscalDocumentNumber;
  String fiscalDriveNumber;
  int fiscalSign;
  List<ReceiptItem> items;

  Receipt.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    type = doc['type'];
    dateTime = (doc['dateTime'] as Timestamp).toDate();
    totalSum = doc['totalSum'];
    fiscalDocumentNumber = doc['fiscalDocumentNumber'];
    fiscalDriveNumber = doc['fiscalDriveNumber'];
    fiscalSign = doc['fiscalSign'];
  }

  Receipt.fromTicketResp(TicketKktResp ticket) {
    var receipt = ticket.ticket.document.receipt;
    id = ticket.id;
    dateTime = DateTime.fromMillisecondsSinceEpoch(receipt.dateTime * 1000);
    totalSum = receipt.totalSum;
    fiscalDocumentNumber = receipt.fiscalDocumentNumber;
    fiscalDriveNumber = receipt.fiscalDriveNumber;
    fiscalSign = receipt.fiscalSign;
    items = receipt.items
        ?.map((e) => e == null ? null : ReceiptItem.fromItemsResp(e))
        ?.toList();
  }
}

class ReceiptItem {
  String name;
  int price;
  int quantity;

  Map<String, dynamic> toJson() =>
      {'name': name, 'price': price, 'quantity': quantity};

  ReceiptItem.fromItemsResp(ItemsResp item) {
    name = item.name;
    price = item.price;
    quantity = item.quantity;
  }
}
