import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LogoutViewModel extends ChangeNotifier {
  Future<bool> logout() async {
    bool logoutOk = false;

    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseAuth.instance.signOut();
      await OneSignal.shared.removeExternalUserId();
      logoutOk = true;
    }

    return logoutOk;
  }
}
