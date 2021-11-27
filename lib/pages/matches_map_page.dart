import 'package:flutter/material.dart';

class MatchesMapPage extends StatelessWidget {
  const MatchesMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Mapa'),
        ),
        body: const Center(
          child: Text('Mapa mostrando onde os matches estao'),
        ),
      ),
    );
  }
}
