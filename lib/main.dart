import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:grupolaranja20212/widget/swipe_card.dart';
import 'package:grupolaranja20212/provider/card_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'JOBer';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => CardProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
            elevation: 8,
            primary: Colors.white,
            shape: const CircleBorder(),
            minimumSize: const Size.square(80),
          ))),
          home: const MainPage(),
        ),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.orange.shade200, Colors.black],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'JOBer',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 580,
                      child:
                          buildCards(), //SizedBox(height: 500), /*buildCards()*/
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    buildButtons()
                  ],
                )
                //buildCards(),
                ),
          )));

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final urlImages = provider.urlImages;

    return urlImages.isEmpty
        ? Center(
            child: ElevatedButton(
              child: const Text('Reinicia Lista'),
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

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSkip = status == CardStatus.skip;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Icon(Icons.clear, size: 48),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.red, Colors.white, isDislike),
            backgroundColor: getColor(Colors.white, Colors.red, isDislike),
          ),
          onPressed: () {
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.dislike();
          },
        ),
        ElevatedButton(
          child: const Icon(
            Icons.skip_next_rounded,
            size: 48,
          ),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.orange, Colors.white, isSkip),
            backgroundColor: getColor(Colors.white, Colors.orange, isSkip),
          ),
          onPressed: () {
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.skip();
          },
        ),
        ElevatedButton(
          child: const Icon(
            Icons.favorite,
            size: 48,
          ),
          style: ButtonStyle(
            foregroundColor: getColor(Colors.teal, Colors.white, isLike),
            backgroundColor: getColor(Colors.white, Colors.teal, isLike),
          ),
          onPressed: () {
            final provider = Provider.of<CardProvider>(context, listen: false);
            provider.like();
          },
        ),
      ],
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }
}
