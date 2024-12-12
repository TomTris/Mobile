import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future<String> afterLogin() async {
      try {
        QuerySnapshot querySnapshot = await storage.collection('users').get();
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
      'entries' : null,
      'felling_of_the_day' : 'happy',
    });
  }
  Future<void> setData(docId, Map<String, dynamic> toSet) async {
    await storage.collection('users').doc(docId).set(toSet);
  }
  Future<void> updateData(docId, Map<String, dynamic> toUpdate) async {
    await storage.collection('users').doc(docId).update(toUpdate);
  }
  Future<void> deleteData(docId, Map<String, dynamic> toSet) async {
    await storage.collection('users').doc(docId).delete();
  }

  Future<dynamic> getEntries() async {
    String docId = await getDocId();
    var dataInstance = await storage.collection('users').doc(docId).get();
    var data = dataInstance.data()!;
    var entries = data['entries'];
    return (entries);
  }
  Future<void> deleteEntry(String entryName) async {
    String docId = await getDocId();
    await storage.collection('users').doc(docId).update({
      'entries.$entryName': FieldValue.delete(),
    });
  }
  Future<void> addEntry(String entryName, String entryValue) async {
    String docId = await getDocId();
    await storage.collection('users').doc(docId).update({
      'entries.$entryName': {'value': entryValue, 'last_update': getTimeFormat()},
    });
  }
  Future<String> getDocId() async {
    QuerySnapshot querySnapshot = await storage.collection('users').get();
      for (var doc in querySnapshot.docs) {
        if (user.uid == doc['uid'])
          return (doc.id);
      }
      return ("No DocId Avaiable");
  }
  Future<void> printData() async {
    var data = await getEntries();
    print(data);
    return ;
  }
}
