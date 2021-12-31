import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/view_models/swipe_view_model.dart';
import 'package:grupolaranja20212/widget/swipe_card.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';
import 'package:grupolaranja20212/models/user.dart' as user_model;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SwipeViewModel _swipeVM = SwipeViewModel();
  final CardProvider _cardProvider = CardProvider();

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
    swipe(),
    const MatchesPage(),
    const UserRegisterPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _getUsersToSwipeAndUpdateLocationIfItcouldBeDone();
  }

  late List<user_model.User> _usersToSwipe = <user_model.User>[];

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    }

    _getUsersToSwipeAndUpdateLocationIfItcouldBeDone();
  }

  Future _getUsersToSwipeAndUpdateLocationIfItcouldBeDone() async {
    var loggedUser = await _swipeVM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);

    if (loggedUser == null) {
      setState(() {
        // redir pro register page
        _selectedIndex = 2;
      });
    } else {
      await _swipeVM.updateUserLocation(FirebaseAuth.instance.currentUser!.uid);

      var usersToSwipe = await _swipeVM.getUsersToSwipe(loggedUser, null);

      setState(() {
        _usersToSwipe = usersToSwipe;
      });
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

  Widget swipe() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 580,
              child: buildCards(), //SizedBox(height: 500), /*buildCards()*/
            ),
            const SizedBox(
              height: 16,
            ),
            buildButtons()
          ],
        )
        //buildCards(),
        );
  }

  Widget buildCards() {
    final urlImages = _cardProvider.urlImages;

    return Stack(
      children: urlImages
          .map((urlImage) => SwipeCard(
                urlImage: urlImage,
                isFront: urlImages.last == urlImage,
              ))
          .toList(),
    );
  }

  Widget buildButtons() {
    final status = _cardProvider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSkip = status == CardStatus.skip;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Icon(Icons.clear, size: 48),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.red, Colors.white, isDislike),
            backgroundColor: getColor(Colors.white, Colors.red, isDislike),
          ),
          onPressed: () {
            _cardProvider.dislike();
          },
        ),
        ElevatedButton(
          child: const Icon(
            Icons.skip_next_rounded,
            size: 48,
          ),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.orange, Colors.white, isSkip),
            backgroundColor: getColor(Colors.white, Colors.orange, isSkip),
          ),
          onPressed: () {
            _cardProvider.skip();
          },
        ),
        ElevatedButton(
          child: const Icon(
            Icons.favorite,
            size: 48,
          ),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.teal, Colors.white, isLike),
            backgroundColor: getColor(Colors.white, Colors.teal, isLike),
          ),
          onPressed: () {
            _cardProvider.like();
          },
        ),
      ],
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }
}
