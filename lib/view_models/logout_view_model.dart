import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';

class LogoutViewModel extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  Future<bool> logout() async {
    bool logoutOk = false;

    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await googleSignIn.disconnect();
      await FirebaseAuth.instance.signOut();

      PushNotificationService().logout(currentUser.uid);
      logoutOk = true;
    }

    return logoutOk;
  }
}
