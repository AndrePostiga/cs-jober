import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'dart:math' show cos, pi, sin, acos;
import 'package:grupolaranja20212/models/match.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';

import 'package:grupolaranja20212/services/user_service.dart';

class SwipeViewModel extends ChangeNotifier {
  Future _createMatch(List<String> usersId) async {
    var match = Match(usersId);
    await FirebaseFirestore.instance.collection("matches").add(match.toMap());
  }

  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<User> setLikedUser(User user, String likedFirebaseAuthUid) async {
    return await UserService().updateUserLikesOrDislikes(
        user.firebaseAuthUid, likedFirebaseAuthUid, null);
  }

  Future<bool> isMatch(User user, String likedFirebaseAuthUid) async {
    var likedUser = await getUserByFirebaseAuthUid(likedFirebaseAuthUid);

    if (likedUser!.likes.contains(user.firebaseAuthUid)) {
      await _createMatch(<String>[user.firebaseAuthUid, likedFirebaseAuthUid]);

      if (likedUser.oneSignalId != "") {
        await PushNotificationService().sendNotification(
            <String>[likedUser.oneSignalId],
            "Você deu um MATCH com " + user.name,
            "NOVO MATCH!",
            null,
            null);
      }

      if (user.oneSignalId != "") {
        await PushNotificationService().sendNotification(
            <String>[user.oneSignalId],
            "Você deu um MATCH com " + likedUser.name,
            "NOVO MATCH!",
            null,
            null);
      }

      return true;
    }

    return false;
  }

  Future<User> setUnlikedUser(User user, String unlikedFirebaseAuthUid) async {
    return await UserService().updateUserLikesOrDislikes(
        user.firebaseAuthUid, null, unlikedFirebaseAuthUid);
  }

  Future<List<User>> getUsersToSwipe(
      User user, List<User>? previousFoundedUsers) async {
    previousFoundedUsers ??= <User>[];

    // antes de tudo a funcao comeca recuperando os firebaseAuthUid que nao devem ser retornados na busca
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

    for (var newFoundedUser in foundedUsers) {
      // verifica se as skills batem (ou tem nos 2 ou o usuario encontrado tem a lista de skills vazia)
      if (newFoundedUser.typeId != user.typeId &&
          _containsAny(newFoundedUser.skills, user.skills)) {
        var maxSearchDistance = user.maxSearchDistance.toDouble();
        if (maxSearchDistance == 0) {
          maxSearchDistance = 1;
        }

        // verifica se a distancia maxima procurada esta maior ou igual que a distancia dos pontos em KM calculando via LAT,LONG
        if (maxSearchDistance >=
            _distanceBetweenTwoLatAndLongs(
                user.lat, user.long, newFoundedUser.lat, newFoundedUser.long)) {
          usersToReturn.add(newFoundedUser);
        }
      }
    }

    // se a lista de usuarios encontrados for menor que a maxItensToGet uma recursao vai ocorrer pra pegar mais usuarios caso tiver e os usuarios ja encontrados serao passados via parametro para n serem buscados
    if (usersToReturn.length < maxItensToGet) {
      foundedUsers.addAll(previousFoundedUsers);
      usersToReturn.addAll(await getUsersToSwipe(user, foundedUsers));
    }

    return usersToReturn;
  }

  bool _containsAny(List<String> listaParaVerificarSeContemAlgum,
      List<String> listaParaChecarElementos) {
    // se algum dos elementos tiver nas 2 listas ou se a lista pra checar for vazia entao o retorno vai ser true
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
    // checking distance using the implementation presented on this site  https://flutteragency.com/total-distance-from-latlng-list-in-flutter/
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
