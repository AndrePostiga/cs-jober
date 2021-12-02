import 'package:flutter/material.dart';
import 'package:grupolaranja20212/pages/chat_detail_page.dart';

class ConversationList extends StatefulWidget{

  String name;
  String msgTxt;
  String imageUrl;
  String time;
  bool isMessageRead;
  ConversationList({Key? key, 
    required this.name,
    required this.msgTxt,
    required this.imageUrl,
    required this.time,
    required this.isMessageRead
  }) : super(key: key);

  @override 
  _ConversationListState createState() => _ConversationListState();
}



class _ConversationListState extends State<ConversationList>{
  @override 
  Widget build (BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context){
          return const ChatDetailPage();
        }));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
                    maxRadius: 30,
                  ),
                  const SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: const TextStyle(fontSize: 16),),
                          const SizedBox(height: 6,),
                          Text(widget.msgTxt, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time, style: TextStyle(fontSize: 12, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}