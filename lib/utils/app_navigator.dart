import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/auth_forgot_password_page.dart';
import 'package:grupolaranja20212/pages/auth_login_page.dart';
import 'package:grupolaranja20212/pages/auth_logout_page.dart';
import 'package:grupolaranja20212/pages/auth_register_page.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/pages/chat_detail_page.dart';
import 'package:grupolaranja20212/pages/matches_map_page.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/pages/profile_page.dart';
import 'package:grupolaranja20212/pages/swipe_page.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';
import 'package:grupolaranja20212/view_models/forgot_password_view_model.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';
import 'package:grupolaranja20212/view_models/logout_view_model.dart';
import 'package:grupolaranja20212/view_models/matches_view_model.dart';
import 'package:grupolaranja20212/view_models/register_view_model.dart';
import 'package:grupolaranja20212/view_models/swipe_view_model.dart';
import 'package:provider/provider.dart';

class AppNavigator {
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

  static Future navigateToLogoutPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LogoutViewModel(),
                child: const AuthLogoutPage()),
            fullscreenDialog: true));
  }

  static Future navigateToMatchesPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const MatchesPage()),
            fullscreenDialog: false));
  }

  static Future navigateToMatchesMapPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const MatchesMapPage()),
            fullscreenDialog: false));
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

  static Future navigateToUserRegisterPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const UserRegisterPage()),
            fullscreenDialog: false));
  }

  static Future navigateToProfilePage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const ProfilePage()),
            fullscreenDialog: false));
  }

  static Future navigateToChatDetailPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const ChatDetailPage()),
            fullscreenDialog: false));
  }

  static Future navigateToMainPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => CardProvider(), child: const MainPage()),
            fullscreenDialog: false));
  }

  static Future navigateToSwipePage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => SwipeViewModel(),
                child: const SwipePage()),
            fullscreenDialog: false));
  }
}
