import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';
import 'package:flutter/material.dart';

class MyReceiptsViewModel with ChangeNotifier {
  Future<List<Receipt>> receipts() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var list = await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .get();
    return list.docs
        .map((e) =>
            Receipt((e['timestamp'] as Timestamp).toDate(), e['totalSum']))
        .toList();
  }
}
