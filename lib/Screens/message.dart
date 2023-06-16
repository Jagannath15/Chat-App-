import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:chat_app/widget/imgbubble.dart';
import 'package:chat_app/widget/videobubble.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:chat_app/Screens/home.dart';
import 'package:chat_app/models/database.dart';
import 'package:chat_app/widget/chatbubble.dart';
import 'dart:io';

class MessagePage extends StatefulWidget {
  String sendruid;
  String recuid;
  String name;
  String img;
  String email;

  MessagePage({
    super.key,
    required this.email,
    required this.name,
    required this.img,
    required this.recuid,
    required this.sendruid,
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  String grpid = '';
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  generategrpid() {
    if (widget.sendruid.compareTo(widget.recuid) > 0) {
      grpid = '${widget.sendruid}-${widget.recuid}';
    } else {
      grpid = '${widget.recuid}-${widget.sendruid}';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    generategrpid();
    super.initState();
  }

  File? imgfile;
  File? video;
  Future getimage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (XFile != null) {
        imgfile = File(xFile!.path);
        uploadimg().onError((error, stackTrace) => print(error));
      }

      if (kIsWeb) {
        return SnackBar(content: Text("Not available for web "));
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  Future uploadimg() async {
    String filename = Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$filename.jpg');

    var uploadtask = await ref.putFile(imgfile!);

    String imgurl = await uploadtask.ref.getDownloadURL();
    sendimg(widget.sendruid, widget.recuid, '', widget.email, grpid.toString(),
        imgurl.toString());
    print(imgurl.toString());
  }


Future getvideo() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickVideo(source: ImageSource.gallery).then((xFile) {
      if (XFile != null) {
        video = File(xFile!.path);
        uploadvideo().onError((error, stackTrace) => print(error));
      }

      if (kIsWeb) {
        return SnackBar(content: Text("Not available for web "));
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }


Future uploadvideo() async {
    String filename = Uuid().v1();
    var ref =
        FirebaseStorage.instance.ref().child('videos').child('$filename.mp4');

    var uploadtask = await ref.putFile(video!);

    String videourl = await uploadtask.ref.getDownloadURL();
    sendvideo(widget.sendruid, widget.recuid, '', widget.email, grpid.toString(), videourl.toString());
    print(videourl.toString());
  }








  Widget build(BuildContext context) {
    TextEditingController _msg = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xff21b7f3), Color(0xff35bc90)]),
          ),
        ),
        leadingWidth: double.maxFinite,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                      (route) => false);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            CircleAvatar(
              foregroundImage: NetworkImage(widget.img.toString()),
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  widget.email.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[50]),
                ),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .doc(grpid.toString())
                    .collection('message')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
      
                  return ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var docs = snapshot.data!.docs[index];
      
                      if(docs['type'].toString()=='text'){
                        return ChatBubble(text: docs['message'].toString(), isCurrentUser: docs['sender'].toString()==widget.sendruid.toString() ? true:false,time: docs['time'].toString(), );
                      }
      
                         if(docs['type'].toString()=='img'){
                        return ImgBubble(img: docs['imgurl'].toString(), isCurrentUser: docs['sender'].toString()==widget.sendruid.toString() ? true:false, time: docs['time'].toString());
                      }
      
      
                     
                     if(docs['type'].toString()=='video'){
                        return Videobubble(videourl: docs['videourl'].toString() , isCurrentUser: docs['sender'].toString()==widget.sendruid.toString() ? true:false,time: docs['time'].toString());
                     }
                    },
                  );
                },
              ),
            ),
           
            Container(
                margin: EdgeInsets.only(bottom: 5),
                 child: Row(
                  children: [
                    
                    Expanded(
                      child: Material(
                        
                        elevation: 40,
                        borderRadius: BorderRadius.circular(25),
                        child: Container(    
                        
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5), 
                          child: TextField(
                            controller: _msg,
                            style: TextStyle(fontSize: 16),
                             cursorColor: Color.fromARGB(255, 65, 118, 197) ,
                             decoration: InputDecoration(
                              hintText: "Type message here",
                              //image upload part
                              suffixIcon: SpeedDial(
                                
                                useRotationAnimation: true,
                                foregroundColor: Colors.white,
                                backgroundColor:  Color(0xff35bc90),
                                icon: Icons.attach_file,
                                activeIcon: Icons.close,
                               childMargin:  EdgeInsets.all(5),
                              mini: true,
                              children: [
                                SpeedDialChild(child: 
                                IconButton(icon: Icon(Icons.camera_alt), onPressed: () {
                                  getimage();
                                },),
                                ),
      
                                SpeedDialChild(child: 
                                IconButton(icon: Icon(Icons.video_camera_back), onPressed: () {
                                  getvideo();
                                },),
                                ),
                              ],
                             ),
                              hintStyle: TextStyle(fontSize: 16),
                              focusColor:  Color.fromARGB(255, 65, 118, 197),
                             border: InputBorder.none,
                          
                             ),
                          ),
                          
                        ),
                      ),
                    ),

                    IconButton(
                          onPressed: () async{
                              if(_msg.text.isEmpty || _msg==""){
               
                              }
               
                              if(_msg.text.isNotEmpty){
                                 await  sendmessage(widget.sendruid, widget.recuid, _msg.text,widget.email.toString() ,grpid.toString());
                                  _msg.clear();
                              }
                            
                       
                          },
                          icon: Icon(Icons.send,color: Color(0xff35bc90))),
                  ],
                           ),
               ),
      
          ],
        ),
      ),
    );
  }
}
