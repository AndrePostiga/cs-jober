import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/chat_users_model.dart';
import 'package:grupolaranja20212/widget/conversation_list.dart';

class MatchesChatPage extends StatefulWidget {
  const MatchesChatPage({Key? key}) : super(key: key);

  @override
  _MatchesChatPage createState() => _MatchesChatPage();
}

class _MatchesChatPage extends State<MatchesChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Albert",
        msgTxt: "Olá!, Bem-vindo ao processo seletivo",
        imageUrl: "images/image1.jpeg",
        time: "15:01"),
    ChatUsers(
        name: "Alan",
        msgTxt: "Fala amigo, o processo pro estágio ta rolando",
        imageUrl: "images/image2.jpeg",
        time: "09:23"),
    ChatUsers(
        name: "Marie",
        msgTxt: "Tudo bem, aguardamos seu retorno",
        imageUrl: "images/image3.jpeg",
        time: "Ontem"),
    ChatUsers(
        name: "Steve",
        msgTxt: "Bom dia candidato, o feedback irá para o seu email",
        imageUrl: "images/image4.jpeg",
        time: "23/10/21"),
    ChatUsers(
        name: "Amanda",
        msgTxt: "Olá candidato",
        imageUrl: "images/image5.jpeg",
        time: "22/10/21"),
    ChatUsers(
        name: "Julia",
        msgTxt: "Somos da empresa Alfa e gostamos muito do seu perfil",
        imageUrl: "images/image5.jpeg",
        time: "20/10/21"),
    ChatUsers(
        name: "Steve",
        msgTxt: "Qualquer dúvida entre em contato conosco",
        imageUrl: "images/image6.jpeg",
        time: "13/09/21"),
  ];
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
            itemCount: chatUsers.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ConversationList(
                name: chatUsers[index].name,
                msgTxt: chatUsers[index].msgTxt,
                imageUrl: chatUsers[index].imageUrl,
                time: chatUsers[index].time,
                isMessageRead: (index == 0 || index == 3) ? true : false,
              );
            },
          ),
        ],
      ),
    );
  }
}
