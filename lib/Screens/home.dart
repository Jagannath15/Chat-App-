
import 'package:chat_app/Screens/message.dart';
import 'package:chat_app/Screens/search.dart';
import 'package:chat_app/models/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    
    data =getfrnds(uid.toString());
  }

  Widget build(BuildContext context) {
   
    print(uid.toString());
    return Scaffold(

      appBar: AppBar(
        
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

        title: Center(child: Text("Chats")),
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

                ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text("Sign out"),
                )
              ],
            )
          ],
        ),
      ),
      body: SizedBox(
        
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
                    return GestureDetector(
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
              return CircularProgressIndicator();
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
