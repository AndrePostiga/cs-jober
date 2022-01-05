import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class AuthLoginPage extends StatefulWidget {
  const AuthLoginPage({Key? key}) : super(key: key);

  @override
  _AuthLoginPage createState() => _AuthLoginPage();
}

class _AuthLoginPage extends State<AuthLoginPage> {
  String _message = "";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late LoginViewModel _loginVM = LoginViewModel();

  void _login(BuildContext context) async {
    setState(() {
      _message = "";
    });

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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          _message = _loginVM.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loginVM = Provider.of<LoginViewModel>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(hintText: "Digite seu E-Mail"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(hintText: "Digite sua Senha"),
              ),
            ),
            TextButton(
                onPressed: () {
                  _login(context);
                },
                child: const Text("Login")),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToForgotPasswordPage(context);
              },
              child: const Text('Esqueci minha senha'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message),
            )
          ]),
        ));
  }
}
