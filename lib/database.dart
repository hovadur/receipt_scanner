import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctr/domain/entity/receipt.dart';
import 'package:ctr/domain/entity/user.dart';
import 'package:ctr/domain/interactor/user_interactor.dart';

import 'domain/entity/budget.dart';

class Database {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<bool> createUser(User user) async {
    try {
      await _users
          .doc(user.id)
          .set({'id': user.id, 'email': user.email, 'name': user.name});
      await _users
          .doc(UserInteractor().getCurrentUser().id)
          .collection('budgets')
          .doc('0')
          .set({'id': '0', 'name': 'Personal', 'sum': 0});
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Budget>> getBudgets() => _users
          .doc(UserInteractor().getCurrentUser().id)
          .collection('budgets')
          .snapshots()
          .map((event) {
        return event.docs.map((e) => Budget.fromDocumentSnapshot(e)).toList();
      });

  Future<void> deleteBudget(Budget value) async {
    await _users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('budgets')
        .doc(value.id)
        .delete();
  }

  Future<void> saveBudget(Budget value) async {
    if (value.id == '') {
      await _users
          .doc(UserInteractor().getCurrentUser().id)
          .collection('budgets')
          .add({'name': value.name, 'sum': value.sum});
    } else {
      await _users
          .doc(UserInteractor().getCurrentUser().id)
          .collection('budgets')
          .doc(value.id)
          .set({'name': value.name, 'sum': value.sum});
    }
  }

  Stream<List<Receipt>> getReceipts() => _users
          .doc(UserInteractor().getCurrentUser().id)
          .collection('receipts')
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((event) {
        return event.docs.map((e) => Receipt.fromDocumentSnapshot(e)).toList();
      });

  Stream<Receipt> getReceipt(String receiptId) => _users
      .doc(UserInteractor().getCurrentUser().id)
      .collection('receipts')
      .doc(receiptId)
      .snapshots()
      .map((event) => Receipt.fromDocumentSnapshot(event));

  Future<bool> receiptExists(String qr) async {
    final doc = await _users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .where('qr', isEqualTo: qr)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future<void> deleteReceipt(Receipt value) async {
    await _users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .doc(value.id)
        .delete();
  }

  Future<void> saveReceipt(Receipt value) async {
    await _users
        .doc(UserInteractor().getCurrentUser().id)
        .collection('receipts')
        .doc(value.id)
        .set({
      'id': value.id,
      'operationType': value.operationType,
      'dateTime': value.dateTime,
      'totalSum': value.totalSum,
      'fiscalDocumentNumber': value.fiscalDocumentNumber,
      'fiscalDriveNumber': value.fiscalDriveNumber,
      'fiscalSign': value.fiscalSign,
      'qr': value.qr,
      'items': value.items.map((e) => e.toJson()).toList()
    });
  }
}
