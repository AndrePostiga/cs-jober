import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final List<String> usersId;

  DocumentReference? reference;

  Match(this.usersId, [this.reference]);

  String? get matchId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {"usersId": usersId};
  }

  factory Match.fromSnapshot(QueryDocumentSnapshot doc) {
    return Match(doc["usersId"], doc.reference);
  }
}
