import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn(
    clientId: '',
  );

  signInWithGoogle() async {
    try {
      print(1);
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      print(2);
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCredential);
      }
    }
    on FirebaseAuthException catch (e) {
      print('1212');
      print(e.toString()); 
    }
  }

}