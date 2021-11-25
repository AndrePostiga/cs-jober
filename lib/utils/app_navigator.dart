import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/auth_login_page.dart';
import 'package:grupolaranja20212/pages/auth_register_page.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';
import 'package:grupolaranja20212/view_models/matches_view_model.dart';
import 'package:grupolaranja20212/view_models/register_view_model.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  static Future<bool> navigateToLoginPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => LoginViewModel(),
                child: const AuthLoginPage()),
            fullscreenDialog: true));
  }

  static Future<bool> navigateToRegisterPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => RegisterViewModel(),
                child: const AuthRegisterPage()),
            fullscreenDialog: true));
  }

  static Future<bool> navigateToMatchesPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => MatchesViewModel(),
                child: const MatchesPage()),
            fullscreenDialog: false));
  }
}
