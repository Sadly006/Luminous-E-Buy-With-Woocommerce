import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminous_e_buy/Screens/front_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSigning {


  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;
      print(user);

      if (result != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', 'true');
        prefs.setString('email', user!.email.toString());
        prefs.setString('userName', user.displayName.toString());
        String consKey = prefs.getString("consKey") as String;
        String consSecret = prefs.getString("consSecret") as String;
        Navigator.pop(context, true);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FrontPage(consKey: consKey, consSecret: consSecret,),
            )
        );
      }
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}