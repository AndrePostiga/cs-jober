import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/main_page.dart';
import 'package:grupolaranja20212/widget/swipe_card.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/swipe_view_model.dart';
import 'package:grupolaranja20212/models/user.dart' as user_model;

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  int _selectedIndex = 0;

  static final List<AppBar> _titleOptions = <AppBar>[
    AppBar(
      title: const Text('Swipe'),
      backgroundColor: Colors.orange,
    ),
    AppBar(
      title: const Text('Matches'),
      backgroundColor: Colors.orange,
    ),
    AppBar(
      title: const Text('Perfil'),
      backgroundColor: Colors.orange,
    ),
  ];

  final SwipeViewModel _swipeVM = SwipeViewModel();

  late List<user_model.User> _usersToSwipe = <user_model.User>[];

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    }

    _initPage();
  }

  Future _initPage() async {
    var loggedUser = await _swipeVM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    if (loggedUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const UserRegisterPage()),
          (Route<dynamic> route) => false);
    } else {
      await _swipeVM.updateUserLocation(FirebaseAuth.instance.currentUser!.uid);

      var usersToSwipe = await _swipeVM.getUsersToSwipe(loggedUser, null);

      setState(() {
        _usersToSwipe = usersToSwipe;
      });
    }
  }

  late final List<Widget> _widgetOptions = <Widget>[
    MainPage(),
    MatchesPage(),
    UserRegisterPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe',
      home: Scaffold(
        appBar: _titleOptions.elementAt(_selectedIndex),
        body: /*_widgetOptions.elementAt(_selectedIndex),*/
            Center(
                child: Column(
          children: [
            Text('Usuarios do swipe recuperados...' + _usersToSwipe.join(",")),
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
            ElevatedButton(
              onPressed: () {
                AppNavigator.navigateToUserRegisterPage(context);
              },
              child: const Text('EDIT DO USUARIO E PREFERENCIAS'),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.auto_awesome_motion_rounded,
                  semanticLabel: 'Swipe',
                ),
                label: 'Swipe'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_rounded,
                  semanticLabel: 'Matchs',
                ),
                label: 'Matchs'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_rounded,
                  semanticLabel: 'Perfil',
                ),
                label: 'Perfil'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
