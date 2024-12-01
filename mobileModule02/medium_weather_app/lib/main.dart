import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

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
  String                       _toDisplay = "Press button on the right top to check location";
  late LocationPermission      permission;
  Position?                    position;
  Timer?                       _debounce;
  List<String> _citySuggestions = [];

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

    position = await Geolocator.getCurrentPosition();
    _toDisplay = "${position?.latitude} ${position?.longitude}";

    setState(() {
      _searchController.clear();
    });
  }

  void searchInput() {
    setState(() {
      _searchController.clear();
    });
  }

  Future<void> _updateSuggestions(String string) async {
    String url = "https://geocoding-api.open-meteo.com/v1/search?name=$string&count=10&language=en&format=json";
    final response = await http.get(Uri.parse(url));
    var data;

    if (response.statusCode != 200) {
      setState(() {
        _toDisplay = response.body;
      });
      return ;
    }
    data = json.decode(response.body)['results'];
    _citySuggestions = [];
    if (data != null) {
      for (var each in data) {
        _citySuggestions.add(
            (each['name'] ?? "??Name") + ", " 
          + (each['country_code'] ?? "??Country Code") + ", " 
          + (each['admin1'] ?? each['admin2'] ?? "??admin") + ", " 
          + (each['country'] ?? "??Country")
        );
      }
    }
    setState(() {
      _citySuggestions = _citySuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(children: [
          TabBarView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // horizental
                children: [
                  Text("Currently", style: TextStyle(fontSize: 24)),
                  Text("$_toDisplay", style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // horizental
                children: [
                  Text("Today", style: TextStyle(fontSize: 24)),
                  Text("$_toDisplay", style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // horizental
                children: [
                  Text("Weekly", style: TextStyle(fontSize: 24)),
                  Text("$_toDisplay", style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
          Column(
            children: [
            AppBar(
              title:  TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search Information",
                ),
                onSubmitted: (value) => {searchInput()},
                onChanged: (value) {
                  if (_debounce != null && _debounce?.isActive == true)
                    _debounce?.cancel();
                  _debounce = Timer(Duration(milliseconds: 500), () {
                    _updateSuggestions(value);
                  });
                },
              ),
              actions: [IconButton(onPressed: _getCurrentLocation, icon: Icon(Icons.location_on)),],
              backgroundColor: Colors.blueGrey,
            ),
            if (_citySuggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _citySuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_citySuggestions[index]),
                      onTap: () {
                        _searchController.text = _citySuggestions[index];
                      },
                    );
                  },
                ),
              )
          ],)
        ],),
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
