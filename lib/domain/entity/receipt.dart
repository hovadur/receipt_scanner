import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:flutter/material.dart';

class Receipt {
  String id;
  int operationType;
  DateTime dateTime;
  int totalSum;
  int fiscalDocumentNumber;
  String fiscalDriveNumber;
  int fiscalSign;
  String qr;
  List<ReceiptItem> items;

  //t=20200727T1117&s=4850.00&fn=9287440300634471&i=13571&fp=3730902192&n=1
  Receipt.fromQr(String qr) {
    var list = qr
        .split('&')
        .map((e) => e.replaceFirst(RegExp(r'[tsfnifpn=]+'), ''))
        .toList();
    if (list.length == 6) {
      int year = int.parse(list[0].substring(0, 4));
      int month = int.parse(list[0].substring(4, 6));
      int day = int.parse(list[0].substring(6, 8));
      int hour = int.parse(list[0].substring(9, 11));
      int minute = int.parse(list[0].substring(11, 13));
      dateTime = DateTime.utc(year, month, day, hour, minute);
      totalSum = int.tryParse(list[1].replaceFirst('.', ''));
      fiscalDriveNumber = list[2];
      fiscalDocumentNumber = int.parse(list[3]);
      fiscalSign = int.parse(list[4]);
      operationType = int.parse(list[5]);
      this.qr = qr;
      id = UniqueKey().toString();
      items = [];
    }
  }

  Receipt.fromDocumentSnapshot(DocumentSnapshot doc) {
    id = doc['id'];
    operationType = doc['operationType'];
    dateTime = (doc['dateTime'] as Timestamp).toDate();
    totalSum = doc['totalSum'];
    fiscalDocumentNumber = doc['fiscalDocumentNumber'];
    fiscalDriveNumber = doc['fiscalDriveNumber'];
    fiscalSign = doc['fiscalSign'];
    qr = doc['qr'];
    final list = List.castFrom(doc['items']).toList();
    items = list.map((e) => ReceiptItem.fromJson(e)).toList();
  }

  Receipt.fromTicketResp(TicketKktResp ticket) {
    var receipt = ticket.ticket.document.receipt;
    id = ticket.id;
    operationType = receipt.operationType;
    dateTime = DateTime.fromMillisecondsSinceEpoch(receipt.dateTime * 1000);
    totalSum = receipt.totalSum;
    fiscalDocumentNumber = receipt.fiscalDocumentNumber;
    fiscalDriveNumber = receipt.fiscalDriveNumber;
    fiscalSign = receipt.fiscalSign;
    qr = ticket.qr;
    items = receipt.items
        ?.map((e) => e == null ? null : ReceiptItem.fromItemsResp(e))
        ?.toList();
  }
}

class ReceiptItem {
  int type = 1;
  String name;
  int price;
  double quantity;

  Map<String, dynamic> toJson() =>
      {'type': type, 'name': name, 'price': price, 'quantity': quantity};

  ReceiptItem.fromJson(Map<String, dynamic> doc) {
    type = doc['type'];
    name = doc['name'];
    quantity = doc['quantity'];
    price = doc['price'];
  }

  ReceiptItem.fromItemsResp(ItemsResp item) {
    name = item.name;
    price = item.price;
    quantity = item.quantity;
  }
}
