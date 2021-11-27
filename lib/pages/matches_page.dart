import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matches',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Matches'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMatchesMapPage(context);
              },
              child: const Text('MAPA COM OS MATCHES'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMatchConversationPage(context);
              },
              child: const Text('CONVERSA COM UM DOS MATCHES'),
            ),
          ],
        )),
      ),
    );
  }
}
