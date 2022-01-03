import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/swipe_item_content.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;
  final List<String> _names = ["Red", "Blue", "Green", "Yellow", "Orange"];
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];

  @override
  void initState() {
    for (int i = 0; i < _names.length; i++) {
      _swipeItems.add(SwipeItem(
          content: SwipeItemContent(_names[i], _colors[i]),
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Liked ${_names[i]}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Nope ${_names[i]}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Superliked ${_names[i]}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          }));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 550,
        child: SwipeCards(
          matchEngine: _matchEngine,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              alignment: Alignment.center,
              color: _swipeItems[index].content.color,
              child: Text(
                _swipeItems[index].content.text,
                style: const TextStyle(fontSize: 100),
              ),
            );
          },
          onStackFinished: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Stack Finished'),
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                _matchEngine.currentItem?.nope();
              },
              child: const Text("Nope")),
          ElevatedButton(
              onPressed: () {
                _matchEngine.currentItem?.superLike();
              },
              child: const Text("Superlike")),
          ElevatedButton(
              onPressed: () {
                _matchEngine.currentItem?.like();
              },
              child: const Text("Like"))
        ],
      )
    ]);
  }
}
