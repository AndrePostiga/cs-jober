import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String message = "";

  Future<bool> login(String email, String password) async {
    bool isLoggedIn = false;

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      isLoggedIn = userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        message = "User is not registered!";
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }

    return isLoggedIn;
  }
}
