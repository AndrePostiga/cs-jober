import 'package:flutter/material.dart';
import 'package:grupolaranja20212/view_models/login_view_model.dart';
import 'package:provider/provider.dart';

class AuthLoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginViewModel _loginVM = LoginViewModel();

  AuthLoginPage({Key? key}) : super(key: key);

  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;

    bool isLoggedIn = await _loginVM.login(email, password);
    if (isLoggedIn) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _loginVM = Provider.of<LoginViewModel>(context);

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future<bool>.value(false);
      },
      child: Scaffold(
          appBar: AppBar(title: const Text("Login")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email requerido!";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: "Email"),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Senha requirida!";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(hintText: "Senha"),
                      ),
                      TextButton(
                          child: const Text("Login",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _login(context);
                          },
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white))),
                      Text(_loginVM.message)
                    ],
                  )),
            ),
          )),
    );
  }
}
