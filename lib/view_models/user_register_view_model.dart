import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/models/user_type.dart';

class UserRegisterViewModel extends ChangeNotifier {
  Future<List<UserType>> getUserTypes() async {
    var querySnapShot =
        await FirebaseFirestore.instance.collection("user_types").get();

    return querySnapShot.docs.map((e) => UserType.fromSnapshot(e)).toList();
  }

  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    var querySnapShot = await FirebaseFirestore.instance
        .collection("users")
        .where('firebaseAuthUid', isEqualTo: firebaseAuthUid)
        .get();

    var foundedUsers =
        querySnapShot.docs.map((e) => User.fromSnapshot(e)).toList();

    if (foundedUsers.isEmpty) {
      return null;
    }

    if (foundedUsers.length > 1) {
      throw Exception(
          "Foi encontrado mais de um usuário para o firebaseAuthUid informado: " +
              firebaseAuthUid);
    }

    return foundedUsers[0];
  }
}
