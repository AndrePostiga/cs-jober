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
  late user_model.User? _user;
  late final List<String> _alreadyPassedUsers = <String>[];
  late List<SwipeItem> _swipeItems = <SwipeItem>[];

  late MatchEngine _matchEngine;
  late Widget _swipeItem;

  Future startPage() async {
    _user = await _vM
        .getUserByFirebaseAuthUid(FirebaseAuth.instance.currentUser!.uid);
    await populateSwipeItens();
  }

  Future populateSwipeItens() async {
    _swipeItems = <SwipeItem>[];

    if (_user != null) {
      var usersToSwipe = await _vM.getUsersToSwipe(_user!, null);

      for (var user in usersToSwipe) {
        if (!_alreadyPassedUsers.contains(user.firebaseAuthUid)) {
          _alreadyPassedUsers.add(user.firebaseAuthUid);
          _swipeItems.add(SwipeItem(
              content: user,
              likeAction: () async {
                _user = await _vM.setLikedUser(_user!, user.firebaseAuthUid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gostou do(a) ${user.name}"),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
              nopeAction: () async {
                _user = await _vM.setUnlikedUser(_user!, user.firebaseAuthUid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Não gostou do(a) ${user.name}"),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              },
              superlikeAction: () async {
                _user = await _vM.setLikedUser(_user!, user.firebaseAuthUid);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Gostou do(a) ${user.name}"),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              }));
        }
      }
    }

    setState(() {
      if (_swipeItems.isEmpty) {
        _swipeItem = _emptyAvailableUsersToSwipeContainer();
      } else {
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        _swipeItem = _makeSwipeCards();
      }
    });
  }

  @override
  void initState() {
    _swipeItem = _loadingContainer();
    startPage();
    super.initState();
  }

  Widget _emptyAvailableUsersToSwipeContainer() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        "Não foram encontrados usuários na sua região, com os filtros definidos",
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  Widget _loadingContainer() {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: const Text(
        "Aguarde... Carregando...",
        style: TextStyle(fontSize: 50),
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
      onStackFinished: () async {
        await populateSwipeItens();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carregando usuários... Aguarde...'),
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
                if (_swipeItems.isNotEmpty) {
                  _matchEngine.currentItem?.nope();
                }
              },
              child: const Text("Nope")),
          ElevatedButton(
              onPressed: () {
                if (_swipeItems.isNotEmpty) {
                  _matchEngine.currentItem?.like();
                }
              },
              child: const Text("Like"))
        ],
      )
    ]);
  }
}
