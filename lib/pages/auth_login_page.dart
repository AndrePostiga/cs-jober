import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({Key? key}) : super(key: key);

  @override
  _AuthLoginPage createState() => _AuthLoginPage();
}

class _AuthLoginPage extends State<AuthLoginPage> {
  String _message = "";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginVM = LoginViewModel();

  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // check if username is not empty
    if (email.isEmpty) {
      setState(() {
        _message = "Digite seu email!";
      });
    } else if (password.isEmpty) {
      setState(() {
        _message = "Digite sua senha!";
      });
    } else {
      // perform login
      final isLoggedIn = await _loginVM.login(email, password);
      if (isLoggedIn) {
        // on successful login take the user to the main page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MatchesPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: "Digite seu E-Mail"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _passwordController,
            decoration: const InputDecoration(hintText: "Digite sua Senha"),
          ),
        ),
        TextButton(
            onPressed: () {
              _login(context);
            },
            child: const Text("Login")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_message),
        )
      ]),
    ));
  }
}
