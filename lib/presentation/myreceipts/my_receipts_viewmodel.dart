import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MyReceiptsViewModel with ChangeNotifier {
  Future<List<Receipt>> receipts() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var list = await users
        .doc(auth.FirebaseAuth.instance.currentUser.uid)
        .collection('receipts')
        .get();
    return list.docs
        .map((e) =>
            Receipt((e['timestamp'] as Timestamp).toDate(), e['totalSum']))
        .toList();
  }
}
