import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/matches_chat_page.dart';
import 'package:grupolaranja20212/pages/matches_map_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  _MatchesPage createState() => _MatchesPage();
}

class _MatchesPage extends State<MatchesPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MatchesChatPage(),
    MatchesMapPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matches',
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey.shade500,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: ("Conversas")),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), label: ("Mapa")),
          ],
        ),
      ),
    );
  }
}
