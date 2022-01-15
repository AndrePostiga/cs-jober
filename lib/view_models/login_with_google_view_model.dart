import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';
import 'package:grupolaranja20212/utils/constants.dart';

class LoginWithGoogleViewModel extends ChangeNotifier {
  String message = "Aguarde...";

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future<bool> googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return false;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    bool isLoggedIn = false;

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      isLoggedIn = userCredential.user != null;

      if (isLoggedIn) {
        PushNotificationService().loginUser(userCredential.user!.uid);
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
      } else {
        message =
            "Erro ao tentar se logar, feche essa tela e clique novamente no botão de login com Google! " +
                (e.message ?? "");
      }
      notifyListeners();
    }

    return isLoggedIn;
  }
}
