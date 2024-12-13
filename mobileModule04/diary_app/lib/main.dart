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


// ------------------SHOW PROFILE------------------------------------------------------------------------------------------------------------------------------------

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DiaryScreen(),
//     );
//   }
// }

// ------------------Entry------------------------------------------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Dynamic Dialog Example'),
//         ),
//         body: Center(
//           child: MyContainer(),
//         ),
//       ),
//     );
//   }
// }

// class MyContainer extends StatefulWidget {
//   @override
//   _MyContainerState createState() => _MyContainerState();
// }

// class _MyContainerState extends State<MyContainer> {
//   String _dialogTitle = "Dialog Title";
//   String _dialogContent = "This is the dialog content.";
//   IconData _dialogIcon = Icons.info;

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _titleController.text = _dialogTitle;
//         _contentController.text = _dialogContent;
        
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//               builder: (context, setState) {
//                 return AlertDialog(
//                   title: Container(
//                     width: 700,
//                     height: 60,
//                     padding: const EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 227, 231, 233), // Light background color
//                       borderRadius: BorderRadius.circular(8), // Rounded corners
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 1,
//                           blurRadius: 3,
//                           offset: Offset(0, 1), // Shadow position
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _titleController,
//                       decoration: InputDecoration(
//                         labelText: 'Title',
//                         labelStyle: TextStyle(
//                           color: Colors.grey, // Light gray label color
//                         ),
//                         border: InputBorder.none, // No border around the text field
//                       ),
//                       style: TextStyle(
//                         fontSize: 20, // Larger font size for the title
//                         color: Colors.black, // Text color
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           _dialogTitle = value;
//                         });
//                       },
//                     ),
//                   ),
//                   content: Container(
//                     width: 700,
//                     height: 600,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Container(
//                           width: 700,
//                           height: 50,
//                           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding around the DropdownButton
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 227, 231, 233), // Light background color
//                             borderRadius: BorderRadius.circular(8), // Rounded corners
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 spreadRadius: 1,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2), // Shadow position
//                               ),
//                             ],
//                           ),
//                           child: DropdownButton<IconData>(
//                             value: _dialogIcon,
//                             isExpanded: true, // Ensures the dropdown takes up the full width
//                             items: [
//                               DropdownMenuItem(
//                                 value: Icons.info,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.info, color: Colors.blue),
//                                     SizedBox(width: 8),
//                                     Text("Info"),
//                                   ],
//                                 ),
//                               ),
//                               DropdownMenuItem(
//                                 value: Icons.warning,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.warning, color: Colors.orange),
//                                     SizedBox(width: 8),
//                                     Text("Warning"),
//                                   ],
//                                 ),
//                               ),
//                               DropdownMenuItem(
//                                 value: Icons.check_circle,
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.check_circle, color: Colors.green),
//                                     SizedBox(width: 8),
//                                     Text("Success"),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                             onChanged: (IconData? value) {
//                               setState(() {
//                                 if (value != null) {
//                                   _dialogIcon = value;
//                                 }
//                               });
//                             },
//                             iconEnabledColor: Colors.black, // Set the color of the dropdown arrow
//                             iconSize: 30, // Set the size of the dropdown arrow
//                             underline: Container(), // Remove the default underline
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         Container(
//                           padding: const EdgeInsets.all(16), // Add padding around the text field
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 227, 231, 233), // Light background color
//                             borderRadius: BorderRadius.circular(12), // Rounded corners
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.3),
//                                 spreadRadius: 2,
//                                 blurRadius: 4,
//                                 offset: Offset(0, 2), // Shadow position
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _contentController,
//                             decoration: InputDecoration(
//                               labelText: 'Content',
//                               labelStyle: TextStyle(
//                                 color: Colors.grey, // Light gray label color
//                               ),
//                               border: InputBorder.none, // No border
//                             ),
//                             maxLines: 20, // Allows multiple lines
//                             style: TextStyle(
//                               fontSize: 16, // Font size for the text
//                               color: Colors.black, // Text color
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 _dialogContent = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: Text('Delete'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         // Add your delete logic here
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Cancel'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         // Add your delete logic here
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Save'),
//                       onPressed: () {
//                         setState(() {
//                           _dialogTitle = _titleController.text;
//                           _dialogContent = _contentController.text;
//                         });
//                         Navigator.of(context).pop();
//                         // Add your save logic here
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         );
//       },
//       child: Container(
//         padding: EdgeInsets.all(16.0),
//         color: Colors.blue,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(_dialogIcon, color: Colors.white, size: 48),
//             SizedBox(height: 10),
//             Text(
//               _dialogTitle,
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             ),
//             SizedBox(height: 5),
//             Text(
//               _dialogContent,
//               style: TextStyle(color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }