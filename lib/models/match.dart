import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final List<String> usersId;
  final DateTime createdAt;
  DocumentReference? reference;

  Match(this.usersId, this.createdAt, [this.reference]);

  Map<String, dynamic> toMap() {
    return {"usersId": usersId, "createdAt": createdAt};
  }

  factory Match.fromSnapshot(QueryDocumentSnapshot doc) {
    DateTime createdAt = doc["createdAt"].toDate();

    return Match(doc["usersId"].cast<String>(), createdAt, doc.reference);
  }
}
