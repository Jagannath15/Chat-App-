import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  @override

  String? uid;
  String? name;
  String? email;
  String? img;

  void initState() {
    // TODO: implement initState
    super.initState();
    gatherdata();
  }

   gatherdata() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      uid=prefs.getString('uid');
      name=prefs.getString('name');
      email=prefs.getString('email');
      img=prefs.getString('img');
    });
  }

  Widget build(BuildContext context) {
    print(uid.toString());
    return Scaffold(
      drawer: Drawer(
        child: Column(

          children: [
            UserAccountsDrawerHeader(
                    
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xff21b7f3),Color(0xff35bc90)]),
              ),
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(img.toString()),
              ),
              accountName: Text(name.toString()),
              accountEmail: Text(email.toString()),
            ),
            ListView(
              shrinkWrap:true ,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                ),
                
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text("Update account info"),
                ),

                ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text("Sign out"),
                )
              ],
            )
          ],
        ),
      ),
      body: Center(
        child: Column(

        children: [
          Text(uid.toString()),
          Text(name.toString()),
          Text(email.toString())
        ],
        ),
      ) 
    );
  }
}