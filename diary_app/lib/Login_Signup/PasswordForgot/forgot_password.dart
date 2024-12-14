import 'package:diary_app/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 35),
    child: Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          myDialogBoxForgotPassword(context);
        },
        child: Text("Forgot password?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),),
        )
      )
    );
  }
}

void myDialogBoxForgotPassword(BuildContext context) {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return 
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
        child: Container(
          decoration: BoxDecoration(color:  Colors.white,borderRadius: BorderRadius.circular(30),),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Forgot Your Password",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19,),),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Enter the Email",hintText: "egabc@gmail.com"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                try {
                  await auth
                    .sendPasswordResetEmail(email: emailController.text)
                    .then((value) {
                      showSnackbar(context, "We have sent you the reset password link to your email ${emailController.text}. Please check it!");
                      Navigator.pop(context);
                      emailController.dispose();
                    }).onError((error, stackTrace) {
                      showSnackbar(context, error.toString());
                    });
                }
                catch (e){
                  showErrorDialog(context, e.toString());
                }
              },
              child: Text( "Send",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
              )
            ),
          ],)
        )
      );
    }
  );
}
