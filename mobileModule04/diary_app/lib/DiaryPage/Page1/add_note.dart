import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void myDialogBoxAddEntry(BuildContext context, superWidget) async {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final auth = FirebaseAuth.instance;

  Future<void> getEntries() async {
    await FirebaseFirestoreService().getEntries();
  }
  
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
              controller: titleController,
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Enter the title",hintText: "Today, 11.12"),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Enter the content",hintText: "I got many gifts"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                await FirebaseFirestoreService().addEntry(titleController.text, contentController.text);
                await superWidget.getEntries();
                await superWidget.mySetState();
                Navigator.pop(context);
              },
              child: Text( "Create",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
              )
            ),
          ],)
        )
      );
    }
  );
}