import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'functions.dart';
import 'pages.dart';
import 'myAppBar.dart';

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
  DateTime?                     lastClick;
  DateTime?                     lastShowBar;
  Duration                      waitingTime = Duration(seconds: 4);
  
  void addAllDisplay(String str)
  {
    toDisplay = "${toDisplay}\n${str}";
    if (toDisplayCurrent.isEmpty)
      toDisplayCurrent = ['${str}'];
    else
      toDisplayCurrent.insert(1, str);
    if (toDisplayToday.isEmpty)
      toDisplayToday = ['${str}'];
    else
      toDisplayToday.insert(1, str);
    if (toDisplayWeek.isEmpty)
      toDisplayWeek = ['${str}'];
    else
      toDisplayWeek.insert(1, str);
    citySuggestions = [];
  }

  void _emptyDisplay(String str)
  {
    toDisplay = str;
    toDisplayCurrent = [];
    toDisplayToday = [];
    toDisplayWeek = [];
    citySuggestions = [];
  }

  Future<String?> getCityName(double latitude, double longitude) async
  {
    String url = "https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json";
    var response;
    var data;

    try{
      response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _emptyDisplay("Your location: ${position?.latitude}, ${position?.longitude}\nAPI request to find your city has Problem.");
        return (null);
      }
    }
    catch (e) {
      _emptyDisplay("Your location: ${position?.latitude}, ${position?.longitude}\nAn Error occurs, couble with API / Network");
      return null;
    }
    data = json.decode(response.body)['address'];
    if (data != null)
      data = data['city'] ?? data['town'] ?? data['village'] ?? data['district'] ?? data['region'] ?? data['province'] ?? data['locality'] ?? null;
    if (data == null)
      _emptyDisplay("Your location: ${position?.latitude}, ${position?.longitude}\nCan't find your city");
    return (data);
  }

  // return 0 fails, 1 - success, position_variable is updated and display the address of user.
  Future<int> getCurrentLocation() async
  {
    bool value = await Geolocator.isLocationServiceEnabled();
    if (value == false) {
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
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied)
      {
        _emptyDisplay("Permission to access the device's location is denied.\n");
        print("Permission to access the device's location is denied.");
        return (0);
      }
    }
    position = await Geolocator.getCurrentPosition();
    String? cityName = await getCityName(position!.latitude, position!.longitude);
    if (cityName == null)
      return (0);
    String toDisplayBackup = "${position!.latitude.toStringAsFixed(3)}, ${position!.longitude.toStringAsFixed(3)}";
    toDisplay = "";
    int hasSuggestions = await updateSuggestions(cityName);
    if (hasSuggestions == 0)
    {
      addAllDisplay(toDisplay);
      addAllDisplay(toDisplayBackup);
      return (0);
    }
    int isOk = await searchTheInput(0);
    if (isOk == 0)
      addAllDisplay(toDisplay);
    addAllDisplay(toDisplayBackup);
    return (isOk);
  }

  Future<int> updateSuggestions(String cityName) async
  {
    String url     = "https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=10&language=en&format=json";
    var response;
    int count      = 0;
    var data;

    try {
      response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _emptyDisplay("API request has Problem");
        return (0);
      }
    }
    catch (e) {
      _emptyDisplay("Request(API/Network) has Problem.");
        return (0);
    }
    data = json.decode(response.body)['results'];
    citySuggestions = [];
    if (cityLanLon.isNotEmpty == true)
      cityLanLon.clear();
    if (data != null) {
      for (var each in data) {
        String toAdd = "";
        if (each['name'] != null) toAdd += "${each['name']}"; else toAdd += "Unkown name";
        if (each['country_code'] != null) toAdd += ", ${each['country_code']}";
        if (each['admin1'] != null) toAdd += ", ${each['admin1']}";
        if (each['country'] != null) toAdd += ", ${each['country']}";
        citySuggestions.add(toAdd);
        cityLanLon[count++] = ["${each['latitude']}", "${each['longitude']}"];
      }
    }
    return (1);
  }

  Future<String?> displayPageCurrent(int index) async
  {
    String url1 = "https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&current=temperature_2m,weather_code,wind_speed_10m";
    late String? today;
    var response;
    var data;

    try {
      response = await http.get(Uri.parse(url1));
      if (response.statusCode != 200) {
        _emptyDisplay("API request has Problem");
        return (null);
      }
    }
    catch (e) {
      _emptyDisplay("Request (API/Network) has Problem.");
      return (null);
    }
    data = json.decode(response.body)['current'];
    if (data != null && data['time'] != null && data['temperature_2m'] != null && data['wind_speed_10m'] != null)
    {
      today = data['time'].substring(0, 10);
      toDisplayCurrent = [
        citySuggestions[index],
        "Temperatur: ${data['temperature_2m']} °C",
        "Weather: ${getWeatherDescription(data['weather_code'])}",
        "Wind Speed: ${data['wind_speed_10m']} km/h"];
      return (today);
    }
    _emptyDisplay("API request has Problem / Something wrong with API Answer/Parsing");
    return (null);
  }

  Future<int> displayTodayAndWeek(int index, String today) async
  {
    String url2 = "https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&hourly=temperature_2m,weather_code,wind_speed_10m";
    var response;
    var data;

    try {
      response = await http.get(Uri.parse(url2));
      if (response.statusCode != 200) {
        _emptyDisplay("API request has Problem");
        return (0);
      }
    }
    catch (e) {
      _emptyDisplay("Request (API/Network) has Problem");
        return (0);
    }
    data = json.decode(response.body)['hourly'];
    if (data == null || data['time'] == null || data['temperature_2m'] == null ||
      data['wind_speed_10m'] == null || data['weather_code'] == null)
    {
      _emptyDisplay("API request has Problem / Something wrong with API Answer/Parsing");
      return (0);
    }
    toDisplayToday = [citySuggestions[index], today, ""];
    for (int cnt = 0; cnt <= 23; cnt++)
    {
      toDisplayToday[2] += 
        "${data['time'][cnt].substring(11)}   " 
        "${data['temperature_2m'][cnt]} °C    "
        "${getWeatherDescription(data['weather_code'][cnt])}   "
        "${data['wind_speed_10m'][cnt]} km/h\n";
    }

    toDisplayWeek = [citySuggestions[index], today, ""];
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
    return (1);
  }

  //Click button get location => index = -1
  //=> if empty => said can't find your City's name.
  //Search enter -> index = 0
  //Select -> Select
  //=> index >= length -> no suitable suggestions.
  Future<int> searchTheInput(int index) async
  {
    toDisplayCurrent = [];
    toDisplayToday = [];
    toDisplayWeek = [];
    if (index == -1)
    {
      if (citySuggestions.isEmpty)
      {
        _emptyDisplay("Can't find your city's name!");
        return (0);
      }
      index = 0;
    }
    if (index >= citySuggestions.length)
    {
      searchController.clear();
      cityLanLon = {};
      citySuggestions = [];
      _emptyDisplay("No suitable suggestions!");
      return (0);
    }
    late String? today;
    today = await displayPageCurrent(index);
    if (today == null)
      return (0);
    int isSuccess = await displayTodayAndWeek(index, today);
    searchController.clear();
    citySuggestions = [];
    cityLanLon = {};
    return (isSuccess);
  }

  void updateLastClick(DateTime time) {
      lastClick = time;
  }
  void updateLastShowBar(DateTime time) {
      lastShowBar = time;
  }

  void myState() {
    setState(() {});
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
            myState: myState,
            lastClick: lastClick,
            lastShowBar: lastShowBar,
            waitingTime: waitingTime,
            updateLastClick: updateLastClick,
            updateLastShowBar: updateLastShowBar,

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
