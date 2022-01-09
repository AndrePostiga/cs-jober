import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/user.dart' as models_user;
import 'package:grupolaranja20212/models/match_message.dart';
import 'package:grupolaranja20212/services/messages_service.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/match_chat_view_model.dart';

class MatchChatPage extends StatefulWidget {
  final String matchUserFirebaseAuthUid;

  const MatchChatPage({Key? key, required this.matchUserFirebaseAuthUid})
      : super(key: key);

  @override
  _MatchChatPage createState() => _MatchChatPage();
}

class _MatchChatPage extends State<MatchChatPage> {
  final MatchChatViewModel _vM = MatchChatViewModel();

  final _msgController = TextEditingController();

  Future _sendMsg() async {
    if (_msgController.text != "") {
      await _vM.addMsg(_loggedUser, _matchedUser, _msgController.text);

      setState(() {
        _messages.add(MatchMessage(
            MessagesService().getFromToUidsAndConvertToUniqueKey(
                _loggedUser.firebaseAuthUid, _matchedUser.firebaseAuthUid),
            DateTime.now(),
            _msgController.text));
      });

      _msgController.text = "";
    }
  }

  List<MatchMessage> _messages = <MatchMessage>[];
  late models_user.User _loggedUser = models_user.User(
    FirebaseAuth.instance.currentUser!.uid,
    "",
    "Aguarde... Carregando informações...",
    "",
    "",
    0,
    "",
    0.0,
    0.0,
    1,
    <String>[],
    <String>[],
    <String>[],
    "",
  );
  late models_user.User _matchedUser = models_user.User(
    widget.matchUserFirebaseAuthUid,
    "",
    "Aguarde... Carregando informações...",
    "",
    "",
    0,
    "",
    0.0,
    0.0,
    1,
    <String>[],
    <String>[],
    <String>[],
    "",
  );

  Future _getMsgs() async {
    var msgs = await _vM.getMessagesBetweenFirebaseUids(
        <String>[widget.matchUserFirebaseAuthUid, _loggedUser.firebaseAuthUid]);

    setState(() {
      _messages = msgs;
    });
  }

  Future _getPageInfo() async {
    await _getMsgs();

    var gotMatchedUser =
        await _vM.getUserByFirebaseAuthUid(widget.matchUserFirebaseAuthUid);

    var gotLoggedUser =
        await _vM.getUserByFirebaseAuthUid(_loggedUser.firebaseAuthUid);

    if (gotLoggedUser != null) {
      setState(() {
        _loggedUser = gotLoggedUser;
      });
    }

    if (gotMatchedUser != null) {
      setState(() {
        _matchedUser = gotMatchedUser;
      });
    }
  }

  @override
  void initState() {
    _getPageInfo();
    super.initState();
    _vM.listenMessages(
        (matchMessage) => {
              setState(() {
                _messages.add(matchMessage);
              })
            },
        <String>[_loggedUser.firebaseAuthUid, widget.matchUserFirebaseAuthUid]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyanAccent,
        flexibleSpace: SafeArea(
            child: GestureDetector(
          onTap: () => {
            AppNavigator.navigateToProfilePage(
                context, widget.matchUserFirebaseAuthUid)
          },
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(_matchedUser.photoUrl),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _matchedUser.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: _messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Align(
                  alignment:
                      (_messages[index].toUserUid == _loggedUser.firebaseAuthUid
                          ? Alignment.topLeft
                          : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (_messages[index].toUserUid ==
                              _loggedUser.firebaseAuthUid
                          ? Colors.grey.shade200
                          : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _messages[index].text,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Digite sua mensagem...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      controller: _msgController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _sendMsg();
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
