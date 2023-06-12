

import 'package:chat_app/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  String sendruid;
  String recuid;
  String name;
  String img;
  String email;

   MessagePage({super.key,
  required this.email,
  required this.name,
  required this.img,
  required this.recuid,
  required this.sendruid,
  });

  @override
  Widget build(BuildContext context) {
    var doc=FirebaseFirestore.instance.collection("messages").doc(sendruid).collection('message').where('email',isEqualTo: email).snapshots();
    TextEditingController _msg=TextEditingController();
    return  Scaffold(

      appBar: AppBar(
        leadingWidth: double.minPositive,
        leading: Container(         
          child: Row(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
              SizedBox(width: 3,),
             CircleAvatar(foregroundImage: NetworkImage(img.toString()),),
              SizedBox(width: 7,),
             Text(name.toString())
            ],
          ),
        ),

         
      ),



      body: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            Expanded(child:Container(
              child: StreamBuilder 
              (
                stream: doc,
                builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {

                  if(snapshot.hasData){
                    ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var docs=snapshot.data!.docs[index];
                      print(docs['message']);
                      return ListTile(title: Text(docs['message'].toString()),);
                    },);

                  }
                  
                  return CircularProgressIndicator();
                } ,
            
                ),
            ) 

            
            ),





             Row(
              children: [
                SizedBox(width: 5,),
                Expanded(
                  child: Material(
                    elevation: 40,
                    borderRadius: BorderRadius.circular(25),
                    child: Container(    
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), 
                      child: TextField(
                        controller: _msg,
                        style: TextStyle(fontSize: 20),
                         cursorColor: Color.fromARGB(255, 65, 118, 197) ,
                         decoration: InputDecoration(
                          hintText: "Type message here",
                          hintStyle: TextStyle(fontSize: 20),
                          focusColor:  Color.fromARGB(255, 65, 118, 197),
                         border: InputBorder.none
                         ),
                      ),
                      
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                IconButton(
                      onPressed: () async{
                    await  sendmessage(sendruid, recuid, _msg.text,email.toString() );
                    _msg.clear();
                      },
                      icon: Icon(Icons.send,color:  Color.fromARGB(255, 65, 118, 197),)),
              ],
            ),

          ],
        ),
      )
      
    );
  }
}