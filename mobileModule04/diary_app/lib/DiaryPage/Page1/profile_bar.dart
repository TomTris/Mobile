import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:flutter/material.dart';

//can change the image but need to learn about firebase_storage -> not developed!
// ignore: must_be_immutable
class ProfileBar extends StatelessWidget {
  ProfileBar({
    Key? key,
    required this.name,
  }) :  super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('default_background.jpg'), // Replace with your asset path
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('default_profile.jpg'), // Replace with your asset path
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                String res = await AuthServices().signOut();
                await AuthServices().signOut2(res, context);
              },
              iconSize: 25,
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
