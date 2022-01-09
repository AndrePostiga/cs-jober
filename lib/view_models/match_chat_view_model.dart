import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/match_message.dart';
import 'package:grupolaranja20212/models/user.dart';
import 'package:grupolaranja20212/services/messages_service.dart';
import 'package:grupolaranja20212/services/push_notification_service.dart';
import 'package:grupolaranja20212/services/user_service.dart';

class MatchChatViewModel extends ChangeNotifier {
  Future<User?> getUserByFirebaseAuthUid(String firebaseAuthUid) async {
    return await UserService().getUserByFirebaseAuthUid(firebaseAuthUid);
  }

  Future<List<MatchMessage>> getMessagesBetweenFirebaseUids(
      List<String> firebaseAuthUids) async {
    return await MessagesService()
        .getMessagesBetweenFirebaseUids(firebaseAuthUids);
  }

  Future addMsg(User fromUser, User toUser, String text) async {
    await MessagesService()
        .addMsg(fromUser.firebaseAuthUid, toUser.firebaseAuthUid, text);

    if (toUser.oneSignalId != "") {
      await PushNotificationService().sendNotification(
          <String>[toUser.oneSignalId],
          text,
          "Nova mensagem de " + fromUser.name,
          null,
          {"page": "chat", "key": toUser.firebaseAuthUid});
    }
  }
}
