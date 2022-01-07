import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future likeAction(user_model.User user, user_model.User likedUser) async {
    _user = await _vM.setLikedUser(user, likedUser.firebaseAuthUid);
    if (await _vM.isMatch(user, likedUser.firebaseAuthUid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Match com o(a) ${likedUser.name}!"),
          duration: const Duration(milliseconds: 1000),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gostou do(a) ${likedUser.name}"),
          duration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  Future populateSwipeItens() async {
    _swipeItems = <SwipeItem>[];

    if (_user != null) {
      var usersToSwipe = await _vM.getUsersToSwipe(_user!);

      for (var user in usersToSwipe) {
        if (!_alreadyPassedUsers.contains(user.firebaseAuthUid)) {
          _alreadyPassedUsers.add(user.firebaseAuthUid);
          _swipeItems.add(SwipeItem(
              content: user,
              likeAction: () async {
                await likeAction(_user!, user);
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
                await likeAction(_user!, user);
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
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40.0))),
      alignment: Alignment.center,
      child: const Center(
          child: Text(
        "Não foram encontrados usuários na sua região, com os filtros definidos",
        style: TextStyle(fontSize: 50),
      )),
    );
  }

  Widget _loadingContainer() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40.0))),
      alignment: Alignment.center,
      child: const Center(
          child: Text(
        "Aguarde... Carregando...",
        style: TextStyle(fontSize: 50),
      )),
    );
  }

  Widget _makeSwipeCards() {
    return SwipeCards(
      matchEngine: _matchEngine,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_swipeItems[index].content.photoUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(40.0))),
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: const LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.7, 1])),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            Text(
                              _swipeItems[index].content.name,
                              style: const TextStyle(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              "18",
                              style:
                                  TextStyle(fontSize: 32, color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    )
                  ],
                )));
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
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
        height: 430,
        child: _swipeItem,
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 80.0,
            width: 80.0,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: const BorderSide(color: Colors.red))),
              ),
              onPressed: () {
                if (_swipeItems.isNotEmpty) {
                  _matchEngine.currentItem?.nope();
                }
              },
              child: const Icon(
                Icons.clear_rounded,
                color: Colors.red,
                size: 50,
              ),
            ),
          ),
          SizedBox(
              height: 80,
              width: 80,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(color: Colors.green))),
                ),
                onPressed: () {
                  if (_swipeItems.isNotEmpty) {
                    _matchEngine.currentItem?.like();
                  }
                },
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.green,
                  size: 50,
                ),
              ))
        ],
      )
    ]);
  }
}
