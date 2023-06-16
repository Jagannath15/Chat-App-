import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AccountInfo extends StatefulWidget {
  String img;
  String name;
  String email;
  String uid;
  AccountInfo(
      {super.key, required this.img, required this.name, required this.email, required this.uid});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  
  Widget build(BuildContext context) {
    TextEditingController _name=TextEditingController();
     File? imgfile;
       Future uploadimg() async {
                  String filename = Uuid().v1();
                  var ref = FirebaseStorage.instance
                      .ref()
                      .child('profiles')
                      .child('$filename.jpg');

                  var uploadtask = await ref.putFile(imgfile!);

                  String imgurl = await uploadtask.ref.getDownloadURL();

                  FirebaseFirestore.instance.collection('users').doc(widget.uid.toString()).update({
                    'img':imgurl.toString()
                  });

                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  await  prefs.setString('img',imgurl.toString());

                    setState(() {
                      widget.img=imgurl.toString();
                    });
                  
                   print(imgurl.toString());
                }




   
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              onTap: () {
                
                ImagePicker _picker = ImagePicker();
                _picker.pickImage(source: ImageSource.gallery).then((xFile) {
                  imgfile = File(xFile!.path);
                  uploadimg();
                });

               
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(widget.img.toString()),
                    radius: 60,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Color(0xff35bc90), shape: BoxShape.circle),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(

            leading: Text(
              'Name:',
              style: TextStyle(fontSize: 16),
            ),
            title: TextField(
              controller: _name,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: Text(widget.name),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                disabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Text(
              'Email:',
              style: TextStyle(fontSize: 16),
            ),
            title: TextField(
              enabled: false,
              decoration: InputDecoration(
                label: Text(widget.email),
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                disabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Color(0xff35bc90)),
                    ),
                    child: Text("Cancel"),
                  ),
                  InkWell(
                    onTap: () async{
                       if(_name.text.toString()==widget.name.toString()){
                         ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Enter new Name'),backgroundColor: Colors.red,)
                        );
                       }
                       if (_name.text.isEmpty || _name.text=='') {
                         ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enter Valid Name'),backgroundColor: Colors.red,)
                  );
                       }
                      

                  await   FirebaseFirestore.instance.collection('users').doc(widget.uid.toString()).update({
                    'name':_name.text.toString()
                  });

                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  await  prefs.setString('name',_name.text.toString());

                 setState(() {
                    widget.name=_name.text;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Name Updated to" + _name.text),backgroundColor: Colors.green,)
                  );

                 Navigator.of(context).pop();

                       
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff35bc90)),
                      child: Text("Save"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
