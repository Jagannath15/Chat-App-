

 import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _db=FirebaseFirestore.instance; 

addfrnd(String uid,String email) async{
    _db.collection("users").doc(uid.toString()).collection('frnds').doc(email.toString()).set(
      {
        'email':email.toString()
      }
    );
}

 getfrnds(String uid) async {
final _doc=  _db.collection('users').doc(uid.toString()).collection('frnds').doc('shubhmmestry23@gmail.com').get();
var data;
_doc.then((DocumentSnapshot docs) {
   data=docs.data() as Map<String,dynamic>;
  print(data);
} 
).onError((error, stackTrace){
  print(error);
});
 return data;
}


sendmessage(String senderuid,String reciverid,String msg,String email){
   _db.collection('messages').doc(senderuid).collection('message').doc().set(
    {
      'message':msg.toString(),
       'reciver':reciverid,
       'email':email.toString()

    }
   );
}



