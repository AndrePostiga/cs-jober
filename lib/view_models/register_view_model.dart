import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';
import 'package:grupolaranja20212/utils/constants.dart';

class RegisterViewModel extends ChangeNotifier {
  String message = "";

  Future<bool> register(String email, String password) async {
    bool isRegistered = false;

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      isRegistered = userCredential.user != null;

      if (isRegistered) {
        PushNotificationService().loginUser(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        message = Constants.weekPassword;
      } else if (e.code == "email-already-in-use") {
        message = Constants.emailAlreadyInUse;
      } else if (e.code == "invalid-email") {
        message = Constants.invalidEmail;
      } else if (e.code == "operation-not-allowed") {
        message = Constants.operationNotAllowed;
      }

      notifyListeners();
    }

    return isRegistered;
  }
}
