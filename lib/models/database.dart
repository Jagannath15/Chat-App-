

 import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore _db=FirebaseFirestore.instance; 

addfrnd(String uid,String email) async{
    _db.collection("users").doc(uid.toString()).collection('frnds').doc(email.toString()).set(
      {
        'email':email.toString()
      }
    );
}



sendmessage(String senderuid,String reciverid,String msg,String email,String grpid){
   String time=DateTime.now().hour.toString()+':'+DateTime.now().minute.toString();
   _db.collection('messages').doc(grpid.toString()).collection('message').doc().set(
    {
      'message':msg.toString(),
      'sender':senderuid.toString(),
       'reciver':reciverid,
       'type':"text",
       'email':email.toString(),
       'imgurl':'',
       'timestamp': FieldValue.serverTimestamp(),
         'time':time.toString()
    }
   );
}

sendimg(String senderuid,String reciverid,String msg,String email,String grpid,String imgurl){
  String time=DateTime.now().hour.toString()+':'+DateTime.now().minute.toString();
   _db.collection('messages').doc(grpid.toString()).collection('message').doc().set(
    {
      'message':'',
      'sender':senderuid.toString(),
       'reciver':reciverid,
       'type':"img",
       'email':email.toString(),
       'imgurl':imgurl.toString(),
      'timestamp': FieldValue.serverTimestamp(),
      'time':time.toString()

    }
   );
}








