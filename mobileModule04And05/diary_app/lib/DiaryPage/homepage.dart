
import 'package:diary_app/DiaryPage/Page1/home_screen1.dart';
import 'package:diary_app/DiaryPage/Page2/home_screen2.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(image: AssetImage("assets/background.png"),
          //       fit: BoxFit.cover,)
          //   ),
          // ),
          Scaffold(
            body: Container(
              child: Stack (
                children: [
                  TabBarView(
                    children: [
                      HomeScreen1(),
                      HomeScreen2(),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container (
              color: Colors.transparent,
              child: const Material(
                color: Colors.transparent,
                child: TabBar(
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.blueGrey,
                  tabs: [
                    Tab(icon: Icon(Icons.person,),text: 'Profile'),
                    Tab(icon: Icon(Icons.calendar_today), text: 'Agenda'),
                  ]
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
