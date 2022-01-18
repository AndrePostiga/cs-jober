import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/view_models/login_with_google_view_model.dart';

class AuthLoginWithGooglePage extends StatefulWidget {
  const AuthLoginWithGooglePage({Key? key}) : super(key: key);

  @override
  _AuthLoginWithGooglePage createState() => _AuthLoginWithGooglePage();
}

class _AuthLoginWithGooglePage extends State<AuthLoginWithGooglePage> {
  final _vm = LoginWithGoogleViewModel();

  Future _makeLogin() async {
    var isLoggedIn = await _vm.googleLogin();

    if (isLoggedIn) {
      // on successful login take the user to the main page
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainPage()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _makeLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login com Google"),
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(_vm.message)]),
        ));
  }
}
