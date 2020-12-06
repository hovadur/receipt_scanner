import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/data/dto/ticket_resp.dart';
import 'package:flutter/material.dart';

class Receipt {
  Receipt(
      {required this.dateTime, required this.totalSum, required this.items});

  Receipt.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc['id'],
        operationType = doc['operationType'],
        dateTime = (doc['dateTime'] as Timestamp).toDate(),
        totalSum = doc['totalSum'],
        fiscalDocumentNumber = doc['fiscalDocumentNumber'],
        fiscalDriveNumber = doc['fiscalDriveNumber'],
        fiscalSign = doc['fiscalSign'],
        qr = doc['qr'],
        items = List.castFrom(doc['items']).toList()
            .map((e) => ReceiptItem.fromJson(e))
            .toList();

  Receipt.fromTicketResp(TicketKktResp ticket) {
    id = ticket.id;
    qr = ticket.qr;
    final receipt = ticket.ticket.document.receipt;
    if (receipt != null) {
      operationType = receipt.operationType;
      dateTime = DateTime.fromMillisecondsSinceEpoch(receipt.dateTime * 1000);
      totalSum = receipt.totalSum;
      fiscalDocumentNumber = receipt.fiscalDocumentNumber;
      fiscalDriveNumber = receipt.fiscalDriveNumber;
      fiscalSign = receipt.fiscalSign;
      items = receipt.items.map((e) => ReceiptItem.fromItemsResp(e)).toList();
    }
  }

  Receipt.fromQr(String qr) {
    final match = _qrPattern.firstMatch(qr);
    if (match != null && match.groupCount == 6) {
      final year = int.parse((match[1] ?? '1970').substring(0, 4));
      final month = int.parse((match[1] ?? '01').substring(4, 6));
      final day = int.parse((match[1] ?? '01').substring(6, 8));
      final hour = int.parse((match[1] ?? '00').substring(9, 11));
      final minute = int.parse((match[1] ?? '00').substring(11, 13));
      dateTime = DateTime.utc(year, month, day, hour, minute);
      totalSum = int.tryParse((match[2] ?? '0').replaceFirst('.', '')) ?? 0;
      fiscalDriveNumber = match[3] ?? '';
      fiscalDocumentNumber = int.parse(match[4] ?? '0');
      fiscalSign = int.parse(match[5] ?? '0');
      operationType = int.parse(match[6] ?? '0');
      this.qr = qr;
    } else {
      throw Exception('invalid format');
    }
  }

  //t=20200727T1117&s=4850.00&fn=9287440300634471&i=13571&fp=3730902192&n=1
  static final _qrPattern =
      RegExp(r't=([\dT]+)&s=([\d\.]+)&fn=(\d+)&i=(\d+)&fp=(\d+)&n=(\d+)');

  String id = UniqueKey().toString();
  int operationType = 1;
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);
  int totalSum = 0;
  int fiscalDocumentNumber = 0;
  String fiscalDriveNumber = '';
  int fiscalSign = 0;
  String qr = '';
  List<ReceiptItem> items = [];
}

class ReceiptItem {
  ReceiptItem(this.type, this.name, this.price, this.quantity, this.sum);

  ReceiptItem.fromJson(Map<String, dynamic> doc)
      : type = doc['type'],
        name = doc['name'],
        quantity = doc['quantity'],
        price = doc['price'],
        sum = doc['sum'];

  ReceiptItem.fromItemsResp(ItemsResp item)
      : name = item.name,
        price = item.price,
        quantity = item.quantity,
        sum = item.sum;

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
}
