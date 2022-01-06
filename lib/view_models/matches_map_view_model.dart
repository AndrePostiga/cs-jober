import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/match.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class MatchesMapViewModel extends ChangeNotifier {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<List<User>> getMatchesUsers(String firebaseAuthUid) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection('matches')
        .where("usersId", arrayContains: firebaseAuthUid)
        .get();

    var foundedMatches =
        querySnapShot.docs.map((e) => Match.fromSnapshot(e)).toList();

    var firebaseAuthUids = <String>[];

    for (var foundedMatch in foundedMatches) {
      for (var userId in foundedMatch.usersId) {
        if (userId != firebaseAuthUid && !firebaseAuthUids.contains(userId)) {
          firebaseAuthUids.add(userId);
        }
      }
    }

    var querySnapShotUsers = await FirebaseFirestore.instance
        .collection('users')
        .where("firebaseAuthUid", whereIn: firebaseAuthUids)
        .get();

    var usersFromMatches =
        querySnapShotUsers.docs.map((e) => User.fromSnapshot(e)).toList();

    return usersFromMatches;
  }
}
