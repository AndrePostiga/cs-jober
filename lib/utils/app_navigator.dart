import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/auth_forgot_password_page.dart';
import 'package:grupolaranja20212/pages/auth_login_page.dart';
import 'package:grupolaranja20212/pages/auth_login_with_google_page.dart';
import 'package:grupolaranja20212/pages/auth_logout_page.dart';
import 'package:grupolaranja20212/pages/auth_register_page.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/pages/match_chat_page.dart';
import 'package:grupolaranja20212/pages/profile_page.dart';
import 'package:grupolaranja20212/view_models/forgot_password_view_model.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';
import 'package:grupolaranja20212/view_models/login_with_google_view_model.dart';
import 'package:grupolaranja20212/view_models/logout_view_model.dart';
import 'package:grupolaranja20212/view_models/main_view_model.dart';
import 'package:grupolaranja20212/view_models/matches_view_model.dart';
import 'package:grupolaranja20212/view_models/register_view_model.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  // CLASSE QUE LIDA COM OS REDIRECTS DENTRO DO APP
  static Future<bool?> navigateToLoginPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LoginViewModel(),
                child: const AuthLoginPage()),
            fullscreenDialog: true));
  }

  static Future<bool?> navigateToRegisterPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => RegisterViewModel(),
                child: const AuthRegisterPage()),
            fullscreenDialog: true));
  }

  static Future navigateToLoginWithGooglePage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LoginWithGoogleViewModel(),
                child: const AuthLoginWithGooglePage()),
            fullscreenDialog: true));
  }

  static Future navigateToLogoutPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LogoutViewModel(),
                child: const AuthLogoutPage()),
            fullscreenDialog: true));
  }

  static Future navigateToForgotPasswordPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => ForgotPasswordViewModel(),
                child: const AuthForgotPasswordPage()),
            fullscreenDialog: false));
  }

  static Future navigateToProfilePage(
      BuildContext context, String firebaseAuthUid) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: ProfilePage(
                  userFirebaseAuthUid: firebaseAuthUid,
                )),
            fullscreenDialog: false));
  }

  static Future navigateToMatchChatPage(
      BuildContext context, String matchUserFirebaseUid) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: MatchChatPage(
                    matchUserFirebaseAuthUid: matchUserFirebaseUid)),
            fullscreenDialog: false));
  }

  static Future navigateToMainPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MainViewModel(), child: const MainPage()),
            fullscreenDialog: false));
  }
}
