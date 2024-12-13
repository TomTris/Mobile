import 'package:diary_app/globalData.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreService {
  User user = FirebaseAuth.instance.currentUser!;

  Future<String> afterLogin() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
        for (var doc in querySnapshot.docs) {
          if (user.uid == doc['uid']) {
            await updateData({'last_login': getTimeFormat(DateTime.now())});
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

  String getTimeFormat(DateTime now){
    DateTime nowUtc = now.toUtc();
    int timeZoneOffset = now.timeZoneOffset.inHours;
    String nowTime = "${DateFormat('dd/MM/yyyy HH:mm:ss').format(nowUtc)} UTC${timeZoneOffset >= 0 ? '+' : ''}$timeZoneOffset";

    return nowTime;
  }
  
  Future<void> addData() async {
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
      'name': user.displayName == null ? "No name" : user.displayName,
      'email': user.email,
      'uid': user.uid,
      'last_login_UTC': getTimeFormat(now),
      'last_login': now,
      'entries' : null,
    });
    // Reason: it seems like, it takes a bit time, until firebase get request and make changes into the database
    // without this line, when user logs in, sometimes data isn't initialized yet and it shows error.
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> setData(Map<String, dynamic> toSet) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(toSet);
  }
  Future<void> updateData(Map<String, dynamic> toUpdate) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update(toUpdate);
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'name': user.displayName == null ? "No name" : user.displayName});
  }
  Future<void> deleteData(Map<String, dynamic> toSet) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
  }

  Future<dynamic> getUserData() async {
    var dataInstance = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var data = dataInstance.data()!;
    return (data);
  }
  
  Future<void> getEntries() async {
    var dataInstance = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var data = dataInstance.data()!;
    GlobalData.entries = data['entries'];
    var dataTemp = data['entries'];
    if (dataTemp == null)
      return ;
    var data2 = dataTemp.entries.toList();
    data2.sort((a, b) {
      Timestamp timestampA = a.value['last_update2'];
      Timestamp timestampB = b.value['last_update2'];
      return timestampB.seconds.compareTo(timestampA.seconds);
    });
    GlobalData.entriesSorted = data2;
  }
  Future<void> deleteEntry(String noteId) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.$noteId': FieldValue.delete(),
    });
    await getEntries();
  }
  Future<void> addEntry(String title, String feeling, String content) async {
    DateTime now = DateTime.now();
    String nowString = now.year.toString() + now.day.toString() + now.month.toString() + now.hour.toString() + now.minute.toString() + now.second.toString() + now.millisecond.toString() + now.microsecond.toString();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.${nowString}': {'title': title, 'feeling': feeling, 'content': content, 'last_update': getTimeFormat(now), 'last_update2' : now,},
    });
    await getEntries();
  }
  Future<void> updateEntry(String noteId, String title, String feeling, String content) async {
    int index = -1;
    int found = 0;
    for (var each in GlobalData.entriesSorted) {
      index += 1;
      if (each.key == noteId) {
        found = 1;
        break ;
      }
    }
    if (found == 0)
      throw Exception("this can't get updated because it doesn't exist yet");
    DateTime now = DateTime.now();
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'entries.${noteId}': {'title': title, 'feeling': feeling, 'content': content, 'last_update': getTimeFormat(now), 'last_update2' : now,},
    });
    await getEntries();
  }
}

