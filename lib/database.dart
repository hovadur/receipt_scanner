import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/entity/receipt.dart';

import 'domain/entity/user.dart';
import 'domain/interactor/user_interactor.dart';

class Database {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<bool> createUser(User user) async {
    try {
      await users
          .doc(user.id)
          .set({'id': user.id, 'email': user.email, 'name': user.name});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Receipt>> getReceipts() async {
    var list = await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .get();
    return list.docs.map((e) => Receipt.fromDocumentSnapshot(e)).toList();
  }

  void saveReceipt(Receipt receipt) async {
    await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .doc(receipt.id)
        .set({
      'id': receipt.id,
      'dateTime': receipt.dateTime,
      'totalSum': receipt.totalSum,
      'fiscalDocumentNumber': receipt.fiscalDocumentNumber,
      'fiscalDriveNumber': receipt.fiscalDriveNumber,
      'fiscalSign': receipt.fiscalSign,
      'items': receipt.items.map((e) => e.toJson()).toList()
    });
  }
}
