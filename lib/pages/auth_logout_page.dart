import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/welcome_page.dart';
import 'package:grupolaranja20212/view_models/logout_view_model.dart';
import 'package:provider/provider.dart';

class AuthLogoutPage extends StatefulWidget {
  const AuthLogoutPage({Key? key}) : super(key: key);

  @override
  _AuthLogoutPage createState() => _AuthLogoutPage();
}

class _AuthLogoutPage extends State<AuthLogoutPage> {
  late LogoutViewModel _logoutVM = LogoutViewModel();
  var _btnLogoutTxt = "Logout";

  void _logout(BuildContext context) async {
    final success = await _logoutVM.logout();
    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    } else {
      setState(() {
        _btnLogoutTxt = "Opa, não foi possível realizar o Logout";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logoutVM = Provider.of<LogoutViewModel>(context);

    return MaterialApp(
      title: 'Logout',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Logout'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () {
                _logout(context);
              },
              child: Text(_btnLogoutTxt)),
        ),
      ),
    );
  }
}
