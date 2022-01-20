import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/constants.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  Future<String> forgotPassword(String email) async {
    String message = "";

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      message =
          "Foi enviado uma mensagem para o e-mail informado sobre o esquecimento da senha e informando quais sao as tratativas que devem ser realizadas";
    } on FirebaseAuthException catch (e) {
      if (e.code == "auth/user-not-found") {
        message = Constants.userNotFound;
      } else if (e.code == "auth/invalid-email") {
        message = Constants.invalidEmail;
      } else {
        message = e.code + " - " + (e.message ?? "");
      }
      notifyListeners();
    }

    return message;
  }
}
