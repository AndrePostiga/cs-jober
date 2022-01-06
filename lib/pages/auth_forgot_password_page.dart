import 'package:flutter/material.dart';
import 'package:grupolaranja20212/view_models/forgot_password_view_model.dart';
import 'package:provider/provider.dart';

class AuthForgotPasswordPage extends StatefulWidget {
  const AuthForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _AuthForgotPasswordPage createState() => _AuthForgotPasswordPage();
}

class _AuthForgotPasswordPage extends State<AuthForgotPasswordPage> {
  String _message = "";

  final _emailController = TextEditingController();
  late ForgotPasswordViewModel _vM = ForgotPasswordViewModel();

  void _send(BuildContext context) async {
    setState(() {
      _message = "";
    });

    final email = _emailController.text;

    // check if username is not empty
    if (email.isEmpty) {
      setState(() {
        _message = "Digite seu email!";
      });
    } else {
      // perform login
      final msg = await _vM.forgotPassword(email);
      setState(() {
        _message = msg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _vM = Provider.of<ForgotPasswordViewModel>(context);

    return Scaffold(
        appBar: AppBar(title: const Text("Esqueci a senha")),
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
            TextButton(
                onPressed: () {
                  _send(context);
                },
                child: const Text("Clique aqui")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_message),
            )
          ]),
        ));
  }
}
