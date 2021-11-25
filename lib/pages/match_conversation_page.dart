import 'package:flutter/material.dart';

class MatchConversationPage extends StatelessWidget {
  const MatchConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversa',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Conversa'),
        ),
        body: const Center(
          child: Text('Conversa'),
        ),
      ),
    );
  }
}
