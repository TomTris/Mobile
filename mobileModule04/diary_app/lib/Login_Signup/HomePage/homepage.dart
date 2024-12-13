import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  // FirebaseFirestore FirebaseFirestore.instance = FirebaseFirestore.instance;
  User user = FirebaseAuth.instance.currentUser!;

  Future<String> afterLogin() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
        for (var doc in querySnapshot.docs) {
          if (user.uid == doc['uid']) {
            await updateData({'last_login': getTimeFormat()});
            return "success";
          }
        };
        await addData();
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
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
      'name': user.displayName,
      'email': user.email,
      'uid': user.uid,
      'last_login': getTimeFormat(),
      'entries' : null,
      'felling_of_the_day' : 'happy',
    });
  }

  Future<void> setData(Map<String, dynamic> toSet) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(toSet);
  }
  Future<void> updateData(Map<String, dynamic> toUpdate) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(toUpdate);
  }
  Future<void> deleteData(Map<String, dynamic> toSet) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
  }

  Future<dynamic> getUserData() async {
    var dataInstance = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var data = dataInstance.data()!;
    return (data);
  }
  
  Future<dynamic> getEntries() async {
    var dataInstance = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var data = dataInstance.data()!;
    var entries = data['entries'];
    return (entries);
  }
  Future<void> deleteEntry(String entryName) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': FieldValue.delete(),
    });
  }
  Future<void> addEntry(String entryName, String entryValue) async {
    var entries = await getEntries();
    if (entries != null && entries.entries.any((entry) => entry.key == '$entryName') != null)
      throw Exception('this Title already exists');
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': {'value': entryValue, 'last_update': getTimeFormat()},
    });
  }
  Future<void> updateEntry(String entryName, String entryValue) async {
    var entries = await getEntries();
    if (entries.entries['$entryName'] == null)
      throw Exception("this can't get updated because it doesn't exist yet");
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': {'value': entryValue, 'last_update': getTimeFormat()},
    });
  }
  Future<void> printData() async {
    var data = await getEntries();
    print(data);
    return ;
  }
}
