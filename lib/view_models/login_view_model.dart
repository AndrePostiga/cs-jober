import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        message = "O usuário não está registrado";
      } else if (e.code == "invalid-email") {
        message = "O e-mail informado é inválido";
      } else if (e.code == "user-disabled") {
        message = "Seu usuário foi desabilitado";
      } else if (e.code == "user-disabled") {
        message = "Usuário não encontrado... Registre-se";
      } else if (e.code == "wrong-password") {
        message = "Sua Senha está errada";
      } else if (e.code == "too-many-requests") {
        message = "Aguarde 2 minutos e tente novamente";
      }
      notifyListeners();
    }

    return isLoggedIn;
  }
}
