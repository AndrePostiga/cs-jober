import 'package:flutter/cupertino.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';



class ChatUsers{
  String name;
  String msgTxt;
  String imageUrl;
  String time;
  ChatUsers({required this.name, 
            required this.msgTxt, 
            required this.imageUrl,
            required this.time});
}