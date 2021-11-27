import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class SwipePage extends StatelessWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Swipe'),
        ),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToLogoutPage(context);
              },
              child: const Text('LOGOUT'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMatchesPage(context);
              },
              child: const Text('MATCHES'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToMainPage(context);
              },
              child: const Text('MAIN PAGE (SWIPE)'),
            ),
          ],
        )),
      ),
    );
  }
}
