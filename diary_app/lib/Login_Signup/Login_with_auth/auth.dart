import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final storage = FirebaseFirestore.instance;
  final googleSignIn = GoogleSignIn(
    clientId: '811446816301-vjpk05hp52ufn6dtr6a8ph8gud8i8sdh.apps.googleusercontent.com',
  );
  late String res = "success";

  String getTimeFormat(){
    DateTime now = DateTime.now();
    DateTime nowUtc = DateTime.now().toUtc();
    int timeZoneOffset = now.timeZoneOffset.inHours;
    String nowTime = "${DateFormat('dd/MM/yyyy HH:mm:ss').format(nowUtc)} UTC${timeZoneOffset >= 0 ? '+' : ''}$timeZoneOffset";

    return nowTime;
  }

  Future<String> signInWithGoogle() async {
    res = "Login process not ok";
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCredential);
        res = await FirebaseFirestoreService().afterLogin();
        if (res != "success")
          await AuthServices().signOut();
      }
    }
    on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    catch (e) {
      res = "You didn't `signup correctly!${e}";
    }
    return res;
  }

  Future<String> signInWithGitHub() async {
    String res = "success";
    try {
      GithubAuthProvider provider = GithubAuthProvider();
      provider.addScope('repo');
      provider.setCustomParameters({'allow_signup' : 'false'});
      await auth.signInWithPopup(provider);
      res = await FirebaseFirestoreService().afterLogin();
        if (res != "success")
          await AuthServices().signOut();
    }
    on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    catch (e) {
      res = "You didn't signup correctly!";
    }
    return res;
  }
}
