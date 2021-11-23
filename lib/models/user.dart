import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String linkedinUrl;
  final String photoUrl;
  final int typeId;

  DocumentReference reference;

  User(this.name, this.linkedinUrl, this.photoUrl, this.typeId,
      [this.reference]);

  String get userId {
    return reference.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "linkedinUrl": linkedinUrl,
      "photoUrl": photoUrl,
      "typeId": typeId
    };
  }

  factory User.fromSnapshot(QueryDocumentSnapshot doc) {
    return User(doc["name"], doc["linkedinUrl"], doc["photoUrl"], doc["typeId"],
        doc.reference);
  }
}
