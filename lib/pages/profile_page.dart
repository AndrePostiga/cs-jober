import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/utils/constants.dart';
import 'package:grupolaranja20212/view_models/profile_view_model.dart';

String _getSkills(List<String> skills) {
  String str = '';

  str = skills.join(",");

  return str;
}

class ProfilePage extends StatefulWidget {
  final String userFirebaseAuthUid;

  const ProfilePage({Key? key, required this.userFirebaseAuthUid})
      : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

int _getYearOfUser(String birthDateString) {
  var birthParts = birthDateString.split('-');
  var birthDate = DateTime(int.parse(birthParts[0]), int.parse(birthParts[1]),
      int.parse(birthParts[2]));

  final now = new DateTime.now();

  int years = now.year - birthDate.year;
  int months = now.month - birthDate.month;
  int days = now.day - birthDate.day;

  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (days < 0 ? 11 : 12);
  }

  if (days < 0) {
    final monthAgo = new DateTime(now.year, now.month - 1, birthDate.day);
    days = now.difference(monthAgo).inDays + 1;
  }

  return years;
}

class _ProfilePage extends State<ProfilePage> {
  late final ProfileViewModel _vm = ProfileViewModel();
  late User _user = User(
      widget.userFirebaseAuthUid,
      "",
      "Carregando informações",
      "",
      Constants.userDefaultPhoto,
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
          title: Text('Perfil do ' + _user.name),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 70,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: _user.typeId == 1
                          ? new Text('Recrutador')
                          : new Text('Candidato')),
                  SizedBox(
                    height: 250,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_user.photoUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40.0))),
                      width: 230,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Text(
                      _user.name +
                          ',  ' +
                          (_getYearOfUser(_user.birthDate).toString()),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            _user.typeId == 1
                                ? new Text(
                                    'Habilidades desejadas: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : new Text(
                                    'Possuo tais habilidades: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            _user.skills.isNotEmpty == true
                                ? new Container(
                                    child: Text(_getSkills(_user.skills)),
                                  )
                                : new Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Linkedin:     ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(_user.linkedinUrl)
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Descrição:  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(_user.description)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
