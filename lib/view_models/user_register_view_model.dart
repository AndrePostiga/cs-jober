import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/models/user_type.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class UserRegisterViewModel extends ChangeNotifier {
  Future<List<UserType>> getUserTypes() async {
    return await UserService().getUserTypes();
  }

  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
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
    return await UserService().createOrUpdateUserByFirebaseAuthUid(
        firebaseAuthUid,
        name,
        linkedinUrl,
        photoUrl,
        typeId,
        description,
        maxSearchDistance,
        skills);
  }
}
