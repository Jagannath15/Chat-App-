
import 'package:chat_app/Screens/message.dart';
import 'package:chat_app/Screens/search.dart';
import 'package:chat_app/Screens/signin.dart';
import 'package:chat_app/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var data;
  String? uid;
  String? name;
  String? email;
  String? img;
  FirebaseFirestore _db=FirebaseFirestore.instance;

  void initState() {
    // TODO: implement initState
    super.initState();
    gatherdata();
  }

   gatherdata() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(()   {
      uid=  prefs.getString('uid');
      name=  prefs.getString('name');
      email= prefs.getString('email');
      img=  prefs.getString('img');
    });
    
   
  }

  Widget build(BuildContext context) {
   
    print(uid.toString());
    return Scaffold(

      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(
       
          gradient: LinearGradient(colors: [Color(0xff21b7f3),Color(0xff35bc90)]),),),
        leading: Builder(
          builder: (context) {
           return GestureDetector(
            onTap: ()=> Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                foregroundImage:NetworkImage(img.toString()) ,
                ),
            ),
           );
          },
        ),

        title: Center(child: Text("Chats",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.w500),)),
        actions: [IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),)), icon: Icon(Icons.search))],
      ),


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

                InkWell(
                  onTap: () async{
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await FirebaseAuth.instance.signOut();
                    await prefs.remove('uid');
                    await prefs.remove('name');
                    await prefs.remove('email');
                    await prefs.remove('img');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SigninPage()), (route) => false);
                    
                  },
                  child: ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text("Sign out"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Container(
        child:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('uid',isNotEqualTo: uid).snapshots(),
          builder: ( BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){             

              if(snapshot.hasData){
                var getime=DateTime.now();
                var ftime=getime.hour.toString()+":"+getime.minute.toString();
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final docs= snapshot.data!.docs[index];
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MessagePage(
                          email: docs['email'].toString(),
                          name: docs['name'].toString(),
                          img: docs['img'].toString(),
                          recuid: docs['uid'].toString(),
                          sendruid: uid.toString(),

                        )));
                      },
                      child: ListTile(
                        leading: CircleAvatar(foregroundImage: NetworkImage(docs['img'].toString()),),
                        title: Text(docs['name'].toString()),
                        subtitle: Text(docs['email'].toString()),
                        trailing: Text(ftime.toString()),
                      ),
                    );
                  },
                  
                  );
              }
              return Center(child: CircularProgressIndicator());
          }
        ) ,)












      // floatingActionButton: FloatingActionButton(onPressed: ()  {
      
      //   getfrnds(uid.toString());


      //   TextEditingController _email=  TextEditingController();
      //  showDialog(context: context, builder: (context) {
      //     return    AlertDialog(
      //         title: Text("Add User"),
      //         content: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             TextField(
      //               controller: _email,
      //               decoration: InputDecoration(
      //                 enabledBorder: OutlineInputBorder(),
      //                 labelText: "Enter Email id"
      //               ),
      //             )
      //           ],
      //         ),
      //         actions: [
      //           TextButton(onPressed: () async{
      //               addfrnd(uid.toString(), _email.text);
      //           }, child: Text("Add User"))
      //         ],
      //     );
      //  },);
       
          
      // },
      // child: Icon(Icons.add),
      // ), 
    );
  }
}
