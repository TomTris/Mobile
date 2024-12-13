import 'package:diary_app/DiaryPage/Page1/add_note.dart';
import 'package:diary_app/DiaryPage/Page1/diary_screen_top.dart';
import 'package:diary_app/DiaryPage/Page1/profile_bar.dart';
import 'package:diary_app/DiaryPage/Page1/showEntryBox.dart';
import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:diary_app/Login_Signup/Screen/snack_bar.dart';
import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:diary_app/Login_Signup/Widget/button.dart';
import 'package:flutter/material.dart';

class HomeScreen1 extends StatefulWidget {
  HomeScreen1({super.key});

  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1> {
  var entries;
  var userData;
  int isLoading = 0;
  List<dynamic> keys = [];
  List<dynamic> contents = [];

  String? dateTime1 = null;
  String? dateTime2 = null;
  String? feeling1 = null;
  String? feeling2 = null;
  String? title1 = "abc";
  String? title2 = null;
  String profileName = "Default";

  @override
  void initState() {
    super.initState();
    getEntries();
    getUserData();
  }

  Future<void> getEntries() async {
    entries = await FirebaseFirestoreService().getEntries();
    isLoading == isLoading + 1;

    if (entries != null)
    {
      keys = [];
      contents = [];
      for (int cnt = 0; cnt < entries.length; cnt++)
      {
        keys.add(entries.entries.toList()[cnt].key);
        contents.add(entries.entries.toList()[cnt].value['value']);
      }
    }
    setState(() {
    });
    if (isLoading == 1)
      await getUserData();
  }

  Future<void> getUserData() async {
    userData = await FirebaseFirestoreService().getUserData();
    isLoading == isLoading + 1;
    profileName = userData['name'];
    setState(() {
    });
    print(userData);
  }


  List<Widget>displayEntry() {
    List<Widget> res = [];
    if (entries == null)
      res.add(Text("You don't have any Note"));
    else {
      for (var each in entries.entries) {
        res.add(Text('${each.key}: ${each.value['value']}'));
      }
    }
    return res;
  }

  void mySetState()
  {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        body: isLoading == 2
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
            : SingleChildScrollView(
        child: Column(
          children: [
            //profile
            ProfileBar(name: profileName),
            SizedBox(height: 10),

            //2 entries showed
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2),spreadRadius: 2,blurRadius: 5,offset: Offset(0, 3),),],
                ),
                child: 
                Container(
                  height: 240, width: 800,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your 2 Last Diary Entries", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blueAccent,),),
                      SizedBox(height: 5),
                      DiaryScreen1(dateTime: dateTime1, feeling: feeling1, title: title1, superState: mySetState,),
                      DiaryScreen1(superState: mySetState),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            // All entries
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: 900,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your all Entries",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container (
                        width: 900,
                        height: 300,
                        child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text("Entry ${index + 1}"),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      "New Entry",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(
                      "Show All Entries",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      );
  }
}

