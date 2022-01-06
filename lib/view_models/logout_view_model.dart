import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';

class LogoutViewModel extends ChangeNotifier {
  Future<bool> logout() async {
    bool logoutOk = false;

    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseAuth.instance.signOut();

      await PushNotificationService().logout(currentUser.uid);
      logoutOk = true;
    }

    return logoutOk;
  }
}
