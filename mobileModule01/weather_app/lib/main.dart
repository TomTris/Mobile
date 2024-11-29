import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomTabBarExample(),
    );
  }
}

class BottomTabBarExample extends StatefulWidget {
  const BottomTabBarExample({super.key});

  @override
  State<BottomTabBarExample> createState() => _BottomTabBarExampleState();
}

class _BottomTabBarExampleState extends State<BottomTabBarExample> {
  TextEditingController _searchController = TextEditingController();
  FloatingActionButtonLocation _floatingButton = FloatingActionButtonLocation.endTop;
  String _textCurrentlyView = "Currently";
  String _textTodayView = "Today";
  String _textWeeklyView = "Weekly";

  void searchInput() {
    setState(() {
      _textCurrentlyView = "Currently\n" + _searchController.value.text;
      _textTodayView = "Today\n" + _searchController.value.text;
      _textWeeklyView = "Weekly\n" + _searchController.value.text;
      _searchController.clear();
    });
  }

  FloatingActionButtonLocation floatingActionChange(){
    setState(() {
      _textCurrentlyView = "Currently\n" + "Geolocation";
      _textTodayView = "Today\n" + "Geolocation";
      _textWeeklyView = "Weekly\n" + "Geolocation";
    });
    return _floatingButton;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search Information",
              icon: Icon(Icons.search),
            ),
            onSubmitted: (value) => {searchInput()},
          ),
          backgroundColor: Colors.blueGrey,
          actions: [IconButton(onPressed: floatingActionChange, icon: Icon(Icons.location_on)),],
        ),
        body: TabBarView(
          children: [
            Center(child: Text("$_textCurrentlyView", style: TextStyle(fontSize: 24))),
            Center(child: Text("$_textTodayView", style: TextStyle(fontSize: 24)),),
            Center(child: Text("$_textWeeklyView", style: TextStyle(fontSize: 24))),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.access_time), text: 'Currently'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Today'),
            Tab(icon: Icon(Icons.calendar_view_week), text: 'Weekly'),
          ]
        ),
      ),
    );
  }
}
