import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'dart:math' show acos, cos, pi, sin;
import 'package:grupolaranja20212/models/match.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';

import 'package:grupolaranja20212/services/user_service.dart';

class SwipeViewModel extends ChangeNotifier {
  Future _createMatch(List<String> usersId) async {
    var match = Match(usersId, DateTime.now());
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
            {"page": "chat", "key": user.firebaseAuthUid});
      }

      if (user.oneSignalId != "") {
        await PushNotificationService().sendNotification(
            <String>[user.oneSignalId],
            "Você deu um MATCH com " + likedUser.name,
            "NOVO MATCH!",
            null,
            {"page": "chat", "key": likedUser.firebaseAuthUid});
      }

      return true;
    }

    return false;
  }

  Future<User> setUnlikedUser(User user, String unlikedFirebaseAuthUid) async {
    return await UserService().updateUserLikesOrDislikes(
        user.firebaseAuthUid, null, unlikedFirebaseAuthUid);
  }

  Future<List<User>> getUsersToSwipe(User user) async {
    // antes de tudo a funcao comeca recuperando os firebaseAuthUid que nao devem ser retornados na busca

    var firebaseAuthUidToNotGet = <String>[];

    if (user.likes.isNotEmpty) {
      firebaseAuthUidToNotGet.addAll(user.likes);
    }

    if (user.unlikes.isNotEmpty) {
      firebaseAuthUidToNotGet.addAll(user.unlikes);
    }

    var maxSearchDistance = user.maxSearchDistance;
    if (maxSearchDistance == 0) {
      maxSearchDistance = 1;
    }

    // pega so 10 itens no firebaseAuthUidToNotGet por conta da limitacao do firebasestore
    var filtroProFirebase = <String>[user.firebaseAuthUid];
    var filtroNoCodigo = <String>[];
    for (var userToNotGet in firebaseAuthUidToNotGet.toSet().toList()) {
      if (filtroProFirebase.length < 10) {
        filtroProFirebase.add(userToNotGet);
      } else {
        filtroNoCodigo.add(userToNotGet);
      }
    }

    // whereNotIn é limitado a 10 itens
    var querySnapShot = await FirebaseFirestore.instance
        .collection('users')
        .where('typeId', isEqualTo: user.typeId == 0 ? 1 : 0)
        .where("firebaseAuthUid", whereNotIn: filtroProFirebase)
        .get();

    var foundedUsers =
        querySnapShot.docs.map((e) => User.fromSnapshot(e)).toList();

    var usersToReturn = <User>[];

    if (foundedUsers.isEmpty) {
      return usersToReturn;
    }

    for (var newFoundedUser in foundedUsers) {
      // verifica se as skills batem (ou tem nos 2 ou o usuario encontrado tem a lista de skills vazia)
      // verifica se long do usuario ta entre os numeros permitidos
      // verifica se lat do usuario ta entre os numeros permitidos
      // verifica se usuario ta na lista dos firebaseUid nao permitidos
      if (_containsAny(newFoundedUser.skills, user.skills) &&
          _distanceBetweenTwoLatAndLongs(newFoundedUser, user) <=
              user.maxSearchDistance &&
          !filtroNoCodigo.contains(newFoundedUser.firebaseAuthUid)) {
        usersToReturn.add(newFoundedUser);
      }
    }

    return usersToReturn;
  }

  bool _containsAny(List<String> listaParaVerificarSeContemAlgum,
      List<String> listaParaChecarElementos) {
    // se uma das listas for vazia retorna true
    if (listaParaChecarElementos.isEmpty ||
        listaParaVerificarSeContemAlgum.isEmpty) {
      return true;
    }

    // se uma das duas listas so tiver 1 item e o item 1 for uma string vazia, retorna true tbm
    if (listaParaChecarElementos.length == 1) {
      if (listaParaChecarElementos.first == "") {
        return true;
      }
    } else if (listaParaVerificarSeContemAlgum.length == 1) {
      if (listaParaVerificarSeContemAlgum.first == "") {
        return true;
      }
    }

    // se algum dos elementos tiver nas 2 listas o retorno vai ser true
    for (var element in listaParaChecarElementos) {
      if (listaParaVerificarSeContemAlgum.contains(element)) {
        return true;
      }
    }

    return false;
  }

  double _distanceBetweenTwoLatAndLongs(User user1, User user2) {
    double lat1 = user1.lat;
    double lon1 = user1.long;
    double lat2 = user2.lat;
    double lon2 = user2.long;

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
