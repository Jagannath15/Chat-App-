import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  String text;
  bool isCurrentUser;
  String time;
   ChatBubble({super.key, required this.text,required this.isCurrentUser, required this.time});

  @override
   Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
       
       child: Column(
      
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
         children: [
           BubbleSpecialOne(   
             isSender: isCurrentUser,
            text: text.toString(),
            color: isCurrentUser ?  Color(0xff35bc90) :Color(0xff21b7f3) ,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16
            ),
            ),
            Text(time.toString(), style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700
            ),)
         ],
       ) ,

      ),
    );
  }
}