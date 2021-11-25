import 'package:flutter/material.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matches',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Matches'),
        ),
        body: const Center(
          child: Text('Lista de conversas com os Matches'),
        ),
      ),
    );
  }
}
