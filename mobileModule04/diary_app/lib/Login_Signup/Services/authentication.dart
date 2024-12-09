import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServicews {
  //for storing data in clould firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;


//for signUp
  Future<String> signUpUser(
    {required String email,
      required String password,
      required String name}) async {
    String res = "Some error occured";
    try {
      //to register user in firebase auth with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password);
      // for admin user to our clould firestore
      await _firestore.collection("users").doc(credential.user!.uid).set({
          'name':name,
          'email':email,
          'uid':credential.user!.uid,
        }
      );
      res = "Successfully";
    }
    catch (e) {
      print(e.toString());
    }
    return (res);
  }
}
