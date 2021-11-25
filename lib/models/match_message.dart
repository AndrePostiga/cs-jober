import 'package:cloud_firestore/cloud_firestore.dart';

class MatchMessage {
  final String fromUserId;
  final DateTime createdAt;
  final String text;

  DocumentReference? reference;

  MatchMessage(this.fromUserId, this.createdAt, this.text, [this.reference]);

  String? get conversationmatchId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {"fromUserId": fromUserId, "createdAt": createdAt, "text": text};
  }

  factory MatchMessage.fromSnapshot(QueryDocumentSnapshot doc) {
    return MatchMessage(
        doc["fromUserId"], doc["createdAt"], doc["text"], doc.reference);
  }
}
