import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class MatchesMapViewModel extends ChangeNotifier {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<List<User>> getMatchesUsers(String firebaseAuthUid) async {
    return await UserService().getMatchesUsers(firebaseAuthUid);
  }
}
