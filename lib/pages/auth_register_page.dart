import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/view_models/register_view_model.dart';
import 'package:provider/provider.dart';

class AuthRegisterPage extends StatefulWidget {
  const AuthRegisterPage({Key? key}) : super(key: key);

  @override
  _AuthRegisterPage createState() => _AuthRegisterPage();
}

class _AuthRegisterPage extends State<AuthRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late RegisterViewModel _registerVM = RegisterViewModel();

  Future<bool> _registerUser(BuildContext context) async {
    bool isRegistered = false;

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      isRegistered = await _registerVM.register(email, password);
      if (isRegistered) {
        // if user is successfully registered redirect to main page blocking user to back
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false);
      }
    }

    return isRegistered;
  }

  @override
  Widget build(BuildContext context) {
    _registerVM = Provider.of<RegisterViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          backgroundColor: Colors.orange,
        ),
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
                        return "O E-Mail é obrigatório";
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
                        return "A Senha é obrigatória";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  TextButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.purple)),
                      onPressed: () {
                        _registerUser(context);
                      },
                      child: const Text("Register")),
                  Text(_registerVM.message)
                ],
              ),
            ),
          ),
        ));
  }
}
