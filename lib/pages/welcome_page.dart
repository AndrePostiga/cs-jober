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
          backgroundColor: Colors.orange,
          title: const Text('WelcomePage'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: 350,
              child: Image(image: AssetImage('assets/app_logo.png')),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
              onPressed: () {
                AppNavigator.navigateToLoginPage(context);
              },
              child: const Text('LOGIN'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple)),
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
