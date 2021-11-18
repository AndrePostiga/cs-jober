import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grupolaranja20212/widget/swipe_card.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'JOBer';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          home: MainPage(),
        ),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: buildCards(),
          ),
        ),
      );

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;

    return urlImages.isEmpty
        ? Center(
            child: ElevatedButton(
              child: Text('Reinicia Lista'),
              onPressed: () {
                final provider =
                    Provider.of<CardProvider>(context, listen: false);
                provider.resetUsers();
              },
            ),
          )
        : Stack(
            children: urlImages
                .map((urlImage) => SwipeCard(
                      urlImage: urlImage,
                      isFront: urlImages.last == urlImage,
                    ))
                .toList(),
          );
  }
}
