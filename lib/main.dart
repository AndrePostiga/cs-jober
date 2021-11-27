import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/swipe_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Set default home.
  Widget _defaultHome = const WelcomePage();

  if (FirebaseAuth.instance.currentUser != null) {
    _defaultHome = const SwipePage();
  }

  // Run app!
  runApp(MaterialApp(
    title: 'JOBer',
    home: _defaultHome,
  ));
}
