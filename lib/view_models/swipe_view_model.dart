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

  Future<List<User>> getUsersToSwipe(
      User user, List<User>? previousFoundedUsers) async {
    previousFoundedUsers ??= <User>[];

    var previousFoundedUsersIds = <String>[];

    for (var previousFoundedUser in previousFoundedUsers) {
      previousFoundedUsersIds.add(previousFoundedUser.firebaseAuthUid);
    }

    var maxItensToGet = 5;

    var firebaseAuthUidToNotGet = <String>[user.firebaseAuthUid];

    if (user.likes.isNotEmpty) {
      firebaseAuthUidToNotGet.addAll(user.likes);
    }

    if (user.unlikes.isNotEmpty) {
      firebaseAuthUidToNotGet.addAll(user.unlikes);
    }

    if (previousFoundedUsersIds.isNotEmpty) {
      firebaseAuthUidToNotGet.addAll(previousFoundedUsersIds);
    }

    var querySnapShot = await FirebaseFirestore.instance
        .collection('users')
        .where("firebaseAuthUid",
            whereNotIn: firebaseAuthUidToNotGet.toSet().toList())
        .limit(maxItensToGet)
        .get();

    var foundedUsers =
        querySnapShot.docs.map((e) => User.fromSnapshot(e)).toList();

    var usersToReturn = <User>[];

    if (foundedUsers.isEmpty) {
      return usersToReturn;
    }

    var maxSearchDistance = user.maxSearchDistance.toDouble();
    if (maxSearchDistance == 0) {
      maxSearchDistance = 1;
    }

    for (var newFoundedUser in foundedUsers) {
      if (maxSearchDistance >=
              _distanceBetweenTwoLatAndLongs(user.lat, user.long,
                  newFoundedUser.lat, newFoundedUser.long) &&
          newFoundedUser.typeId != user.typeId &&
          _containsAny(newFoundedUser.skills, user.skills)) {
        usersToReturn.add(newFoundedUser);
      }
    }

    if (usersToReturn.length < maxItensToGet) {
      usersToReturn.addAll(await getUsersToSwipe(user, foundedUsers));
    }

    return usersToReturn;
  }

  bool _containsAny(List<String> listaParaVerificarSeContemAlgum,
      List<String> listaParaChecarElementos) {
    var result = true;

    for (var element in listaParaChecarElementos) {
      result = false;
      if (listaParaVerificarSeContemAlgum.contains(element)) {
        return true;
      }
    }

    return result;
  }

  double _distanceBetweenTwoLatAndLongs(
      double lat1, double lon1, double lat2, double lon2) {
    double theta = lon1 - lon2;
    double dist = sin(_deg2rad(lat1)) * sin(_deg2rad(lat2)) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * cos(_deg2rad(theta));
    dist = acos(dist);
    dist = _rad2deg(dist);
    dist = dist * 60 * 1.1515;

    dist = dist * 1.609344;

    return dist;
  }

  double _deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  double _rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }
}
