import 'package:flutter/material.dart';
import 'package:grupolaranja20212/utils/app_navigator.dart';

class ChatPage extends StatefulWidget{
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  @override
  Widget build (BuildContext context){
    return  Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only( left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Conversas", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
                    Container(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.add,color: Colors.pink,size: 20,),
                          SizedBox(width: 2,),
                          Text("Match", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    )
                  ],
                ),
              ))
          ],
        ),
      ),
    );
  }
}