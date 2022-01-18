import 'package:cloud_firestore/cloud_firestore.dart';

class UserType {
  final int id;
  final String type;

  DocumentReference? reference;

  UserType(this.id, this.type, [this.reference]);

  String? get matchId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "type": type};
  }

  factory UserType.fromSnapshot(QueryDocumentSnapshot doc) {
    return UserType(doc["id"], doc["type"], doc.reference);
  }
}
