import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MatchesViewModel extends ChangeNotifier {
  String message = "";

  Stream<QuerySnapshot> get matchesAsStream {
    const int loggedUserId = 0;
    return FirebaseFirestore.instance
        .collection("matches")
        .where("usersId", arrayContains: loggedUserId)
        .snapshots();
  }
}
