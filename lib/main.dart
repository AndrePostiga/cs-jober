import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grupolaranja20212/Pages/todo_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListPage(),
      title: "Todo List",
    );
  }
}
