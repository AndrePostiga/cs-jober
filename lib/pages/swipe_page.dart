import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart' as user_model;
import 'package:grupolaranja20212/view_models/swipe_view_model.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({Key? key}) : super(key: key);

  @override
  _SwipePage createState() => _SwipePage();
}

class _SwipePage extends State<SwipePage> {
  final SwipeViewModel _vM = SwipeViewModel();
  late user_model.User? user;
  late List<user_model.User> _usersToSwipe = <user_model.User>[];

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  late MatchEngine _matchEngine;
  late Widget _swipeItem;

  Future getUsersToSwipe() async {
    _usersToSwipe = await _vM.getUsersToSwipe(user!, null);
  }

  Future startPage() async {
    user = await _vM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);
    await populateSwipeItens();
  }

  Future populateSwipeItens() async {
    await getUsersToSwipe();
    for (var user in _usersToSwipe) {
      _swipeItems.add(SwipeItem(
          content: user,
          likeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gostou do(a) ${user.name}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          nopeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Não gostou do(a) ${user.name}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          superlikeAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gostou do(a) ${user.name}"),
                duration: const Duration(milliseconds: 500),
              ),
            );
          }));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);

    setState(() {
      _swipeItem = _makeSwipeCards();
    });
  }

  @override
  void initState() {
    _swipeItem = _defaultContainer();
    startPage();
    super.initState();
  }

  Widget _defaultContainer() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        "Aguarde",
        style: TextStyle(fontSize: 100),
      ),
    );
  }

  Widget _makeSwipeCards() {
    return SwipeCards(
      matchEngine: _matchEngine,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          alignment: Alignment.center,
          color: Colors.blue,
          child: Text(
            _swipeItems[index].content.name,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 450,
        child: _swipeItem,
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
