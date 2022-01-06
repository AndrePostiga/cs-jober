import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userFirebaseAuthUid;

  const ProfilePage({Key? key, required this.userFirebaseAuthUid})
      : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text('Perfil do ' + widget.userFirebaseAuthUid),
        ),
        body: const Center(
          child: Text('Tela onde mostra o perfil selecionado'),
        ),
      ),
    );
  }
}
