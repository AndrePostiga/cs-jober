import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AndroidGoogleMapsFlutter.useAndroidViewSurface = true;

  // Set default home.
  Widget _defaultHome = const WelcomePage();

  if (FirebaseAuth.instance.currentUser != null) {
    _defaultHome = const MainPage();
  }

  // Run app!
  runApp(MaterialApp(
    title: 'JOBer',
    home: _defaultHome,
  ));
}
