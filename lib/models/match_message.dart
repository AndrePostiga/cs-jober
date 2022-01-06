import 'package:cloud_firestore/cloud_firestore.dart';

class MatchMessage {
  final String fromUserUid;
  final String toUserUid;
  final DateTime createdAt;
  final String text;

  DocumentReference? reference;

  MatchMessage(this.fromUserUid, this.toUserUid, this.createdAt, this.text,
      [this.reference]);

  String? get conversationmatchId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "fromUserUid": fromUserUid,
      "toUserUid": toUserUid,
      "createdAt": createdAt,
      "text": text
    };
  }

  factory MatchMessage.fromSnapshot(QueryDocumentSnapshot doc) {
    return MatchMessage(doc["fromUserUid"], doc["toUserUid"], doc["createdAt"],
        doc["text"], doc.reference);
  }
}
