import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

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
        body: Center(
            child: Column(
          children: [
            const Text(
                'Tela de Registro do Usuário, onde ele vai botar a foto, as skills e url do linkedin'),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToSwipePage(context);
              },
              child: const Text('Salva e vai pra Swipe Page'),
            ),
          ],
        )),
      ),
    );
  }
}
