import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Swipe'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToLogoutPage(context);
              },
              child: const Text('LOGOUT'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMatchesPage(context);
              },
              child: const Text('MATCHES'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMainPage(context);
              },
              child: const Text('MAIN PAGE (SWIPE)'),
            ),
          ],
        )),
      ),
    );
  }
}
