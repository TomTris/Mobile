import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/DiaryPage/Page1/diary_screen_top.dart';
import 'package:diary_app/Login_Signup/HomePage/homepage.dart';
import 'package:diary_app/Login_Signup/Services/authentication.dart';
import 'package:diary_app/Login_Signup/Widget/button.dart';
import 'package:diary_app/globalData.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen2 extends StatefulWidget {
  HomeScreen2({super.key});

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  DateTime focusDay = DateTime.now();
  var notesSameDate = [];
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay){
    setState(() {
      focusDay = selectedDay;
    });
  }

  void myState(){
    setState(() {});
  }
  
  void getNotesSameDate()
  {
    notesSameDate = [];
    if (GlobalData.entriesSorted == null || GlobalData.entriesSorted.length == 0)
      return;
    for (var each in GlobalData.entriesSorted) {
      var eachDayDateTime = each.value['last_update2'].toDate();
      if (eachDayDateTime.day == focusDay.day
        && eachDayDateTime.month == focusDay.month
        && eachDayDateTime.year == focusDay.year){
          notesSameDate.add(each);
        }
    }
  }

  Widget getNotesAtSameDate()
  {
    getNotesSameDate();
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
              "Your total ${notesSameDate.length} entries at ${focusDay.toUtc().toString().substring(0, 10)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent,),
            ),
            SizedBox(height: 10),
            Container (
                width: 900,
                height: 300,
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: notesSameDate.length,
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
                      noteId: notesSameDate[index].key,
                      feeling: notesSameDate[index].value['feeling'],
                      title: notesSameDate[index].value['title'],
                      superState: myState ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    Column(children: [
      Container(
        height: 380,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        child: TableCalendar(
          calendarStyle: CalendarStyle(
            // To bold regular day numbers
            defaultTextStyle: TextStyle(
              fontWeight: FontWeight.bold,  // Make day numbers bold
              fontSize: 16,  // Increase font size if needed
            ),
            // To bold weekend day numbers
            weekendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,  // Bold weekend numbers
              fontSize: 16,
              color: const Color.fromARGB(232, 0, 0, 0),  // Optional: Change weekend text color
            ),
            // To bold selected day
            selectedTextStyle: TextStyle(
              fontWeight: FontWeight.bold,  // Bold selected day number
              fontSize: 16,
              color: Colors.white,  // Change color for better contrast
            ),
          ),
          calendarFormat: CalendarFormat.month,
          focusedDay: focusDay,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2100, 10, 16),
          selectedDayPredicate: (selectedDay) => isSameDay(selectedDay, focusDay),
          onDaySelected: _onDaySelected, // return day and fucused day
          ),
      ),
      Container(
        child:  getNotesAtSameDate(),
      )

    ],);
  }
}
