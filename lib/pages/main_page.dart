import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/swipe_page.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Grave seu perfil para utilizar o JOBer"),
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() {
        // redir to register page
        _selectedIndex = 2;
      });
    } else {
      // if user is logged... update the location
      await _swipeVM.updateUserLocation(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      var additionalData = result.notification.additionalData;

      if (additionalData!.containsKey("page")) {
        if (additionalData["page"] == "chat") {
          if (additionalData.containsKey("key")) {
            AppNavigator.navigateToMatchChatPage(
                context, additionalData["key"]);
          }
        }
      }
    });

    return Container(
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
}
