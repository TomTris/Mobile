import 'package:diary_app/DiaryPage/Page1/diary_screen_top.dart';
import 'package:diary_app/globalData.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowAllEntries extends StatefulWidget {
  final VoidCallback superWidget;
  ShowAllEntries({Key? key, required this.superWidget}) : super(key: key);

  @override
  State<ShowAllEntries> createState() => _ShowAllEntriesState();
}

class _ShowAllEntriesState extends State<ShowAllEntries> {
  void myStateLv2() {
    widget.superWidget();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 900,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2),spreadRadius: 2,blurRadius: 5,offset: Offset(0, 3),),],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your total ${GlobalData.entriesSorted == null ? "0" : GlobalData.entriesSorted.length} Entries",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent,),
            ),
            SizedBox(height: 10),
            Container (
                width: 900,
                height: 300,
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: GlobalData.entriesSorted == null ? 0 : GlobalData.entriesSorted.length,
                itemBuilder: (context, index) {
                  return Container(
                    // margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: 
                    GlobalData.entriesSorted == null
                    ? Text("")
                    :DiaryScreen2(
                      noteId: GlobalData.entriesSorted[index].key,
                      feeling: GlobalData.entriesSorted[index].value['feeling'],
                      title: GlobalData.entriesSorted[index].value['title'],
                      superState: myStateLv2 ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}