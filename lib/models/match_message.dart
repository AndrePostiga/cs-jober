import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupolaranja20212/services/messages_service.dart';

class MatchMessage {
  final String uniqueId;
  final DateTime createdAt;
  final String text;

  String get fromUserUid {
    var fromAndTo = MessagesService().getFromAndToUsersFromUniqueKey(uniqueId);

    return fromAndTo[0];
  }

  String get toUserUid {
    var fromAndTo = MessagesService().getFromAndToUsersFromUniqueKey(uniqueId);

    return fromAndTo[1];
  }

  DocumentReference? reference;

  MatchMessage(this.uniqueId, this.createdAt, this.text, [this.reference]);

  String? get conversationmatchId {
    return reference?.id;
  }

  Map<String, dynamic> toMap() {
    return {"uniqueId": uniqueId, "createdAt": createdAt, "text": text};
  }

  factory MatchMessage.fromSnapshot(QueryDocumentSnapshot doc) {
    DateTime createdAt = doc["createdAt"].toDate();
    return MatchMessage(doc["uniqueId"], createdAt, doc["text"], doc.reference);
  }
}
