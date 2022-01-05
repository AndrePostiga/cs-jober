import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/swipe_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/view_models/main_view_model.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainViewModel _swipeVM = MainViewModel();

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

  late final List<Widget> _widgetOptions = <Widget>[
    const SwipePage(),
    const MatchesPage(),
    const UserRegisterPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _updateLocationIfItcouldBeDone();
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    }

    _updateLocationIfItcouldBeDone();
  }

  Future _updateLocationIfItcouldBeDone() async {
    var loggedUser = await _swipeVM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    if (loggedUser == null) {
      setState(() {
        // redir pro register page
        _selectedIndex = 2;
      });
    } else {
      await OneSignal.shared
          .setExternalUserId(FirebaseAuth.instance.currentUser!.uid);
      await _swipeVM.updateUserLocation(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade200, Colors.black],
        ),
      ),
      child: Scaffold(
        appBar: _titleOptions.elementAt(_selectedIndex),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
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
                  semanticLabel: 'Matches',
                ),
                label: 'Matches'),
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
      ));
}
