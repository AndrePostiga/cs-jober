import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupolaranja20212/models/match_message.dart';

class MessagesService {
  Future<List<MatchMessage>> getMessagesBetweenFirebaseUids(
      List<String> firebaseAuthUids) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection('messages')
        .where("uniqueId",
            whereIn: _getAllCombinationsBetweenFromAndToFirebaseUids(
                firebaseAuthUids[0], firebaseAuthUids[1]))
        .orderBy("createdAt", descending: true)
        .get();

    return querySnapShot.docs.map((e) => MatchMessage.fromSnapshot(e)).toList();
  }

  List<String> _getAllCombinationsBetweenFromAndToFirebaseUids(
      String fromFirebaseAuthUid, String toFirebaseAuthUid) {
    var combinations = <String>[];

    combinations.add(getFromToUidsAndConvertToUniqueKey(
        fromFirebaseAuthUid, toFirebaseAuthUid));

    combinations.add(getFromToUidsAndConvertToUniqueKey(
        toFirebaseAuthUid, fromFirebaseAuthUid));

    return combinations;
  }

  String getFromToUidsAndConvertToUniqueKey(
      String fromFirebaseAuthUid, String toFirebaseAuthUid) {
    return fromFirebaseAuthUid + "->" + toFirebaseAuthUid;
  }

  List<String> getFromAndToUsersFromUniqueKey(String uniqueKey) {
    return uniqueKey.split("->");
  }

  Future<MatchMessage?> getLastMessageBetweenFirebaseUids(
      List<String> firebaseAuthUids) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection('messages')
        .where("uniqueId",
            whereIn: _getAllCombinationsBetweenFromAndToFirebaseUids(
                firebaseAuthUids[0], firebaseAuthUids[1]))
        .orderBy("createdAt", descending: true)
        .limit(1)
        .get();

    var listMsgs =
        querySnapShot.docs.map((e) => MatchMessage.fromSnapshot(e)).toList();

    if (listMsgs.isEmpty) {
      return null;
    }

    return listMsgs[0];
  }

  Future addMsg(String fromUserFirebaseAuthUid, String toUserFirebaseAuthUid,
      String text) async {
    var newMsg = MatchMessage(
        MessagesService().getFromToUidsAndConvertToUniqueKey(
            fromUserFirebaseAuthUid, toUserFirebaseAuthUid),
        DateTime.now(),
        text);

    await FirebaseFirestore.instance.collection("messages").add(newMsg.toMap());
  }
}
