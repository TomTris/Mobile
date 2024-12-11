import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:diary_app/Login_Signup/Login_with_auth/google_auth.dart';
import 'package:diary_app/Login_Signup/Screen/login.dart';
import 'package:diary_app/Login_Signup/Screen/snack_bar.dart';
import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:diary_app/Login_Signup/Widget/button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Congratulation\nYou have log in successfully",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          MyButton(
            onTab: () async {
              String res = await AuthServices().signOut();
              AuthServices().signOut2(res, context);
            },
            text: 'Sign Out'),
        ],
      )
    );
  }
}
