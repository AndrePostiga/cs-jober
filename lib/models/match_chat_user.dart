import 'package:grupolaranja20212/models/match_message.dart';
import 'package:grupolaranja20212/models/user.dart';

class MatchChatUser {
  final User matchedUser;
  final MatchMessage msg;

  MatchChatUser(this.matchedUser, this.msg);
}
