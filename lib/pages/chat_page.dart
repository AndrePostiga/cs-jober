import 'package:flutter/material.dart';
import 'package:grupolaranja20212/models/chat_users_model.dart';
import 'package:grupolaranja20212/widget/conversation_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Conversas",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink[50],
                    ),
                    child: Row(
                      children: const <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.pink,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Match",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Pesquisar...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                ),
              ),
            ),
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
      ),
    );
  }
}
