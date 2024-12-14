import 'package:diary_app/DiaryPage/Page1/diary_screen_top.dart';
import 'package:diary_app/DiaryPage/Page1/profile_bar.dart';
import 'package:diary_app/DiaryPage/homepage.dart';
import 'package:diary_app/DiaryPage/Page1/home_screen1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:diary_app/Login_Signup/Screen/login.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot) {
          if (snapshot.hasData)
            return HomeScreen();
          return LoginScreen();
        })
    );
  }
}
