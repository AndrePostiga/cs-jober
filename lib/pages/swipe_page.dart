import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/swipe_view_model.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  final SwipeViewModel _swipeVM = SwipeViewModel();

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    }

    _initPage();
  }

  Future _initPage() async {
    var loggedUser = await _swipeVM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    if (loggedUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserRegisterPage()),
          (Route<dynamic> route) => false);
    } else {
      await _swipeVM.updateUserLocation(FirebaseAuth.instance.currentUser!.uid);
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
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToUserRegisterPage(context);
              },
              child: const Text('EDIT DO USUARIO E PREFERENCIAS'),
            ),
          ],
        )),
      ),
    );
  }
}
