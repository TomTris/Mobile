import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future<String> afterLogin() async {
    QuerySnapshot querySnapshot = await storage.collection('users').get();
      try {
        for (var doc in querySnapshot.docs) {
          if (user.uid == doc['uid']) {
            await FirebaseFirestoreService().updateData(doc.id, {'last_login': getTimeFormat()});
            return "success";
          }
        };
        await FirebaseFirestoreService().addData();
        return "success";
      }
      catch (e) {
        return (e.toString());
      }
  }

  String getTimeFormat(){
    DateTime now = DateTime.now();
    DateTime nowUtc = DateTime.now().toUtc();
    int timeZoneOffset = now.timeZoneOffset.inHours;
    String nowTime = "${DateFormat('dd/MM/yyyy HH:mm:ss').format(nowUtc)} UTC${timeZoneOffset >= 0 ? '+' : ''}$timeZoneOffset";

    return nowTime;
  }
  Future<void> addData() async {
    await storage.collection('users').add({
      'name': user.displayName,
      'email': user.email,
      'uid': user.uid,
      'last_login': getTimeFormat(),
    });
  }

  Future<void> setData(docId, Map<String, dynamic> toSet) async {
    storage.collection('users').doc(docId).set(toSet);
  }

  Future<void> updateData(docId, Map<String, dynamic> toUpdate) async {
    storage.collection('users').doc(docId).update(toUpdate);
  }

  Future<void> deleteData(docId, Map<String, dynamic> toSet) async {
    storage.collection('users').doc(docId).delete();
  }
}
