import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/services/user_service.dart';
import 'dart:math' show cos, pi, sin, acos;

class SwipeViewModel extends ChangeNotifier {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<User?> updateUserLocation(String firebaseAuthUid) async {
    return await UserService().updateUserLatLong(firebaseAuthUid);
  }

  Future<List<User>> getNotUnlikedAndNotLikedUsers(
      User user, List<User>? previousFoundedUsers) async {
    previousFoundedUsers ??= <User>[];

    var previousFoundedUsersIds = <String>[];

    for (var previousFoundedUser in previousFoundedUsers) {
      previousFoundedUsersIds.add(previousFoundedUser.firebaseAuthUid);
    }

    var maxItensToGet = 5;

    var querySnapShot = await FirebaseFirestore.instance
        .collection("users")
        .where("firebaseAuthUid", whereNotIn: user.likes)
        .where("firebaseAuthUid", whereNotIn: user.unlikes)
        .where("firebaseAuthUid", whereNotIn: previousFoundedUsersIds)
        .where("typeId", isNotEqualTo: user.typeId)
        .where("skills", arrayContainsAny: user.skills)
        .limit(maxItensToGet)
        .get();

    var foundedUsers =
        querySnapShot.docs.map((e) => User.fromSnapshot(e)).toList();

    var usersToReturn = <User>[];

    if (foundedUsers.isEmpty) {
      return usersToReturn;
    }

    for (var newFoundedUser in foundedUsers) {
      if (user.maxSearchDistance.toDouble() >=
          distanceBetweenTwoLatAndLongs(
              user.lat, user.long, newFoundedUser.lat, newFoundedUser.long)) {
        usersToReturn.add(newFoundedUser);
      }
    }

    if (usersToReturn.length < maxItensToGet) {
      usersToReturn
          .addAll(await getNotUnlikedAndNotLikedUsers(user, usersToReturn));
    }

    return usersToReturn;
  }

  double distanceBetweenTwoLatAndLongs(
      double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;

    dist = dist * 1.609344;

    return dist;
  }

  double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }
}
