import 'package:diary_app/DiaryPage/Page1/home_screen1.dart';
import 'package:diary_app/DiaryPage/homepage.dart';
import 'package:diary_app/Login_Signup/Login_with_auth/google_auth.dart';
import 'package:diary_app/Login_Signup/PasswordForgot/forgot_password.dart';
import 'package:diary_app/snack_bar.dart';
import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:diary_app/Login_Signup/Widget/button.dart';
import 'package:diary_app/Login_Signup/Widget/text_field.dart';
import 'package:diary_app/Login_Signup/Screen/signup.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void LoginUsers() async {
    String res = await AuthServices().LoginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res == "success"){
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen1()));
    }
    else {
      setState(() {
        isLoading = false;
        showSnackbar(context, res);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("login_img.jpg")
              ),
              TextFieldInpute(textEditingController: emailController, hintText: "Email", icon: Icons.email),
              TextFieldInpute(textEditingController: passwordController,  hintText: "Enter your password", icon: Icons.lock, isPass:  true,),
              MyButton(onTab: LoginUsers, text: "Login"),
              ForgotPassword(),
              SizedBox(height: height / 30,),
              Row(
                children: [
                  Expanded(child: Container(height:1, color: Colors.black)),
                  Text("    or   "),
                  Expanded(child: Container(height: 1, color: Colors.black))
                ],
              ),
              Container(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  onPressed: () async {
                    String res = await FirebaseService().signInWithGoogle();
                    if (res == "success")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    else
                      showSnackbar(context, res);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("https://png.pngtree.com/png-clipart/20230916/original/pngtree-google-internet-icon-vector-png-image_12256707.png", height: 35, fit: BoxFit.contain),
                      Container(width: 10,),
                      Text("Continue with Google",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
                    ],
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.all(25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  onPressed: () async {
                    String res = await FirebaseService().signInWithGitHub();
                    if (res == "success")
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    else
                      showSnackbar(context, res);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network("https://cdn-icons-png.flaticon.com/512/25/25231.png", height: 35, fit: BoxFit.contain),
                      Container(width: 10,),
                      Text("Continue with Github", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
                    ],
                  )
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: TextStyle(fontSize: 16),),
                  GestureDetector(onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()));
                    },
                    child: Text("SignUp", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                
              ],)
            ],
          )
        ))
    );
  }
}