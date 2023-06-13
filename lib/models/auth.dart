
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/home.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    User? user;
    


    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
        final SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.setString("uid", user!.uid.toString());
          await prefs.setString("name", user.displayName.toString());
          await prefs.setString("email", user.email.toString());
          await prefs.setString("img", user.photoURL.toString());
          await prefs.setBool('islogged', true);

          FirebaseFirestore _db= await FirebaseFirestore.instance;
       await  _db.collection("users").doc(user.uid.toString())
        .set({
           'uid':user.uid.toString(),
          'name':user.displayName.toString() ,
          'email':user.email.toString(),
          'img':user.photoURL.toString()
        });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try   {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.setString("uid", user!.uid.toString());
          await prefs.setString("name", user.displayName.toString());
          await prefs.setString("email", user.email.toString());
          await prefs.setString("img", user.photoURL.toString());
          await prefs.setBool('islogged', true);

        FirebaseFirestore _db= await FirebaseFirestore.instance;
        _db.collection("users").doc(user.uid.toString())
        .set({
           'uid':user.uid.toString(),
          'name':user.displayName.toString(),
          'email':user.email.toString(),
          'img':user.photoURL.toString()
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);

        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }
}