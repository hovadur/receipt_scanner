import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/entity/user.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';

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

  Stream<List<Receipt>> getReceipts() {
    return users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .snapshots()
        .map((event) {
      return event.docs.map((e) => Receipt.fromDocumentSnapshot(e)).toList();
    });
  }

  Future<bool> receiptExists(String qr) async {
    final doc = await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .where('qr', isEqualTo: qr)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future<void> deleteReceipt(Receipt receipt) async {
    await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .doc(receipt.id)
        .delete();
  }

  Future<void> saveReceipt(Receipt receipt) async {
    await users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .doc(receipt.id)
        .set({
      'id': receipt.id,
      'operationType': receipt.operationType,
      'dateTime': receipt.dateTime,
      'totalSum': receipt.totalSum,
      'fiscalDocumentNumber': receipt.fiscalDocumentNumber,
      'fiscalDriveNumber': receipt.fiscalDriveNumber,
      'fiscalSign': receipt.fiscalSign,
      'qr': receipt.qr,
      'items': receipt.items.map((e) => e.toJson()).toList()
    });
  }
}
