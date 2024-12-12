import 'package:diary_app/DiaryPage/Page1/add_note.dart';
import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getEntries();
  }

  Future<void> getEntries() async {
    entries = await FirebaseFirestoreService().getEntries();
    setState(() {
      isLoading = false;
    });
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
        body: isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading spinner while fetching data
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("You have logged in successfully", textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  ElevatedButton(
                    onPressed: () async {myDialogBoxAddEntry(context, this);},
                    child: Icon(Icons.add),
                  ),
                  Column(children: displayEntry(),),
                  MyButton(
                    onTab: () async {
                      String res = await AuthServices().signOut();
                      AuthServices().signOut2(res, context);
                    },
                    text: 'Sign Out',
                  ),
                ],
              ),
      );
  }
}
