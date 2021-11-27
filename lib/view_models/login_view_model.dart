import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  String message = "";

  Future<bool> login(String email, String password) async {
    bool isLoggedIn = false;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        isLoggedIn = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('loggedUserUid', userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        message = Constants.userNotFound;
      } else if (e.code == "invalid-email") {
        message = Constants.invalidEmail;
      } else if (e.code == "user-disabled") {
        message = Constants.disabledUser;
      } else if (e.code == "wrong-password") {
        message = Constants.wrongPassword;
      } else if (e.code == "too-many-requests") {
        message = Constants.tooManyRequests;
      }
      notifyListeners();
    }

    return isLoggedIn;
  }
}
