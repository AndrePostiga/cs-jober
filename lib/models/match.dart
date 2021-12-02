import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  final String recruiterUserId;
  final String candidateUserId;

  DocumentReference? reference;

  Match(this.recruiterUserId, this.candidateUserId, [this.reference]);

  Map<String, dynamic> toMap() {
    return {
      "recruiterUserId": recruiterUserId,
      "candidateUserId": candidateUserId
    };
  }

  factory Match.fromSnapshot(QueryDocumentSnapshot doc) {
    return Match(doc["recruiterUserId"], doc["candidateUserId"], doc.reference);
  }
}
