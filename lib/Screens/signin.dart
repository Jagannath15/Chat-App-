import 'package:chat_app/Screens/home.dart';
import 'package:chat_app/models/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
  
    var md=MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container( 
              margin: EdgeInsets.symmetric(vertical:md.height*0.12,horizontal: md.width*0.23),
                child: Image(
                  
                  image: AssetImage("assets/chat.png")),
              ),
            ),
            Container
            (
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: md.width*0.23), 
              child: 
            Text("Always be there, even when you're far away.",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            maxLines: 2,
            textAlign: TextAlign.center,
            )
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
      
        onTap: () async{
         await Authentication.signInWithGoogle(context: context);
       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(),));


         
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 30),
          height: md.height*0.08,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff21b7f3),Color(0xff35bc90)]),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/google.png"),
              SizedBox(width: 5,),
              Text("Continue with Google",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}