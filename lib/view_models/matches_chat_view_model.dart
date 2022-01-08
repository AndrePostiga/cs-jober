import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/chat_users_model.dart';
import 'package:grupolaranja20212/models/match_message.dart';
import 'package:grupolaranja20212/services/messages_service.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class MatchesChatViewModel extends ChangeNotifier {
  Future<List<MatchChatUser>> getMatchesChatFromUser(
      String firebaseAuthUid) async {
    var machesUsers = await UserService().getMatchesUsers(firebaseAuthUid);

    var matchChatUser = <MatchChatUser>[];

    for (var matchUser in machesUsers) {
      var lastMatchMessage = await MessagesService()
          .getLastMessageBetweenFirebaseUids(
              <String>[firebaseAuthUid, matchUser.firebaseAuthUid]);

      lastMatchMessage ??= MatchMessage(
          firebaseAuthUid + "->",
          DateTime.now().subtract(Duration(days: 1)),
          "---> Sem mensagens ainda <---");

      matchChatUser.add(MatchChatUser(matchUser, lastMatchMessage));
    }

    matchChatUser
        .sort((a, b) => (a.msg.createdAt.isAfter(b.msg.createdAt) ? 0 : 1));

    return matchChatUser;
  }
}
