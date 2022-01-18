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
      // if the logout action was successfully executed... redirect to welcome page blocking user to back
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (Route<dynamic> route) => false);
    } else {
      // set alert on button txt warning user that was not possible make logout
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Logout'),
            backgroundColor: Colors.orange,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Aperte logout para sair'),
                TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.purple)),
                    onPressed: () {
                      _logout(context);
                    },
                    child: Text(_btnLogoutTxt)),
              ],
            ),
          ),
        ));
  }
}
