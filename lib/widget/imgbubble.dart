import 'package:flutter/material.dart';

class ImgBubble extends StatelessWidget {
  String time;
  String img;
  bool isCurrentUser;
   ImgBubble({super.key, required this.img, required this.isCurrentUser,required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
    
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
        child: Align(
          alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height/2.6,
                width: MediaQuery.of(context).size.width/1.6 ,
                child: Image(image: NetworkImage(img.toString())),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2.5,color: isCurrentUser ?  Color(0xff35bc90) :Color(0xff21b7f3)),
                ),
              ),
              Text(time.toString(),style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700
            ),)
            ],
          ),
        ),
      );

      
  }
}