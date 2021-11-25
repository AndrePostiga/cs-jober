import 'package:flutter/material.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro do Usuário',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Registro do Usuário'),
        ),
        body: const Center(
          child: Text(
              'Tela de Registro do Usuário, onde ele vai botar a foto, as skills e url do linkedin'),
        ),
      ),
    );
  }
}
