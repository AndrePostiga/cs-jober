import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  @override
  void initState() {
    super.initState();
    _populateAllIncidents();
  }

  void _populateAllIncidents() async {}

  void _navigateToRegisterPage(BuildContext context) async {
    final bool isRegistered =
        await AppNavigator.navigateToRegisterPage(context);
    if (isRegistered) {
      AppNavigator.navigateToLoginPage(context);
    }
  }

  void _navigateToLoginPage(BuildContext context) async {
    final bool isLoggedIn = await AppNavigator.navigateToLoginPage(context);
    if (isLoggedIn) {
      // go to the my incidents page
    }
  }

  void _navigateToMatchesPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MatchesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Latest Incidents")),
        drawer: Drawer(
            child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu")),
            const ListTile(title: Text("Home")),
            ListTile(
                title: const Text("Matches"),
                onTap: () async {
                  _navigateToMatchesPage(context);
                }),
            ListTile(
                title: const Text("Login"),
                onTap: () {
                  _navigateToLoginPage(context);
                }),
            ListTile(
                title: const Text("Register"),
                onTap: () {
                  _navigateToRegisterPage(context);
                }),
            ListTile(title: const Text("Logout"), onTap: () async {})
          ],
        )),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(""),
        ));
  }
}
