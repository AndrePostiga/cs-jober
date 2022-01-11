import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grupolaranja20212/models/match_message.dart';

class MessagesService {
  // SERVICE RELACIONADO AO TRATAMENTO DE MSGS... RECUPERACAO E ENVIO
  Future<List<MatchMessage>> getMessagesBetweenFirebaseUids(
      List<String> firebaseAuthUids) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection('messages')
        .where("uniqueId",
            whereIn: _getAllCombinationsBetweenFromAndToFirebaseUids(
                firebaseAuthUids[0], firebaseAuthUids[1]))
        .orderBy("createdAt")
        .get();

    return querySnapShot.docs.map((e) => MatchMessage.fromSnapshot(e)).toList();
  }

  void listenMessagesFromMatchedUser(Function f,
      String matchedUserfirebaseAuthUid, String loggedUserfirebaseAuthUid) {
    FirebaseFirestore.instance
        .collection('messages')
        .where("uniqueId",
            isEqualTo: _getFromToUidsAndConvertToUniqueKey(
                matchedUserfirebaseAuthUid, loggedUserfirebaseAuthUid))
        .orderBy("createdAt", descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      f(event.docs.map((e) => MatchMessage.fromSnapshot(e)).toList()[0]);
    });
  }

  List<String> _getAllCombinationsBetweenFromAndToFirebaseUids(
      String fromFirebaseAuthUid, String toFirebaseAuthUid) {
    var combinations = <String>[];

    combinations.add(_getFromToUidsAndConvertToUniqueKey(
        fromFirebaseAuthUid, toFirebaseAuthUid));

    combinations.add(_getFromToUidsAndConvertToUniqueKey(
        toFirebaseAuthUid, fromFirebaseAuthUid));

    return combinations;
  }

  String _getFromToUidsAndConvertToUniqueKey(
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

  Future<MatchMessage> addMsg(String fromUserFirebaseAuthUid,
      String toUserFirebaseAuthUid, String text) async {
    var newMsg = MatchMessage(
        _getFromToUidsAndConvertToUniqueKey(
            fromUserFirebaseAuthUid, toUserFirebaseAuthUid),
        DateTime.now(),
        text);

    await FirebaseFirestore.instance.collection("messages").add(newMsg.toMap());

    return newMsg;
  }
}
