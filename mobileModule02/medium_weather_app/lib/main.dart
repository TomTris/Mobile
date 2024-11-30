import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController        _searchController = TextEditingController();
  FloatingActionButtonLocation _floatingButton = FloatingActionButtonLocation.centerFloat;
  String                       _textCurrentlyView = "Currently";
  String                       _textTodayView = "Today";
  String                       _textWeeklyView = "Weekly";

  String                      _toDisplay = "Press button on the right top to check location";
  late LocationPermission       permission;
  Position?                      position;

  Future<void> _getCurrentLocation() async
  {
    if (false == await Geolocator.isLocationServiceEnabled()) {
      setState(() {
      _toDisplay = "location services aren't enabled on the device.";
      return ;
      });
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      setState(() {
      _toDisplay = "Permission to access the device's location is permanently denied.";
      return ;
      });
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _toDisplay = "Permission to access the device's location is denied.";
          return ;
        });
      }
    }

    // ${position.latitude} ${position.longitude}
    position = await Geolocator.getCurrentPosition();
    _toDisplay = "${position?.latitude} ${position?.longitude}";

    setState(() {
      _textCurrentlyView = "Currently" ;
      _textTodayView = "Today";
      _textWeeklyView = "Weekly";
      _searchController.clear();
    });
  }


  void searchInput() {
    setState(() {
      _textCurrentlyView = "Currently\n" + _searchController.value.text;
      _textTodayView = "Today\n" + _searchController.value.text;
      _textWeeklyView = "Weekly\n" + _searchController.value.text;
      _searchController.clear();
    });
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
          actions: [IconButton(onPressed: _getCurrentLocation, icon: Icon(Icons.location_on)),],
        ),
        body: TabBarView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // horizental
              children: [
                Text("$_textCurrentlyView", style: TextStyle(fontSize: 24)),
                Text("$_toDisplay", style: TextStyle(fontSize: 24)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // horizental
              children: [
                Text("$_textTodayView", style: TextStyle(fontSize: 24)),
                Text("$_toDisplay", style: TextStyle(fontSize: 24)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment: CrossAxisAlignment.center, // horizental
              children: [
                Text("$_textWeeklyView", style: TextStyle(fontSize: 24)),
                Text("$_toDisplay", style: TextStyle(fontSize: 24)),
              ],
            ),
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
