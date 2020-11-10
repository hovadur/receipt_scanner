import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  Budget(this.id, this.name, this.sum);

  Budget.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        name = doc['name'],
        sum = doc['sum'];
  String id;
  String name;
  int sum;
}
