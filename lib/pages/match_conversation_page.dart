import 'package:flutter/material.dart';

class MatchConversationPage extends StatelessWidget {
  const MatchConversationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversa',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Conversa'),
        ),
        body: const Center(
          child: Text('Conversa com um match escolhido'),
        ),
      ),
    );
  }
}
