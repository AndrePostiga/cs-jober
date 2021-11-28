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

  Future<User> createOrUpdateUserByFirebaseAuthUid(
      String firebaseAuthUid,
      String name,
      String linkedinUrl,
      String photoUrl,
      int typeId,
      String description,
      int maxSearchDistance,
      List<String> skills) async {
    var oldUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    if (oldUser == null) {
      var newUser = User(
          firebaseAuthUid,
          "",
          name,
          linkedinUrl,
          photoUrl,
          typeId,
          description,
          0,
          0,
          maxSearchDistance,
          skills, <String>[], <String>[]);

      await FirebaseFirestore.instance
          .collection("stores")
          .add(newUser.toMap());
    } else {
      oldUser.name = name;
      oldUser.linkedinUrl = linkedinUrl;
      oldUser.photoUrl = photoUrl;
      oldUser.typeId = typeId;
      oldUser.description = description;
      oldUser.maxSearchDistance = maxSearchDistance;
      oldUser.skills = skills;

      await FirebaseFirestore.instance
          .collection("stores")
          .doc(oldUser.reference!.id)
          .update(oldUser.toMap());
    }

    var storedUser = await getUserByFirebaseAuthUid(firebaseAuthUid);

    if (storedUser != null) {
      return storedUser;
    }

    throw Exception("Não foi possível gravar o novo usuário");
  }
}
