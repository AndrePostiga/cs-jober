import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class MatchesMapPage extends StatelessWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
