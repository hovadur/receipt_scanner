import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:flutter/material.dart';

class Receipt {
  Receipt({this.dateTime, this.totalSum, this.items});

  String id = UniqueKey().toString();
  int operationType = 1;
  DateTime dateTime;
  int totalSum;
  int fiscalDocumentNumber = 0;
  String fiscalDriveNumber = '';
  int fiscalSign = 0;
  String qr = '';
  List<ReceiptItem> items = [];

  //t=20200727T1117&s=4850.00&fn=9287440300634471&i=13571&fp=3730902192&n=1
  Receipt.fromQr(String qr) {
    var match =
        RegExp(r't=([\dT]+)&s=([\d\.]+)&fn=(\d+)&i=(\d+)&fp=(\d+)&n=(\d+)')
            .firstMatch(qr);
    if (match != null && match.groupCount == 6) {
      int year = int.parse(match[1].substring(0, 4));
      int month = int.parse(match[1].substring(4, 6));
      int day = int.parse(match[1].substring(6, 8));
      int hour = int.parse(match[1].substring(9, 11));
      int minute = int.parse(match[1].substring(11, 13));
      dateTime = DateTime.utc(year, month, day, hour, minute);
      totalSum = int.tryParse(match[2].replaceFirst('.', ''));
      fiscalDriveNumber = match[3];
      fiscalDocumentNumber = int.parse(match[4]);
      fiscalSign = int.parse(match[5]);
      operationType = int.parse(match[6]);
      this.qr = qr;
    } else
      throw Exception('invalid format');
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
  ReceiptItem(this.type, this.name, this.price, this.quantity, this.sum);

  int type = 1;
  String name;
  int price;
  num quantity;
  int sum;

  Map<String, dynamic> toJson() => {
        'type': type,
        'name': name,
        'price': price,
        'quantity': quantity,
        'sum': sum
      };

  ReceiptItem.fromJson(Map<String, dynamic> doc) {
    type = doc['type'];
    name = doc['name'];
    quantity = doc['quantity'];
    price = doc['price'];
    sum = doc['sum'];
  }

  ReceiptItem.fromItemsResp(ItemsResp item) {
    name = item.name;
    price = item.price;
    quantity = item.quantity;
    sum = item.sum;
  }
}
