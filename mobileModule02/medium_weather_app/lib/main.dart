import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:medium_weather_app/functions.dart';
import 'package:medium_weather_app/pages.dart';
import 'package:medium_weather_app/myAppBar.dart';

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
  TextEditingController        searchController = TextEditingController();
  String                       toDisplay = "Press button on the right top to check location";
  late LocationPermission      permission;
  Position?                    position;
  Timer?                       debounce;
  Map<int, List<String>>      cityLanLon = {};
  List<String>                citySuggestions = [];
  List<String>                toDisplayCurrent = [];
  List<String>                toDisplayToday = [];
  List<String>                toDisplayWeek = [];

  void _emptyDisplay(String str)
  {
    toDisplay = str;
    toDisplayCurrent = [];
    toDisplayToday = [];
    toDisplayWeek = [];
    citySuggestions = [];
    setState(() {
    });
  }

  // return 0 fails, 1 - success, position_variable is updated and display the address of user.
  Future<int> getCurrentLocation() async
  {
    if (false == await Geolocator.isLocationServiceEnabled()) {
      _emptyDisplay("location services aren't enabled on the device.");
      return (0);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      _emptyDisplay("Permission to access the device's location is permanently denied.");
      return (0);
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _emptyDisplay("Permission to access the device's location is denied.");
        return (0);
      }
    }
    position = await Geolocator.getCurrentPosition();
    _emptyDisplay("${position?.latitude}, ${position?.longitude}");
    return (1);
  }

  Future<void> updateSuggestions(String cityName) async
  {
    String url     = "https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=10&language=en&format=json";
    final response = await http.get(Uri.parse(url));
    int count      = 0;
    var data;

    if (searchController.text != cityName) {
      return ;
    }
    if (response.statusCode != 200) {
      _emptyDisplay("API request has Problem: ${response.body}");
      return ;
    }
    data = json.decode(response.body)['results'];
    citySuggestions = [];
    if (cityLanLon.isNotEmpty == true)
      cityLanLon.clear();
    if (data != null) {
      for (var each in data) {
        citySuggestions.add(
            (each['name'] ?? "??Name") + ", " 
          + (each['country_code'] ?? "??Country Code") + ", " 
          + (each['admin1'] ?? each['admin2'] ?? "??admin") + ", " 
          + (each['country'] ?? "??Country")
        );
        cityLanLon[count++] = ["${each['latitude']}", "${each['longitude']}"];
      }
    }
    setState(() {
    });
  }

  Future<String?> displayPageCurrent(int index) async
  {
    String url1 = "https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&current=temperature_2m,weather_code,wind_speed_10m";
    late String? today;
    var response;
    var data;

    response = await http.get(Uri.parse(url1));
    if (response.statusCode != 200) {
      _emptyDisplay("API request has Problem: ${response.body}");
      return (null);
    }
    data = json.decode(response.body)['current'];
    if (data != null)
    {
      today = data['time'].substring(0, 10);
      toDisplayCurrent = [
        '${citySuggestions[index]}',
        "Temperatur: ${data['temperature_2m']} °C",
        "Weather: ${getWeatherDescription(data['weather_code'])}",
        "Wind Speed: ${data['wind_speed_10m']} km/h"];
      return (today);
    }
    return (null);
  }

  Future<void> displayTodayAndWeek(int index, String today) async
  {
    String url2 = "https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&hourly=temperature_2m,weather_code,wind_speed_10m";
    var response;
    var data;

    response = await http.get(Uri.parse(url2));
    if (response.statusCode != 200) {
      _emptyDisplay("API request has Problem: ${response.body}");
      return ;
    }
    data = json.decode(response.body)['hourly'];
    if (data == null || data['time'] == null || data['temperature_2m'] == null ||
      data['wind_speed_10m'] == null || data['weather_code'] == null)
    {
      _emptyDisplay("Something wrong with API Answer/Parsing: ${response.body}");
      return ;
    }
    toDisplayToday = ['${citySuggestions[index]}', today, ""];
    for (int cnt = 0; cnt <= 23; cnt++)
    {
      toDisplayToday[2] += 
        "${data['time'][cnt].substring(11)}   " 
        "${data['temperature_2m'][cnt]} °C    "
        "${getWeatherDescription(data['weather_code'][cnt])}   "
        "${data['wind_speed_10m'][cnt]} km/h\n";
    }

    toDisplayWeek = ['${citySuggestions[index]}', today, ""];
    for (int cntDay = 0; cntDay < 7; cntDay++)
    {
      double temperature_temporary = double.parse("${data['temperature_2m'][cntDay * 23]}");
      double temMax = temperature_temporary;
      double temMin = temperature_temporary;
      double winAvarage = data['wind_speed_10m'][cntDay * 23];
      for (int cnt = 1; cnt <= 23; cnt++)
      {
        temperature_temporary = double.parse("${data['temperature_2m'][cntDay * 23 + 1]}");
        if (temMax < temperature_temporary)
          temMax = temperature_temporary;
        else if (temMin > temperature_temporary)
          temMin = temperature_temporary;
        winAvarage += data['wind_speed_10m'][cntDay * 23 + cnt];
      }
      toDisplayWeek[2] +=
        "${data['time'][cntDay * 23].substring(0, 10)}   "
        "$temMin °C    "
        "$temMax °C    "
        "${getWeatherDescription(data['weather_code'][cntDay * 23 + 12])}   "
        "${(winAvarage / 24).toStringAsFixed(2)} km/h\n";
    }
  }

  void searchTheInput(int index) async
  {
    if (index == -1 && citySuggestions.isEmpty)
    {
      setState(() {
        searchController.clear();
        updateSuggestions("");
        _emptyDisplay("No suitable suggestions!");
      });
      return;
    }
    else if (index == -1)
      index = 0;

    late String? today;
    today = await displayPageCurrent(index);
    if (today == null)
      return ;
    await displayTodayAndWeek(index, today);
    setState(() {
      searchController.clear();
      updateSuggestions("");
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
              CurrentPage(toDisplay: toDisplay, toDisplayCurrent: toDisplayCurrent),
              TodayPage(toDisplay: toDisplay, toDisplayToday: toDisplayToday),
              WeekPage(toDisplay: toDisplay, toDisplayWeek: toDisplayWeek),
            ],
          ),
          MyAppBar(
            searchController: searchController,
            searchTheInput: searchTheInput,
            updateSuggestions: updateSuggestions,
            getCurrentLocation: getCurrentLocation,
            citySuggestions: citySuggestions,
            debounce: debounce,
          ),
        ],),
        bottomNavigationBar: const TabBar(
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
