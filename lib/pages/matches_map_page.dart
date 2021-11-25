import 'package:flutter/material.dart';

class MatchesMapPage extends StatelessWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mapa'),
        ),
        body: const Center(
          child: Text('Mapa'),
        ),
      ),
    );
  }
}
