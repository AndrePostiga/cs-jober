import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupolaranja20212/widget/swipe_card.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';
import 'package:grupolaranja20212/pages/matches_page.dart';
import 'package:grupolaranja20212/pages/user_register_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    MatchesPage(),
    UserRegisterPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;

    return urlImages.isEmpty
        ? Center(
            child: ElevatedButton(
              child: const Text('Reinicia Lista'),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.resetUsers();
              },
            ),
          )
        : Stack(
            children: urlImages
                .map((urlImage) => SwipeCard(
                      urlImage: urlImage,
                      isFront: urlImages.last == urlImage,
                    ))
                .toList(),
          );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
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
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.dislike();
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
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.skip();
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
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.like();
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
