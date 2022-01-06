import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WelcomePage',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WelcomePage'),
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
