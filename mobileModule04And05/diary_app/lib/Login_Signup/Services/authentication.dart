import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/Login_Signup/Screen/login.dart';
import 'package:diary_app/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AuthServices {
  //for storing data in clould firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser(
    {required String email,
      required String password,
      required String name}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty)
      {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password);
        await _firestore.collection("users").doc(credential.user!.uid).set({
            'name':name,
            'email':email,
            'uid':credential.user!.uid,
          }
        );
        res = "success";
        print("Signup success");
      }
      else {
        res = "Please fill all the fields.";
      }
    }
    catch (e) {
      res = e.toString();
      print(res);
    }
    return (res);
  }

  Future<String> LoginUser(
    {required String email,
      required String password,
    }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty &&  password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
        print("Login success");
      }
      else {
        res = "Please enter all the fields.";
      }
    }
    catch (e) {
      res = e.toString();
      print(res);
    }
    return (res);
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      print("Logout success!");
      return "success";
    }
    catch (e) {
      print(e.toString());
      return (e.toString());
    }
  }
  Future<void> signOut2(res, context) async {
    if (res == "success")
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    else
      showSnackbar(context, res);
  }
}
