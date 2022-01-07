import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/chat_users_model.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';
import 'package:grupolaranja20212/view_models/matches_chat_view_model.dart';

class MatchesChatPage extends StatefulWidget {
  const MatchesChatPage({Key? key}) : super(key: key);

  @override
  _MatchesChatPage createState() => _MatchesChatPage();
}

class _MatchesChatPage extends State<MatchesChatPage> {
  final MatchesChatViewModel _vM = MatchesChatViewModel();
  late List<MatchChatUser> _matchesChat = <MatchChatUser>[];

  Future _getMatchesChat() async {
    var msgs = await _vM
        .getMatchesChatFromUser(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      _matchesChat = msgs;
    });
  }

  @override
  void initState() {
    _getMatchesChat();
    super.initState();
  }

  Widget _buildConversationList(String matchFirebaseUserUid, String userImgUrl,
      String userName, String msgTxt, bool isMsgRead, String timeSentMsg) {
    return GestureDetector(
      onTap: () {
        AppNavigator.navigateToMatchChatPage(context, matchFirebaseUserUid);
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(userImgUrl),
                    maxRadius: 30,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            userName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            msgTxt,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: isMsgRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              timeSentMsg,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isMsgRead ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  "Conversas",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
          ListView.builder(
            itemCount: _matchesChat.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildConversationList(
                  _matchesChat[index].matchedUser.firebaseAuthUid,
                  _matchesChat[index].matchedUser.photoUrl,
                  _matchesChat[index].matchedUser.name,
                  _matchesChat[index].msg.text,
                  false,
                  "");
            },
          ),
        ],
      ),
    );
  }
}
