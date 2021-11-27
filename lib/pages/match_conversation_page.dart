import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class MatchConversationPage extends StatelessWidget {
  const MatchConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversa',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Conversa'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToProfilePage(context);
              },
              child: const Text('PERFIL DE UM USUARIO'),
            ),
          ],
        )),
      ),
    );
  }
}
