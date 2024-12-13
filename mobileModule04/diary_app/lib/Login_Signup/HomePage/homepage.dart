import 'package:diary_app/globalData.dart';
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
      'last_login_UTC': getTimeFormat(),
      'last_login': DateTime.now(),
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
    GlobalData.entries = data['entries'];
    data = data['entries'];
    var data2 = data.entries.toList();
    data2.sort((a, b) {
      Timestamp timestampA = a.value['last_update2'];
      Timestamp timestampB = b.value['last_update2'];
      return timestampB.seconds.compareTo(timestampA.seconds);
    });
    GlobalData.entriesSorted = data2;
  }
  Future<void> deleteEntry(String entryName) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': FieldValue.delete(),
    });
    await getEntries();
  }
  Future<void> addEntry(String entryName, String feeling, String entryValue) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': {'feeling': feeling, 'value': entryValue, 'last_update': getTimeFormat(), 'last_update2' : DateTime.now(),},
    });
    await getEntries();
  }
  Future<void> updateEntry(String entryName, String entryValue) async {
    print(2);
    if (GlobalData.entries.entries['$entryName'] == null)
      throw Exception("this can't get updated because it doesn't exist yet");
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$entryName': {'value': entryValue, 'last_update': getTimeFormat()},
    });
    await getEntries();
  }
}
