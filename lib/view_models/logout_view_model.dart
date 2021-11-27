import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutViewModel extends ChangeNotifier {
  Future<bool> logout() async {
    bool logoutOk = false;

    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseAuth.instance.signOut();
      logoutOk = true;
    }

    return logoutOk;
  }
}
