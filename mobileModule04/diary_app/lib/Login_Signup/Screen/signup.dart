import 'package:diary_app/Login_Signup/Screen/home_screen.dart';
import 'package:diary_app/Login_Signup/Screen/login.dart';
import 'package:diary_app/Login_Signup/Screen/snack_bar.dart';
import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:diary_app/Login_Signup/Widget/button.dart';
import 'package:diary_app/Login_Signup/Widget/text_field.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void signUpUser() async {
    String res = await AuthServicews().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text
    );
    //if signup is success, user has been created and navigate to the next screen, otherwise show the error message
    if (res == "success"){
      setState(() {
      isLoading = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else
    {
      setState(() {
        isLoading = false;
        showSnackbar(context, res);
      });
      //show the error message
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
                child: Image.asset("images/signup.png")
              ),
              TextFieldInpute(
                textEditingController: nameController,
                hintText: "Enter your name",
                icon: Icons.person),
              TextFieldInpute(
                textEditingController: emailController,
                hintText: "Email",
                icon: Icons.email),
              TextFieldInpute(
                textEditingController: emailController,
                hintText: "Enter your password",
                icon: Icons.lock),
              MyButton(onTab: signUpUser, text: "Sign up"),
              SizedBox(height: height / 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: TextStyle(fontSize: 16),),
                  GestureDetector(onTap: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                
              ],)
            ],
          )
        ))
    );
  }
}