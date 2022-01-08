import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/view_models/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  final String userFirebaseAuthUid;

  const ProfilePage({Key? key, required this.userFirebaseAuthUid})
      : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late final ProfileViewModel _vm = ProfileViewModel();
  late User _user = User(
      widget.userFirebaseAuthUid,
      "",
      "Carregando informações",
      "",
      "https://firebasestorage.googleapis.com/v0/b/laranja20212.appspot.com/o/avatar.png?alt=media&token=780ef04c-eb05-4837-89ff-f93302d7db41",
      0,
      "Carregando...",
      0,
      0,
      0,
      <String>[],
      <String>[],
      <String>[],
      DateTime.now().toIso8601String());

  Future _getUser() async {
    var wantedUser =
        await _vm.getUserByFirebaseAuthUid(widget.userFirebaseAuthUid);
    if (wantedUser != null) {
      setState(() {
        _user = wantedUser;
      });
    }
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

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
          title: Text('Perfil do ' + _user.firebaseAuthUid),
        ),
        body: Center(
          child: Text('Tela onde mostra o perfil selecionado do ' + _user.name),
        ),
      ),
    );
  }
}
