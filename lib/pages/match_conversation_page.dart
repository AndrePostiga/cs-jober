import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class MatchConversationPage extends StatelessWidget {
  const MatchConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Room',
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Matches')),
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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: ("Conversas")),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: ("Mapa")),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: ("Perfil"),
            ),
          ],
        ),
      ),
    );
  }
}
