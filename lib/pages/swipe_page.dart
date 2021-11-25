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
                AppNavigator.navigateToLoginPage(context);
              },
              child: const Text('LOGIN'),
            ),
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToRegisterPage(context);
              },
              child: const Text('REGISTER'),
            ),
          ],
        )),
      ),
    );
  }
}
