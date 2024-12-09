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
                child: Image.asset("images/login_img.jpg")
              ),
              TextFieldInpute(textEditingController: emailController, hintText: "Email", icon: Icons.email),
              TextFieldInpute(textEditingController: emailController, hintText: "Enter your password", icon: Icons.lock),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Forgot Password?",
                    style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue),)
                ),
              ),
              MyButton(onTab: () {}, text: "Login"),
              SizedBox(height: height / 15,),
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