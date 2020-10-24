import 'package:cloud_firestore/cloud_firestore.dart';

import 'domain/entity/user.dart';

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
}
