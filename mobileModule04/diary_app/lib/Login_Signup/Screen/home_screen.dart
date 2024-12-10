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
          MyButton(onTab: () async{
            String res = await AuthServices().signOut();
            if (res == "success")
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
            else
              showSnackbar(context, res);
          },
          text: "Logout"),
        ],
      )
    );
  }
}
