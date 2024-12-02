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
  Map<int, List<String>>      _cityLanLon = {};
  List<String>                _citySuggestions = [];
  List<String>                _toDisplayCurrent = [];
  List<String>                _toDisplayToday = [];
  List<String>                _toDisplayWeek = [];

  Map<int, String> weatherDescription = {
    0: "Clear sky",
    1: "Mainly clear",
    2: "Partly cloudy",
    3: "Overcast",
    45: "Fog",
    48: "Depositing rime fog",
    51: "Light drizzle",
    53: "Moderate drizzle",
    55: "Dense drizzle",
    56: "Light freezing drizzle",
    57: "Dense freezing drizzle",
    61: "Light rain",
    63: "Moderate rain",
    65: "Heavy rain",
    66: "Light freezing rain",
    67: "Heavy freezing rain",
    71: "Slight snow fall",
    73: "Moderate snow fall",
    75: "Heavy snow fall",
    77: "Snow grains",
    80: "Slight rain showers",
    81: "Moderate rain showers",
    82: "Violent rain showers",
    85: "Slight snow showers",
    86: "Heavy snow showers",
    95: "Slight thunderstorm",
    96: "Thunderstorm with slight hail",
    99: "Thunderstorm with heavy hail",
  };

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
    print(_toDisplay);

    setState(() {
      _searchController.clear();
    });
  }

  Future<void> _updateSuggestions(String string) async
  {
    String url = "https://geocoding-api.open-meteo.com/v1/search?name=$string&count=10&language=en&format=json";
    final response = await http.get(Uri.parse(url));
    int count = 0;
    var data;

    if (response.statusCode != 200) {
      setState(() {
        _toDisplay = response.body;
      });
      return ;
    }
    data = json.decode(response.body)['results'];
    _citySuggestions = [];
    if (_cityLanLon?.isNotEmpty == true)
      _cityLanLon.clear();
    if (data != null) {
      for (var each in data) {
        _citySuggestions.add(
            (each['name'] ?? "??Name") + ", " 
          + (each['country_code'] ?? "??Country Code") + ", " 
          + (each['admin1'] ?? each['admin2'] ?? "??admin") + ", " 
          + (each['country'] ?? "??Country")
        );
        _cityLanLon[count++] = ["${each['latitude']}", "${each['longitude']}"];
      }
    }
    setState(() {
      _citySuggestions = _citySuggestions;
    });
  }

  void searchInput(int index) async
  {
    print("bbbb");
    if (index == -1 && _citySuggestions.isEmpty)
    {
      setState(() {
        _searchController.clear();
        _updateSuggestions("");
      });
      return;
    }
    else if (index == -1)
      index = 0;
    print("aaaaa");
    String url1 = "https://api.open-meteo.com/v1/forecast?latitude=${_cityLanLon[index]?[0]}&longitude=${_cityLanLon[index]?[1]}&current=temperature_2m,weather_code,wind_speed_10m";
    String url2 = "https://api.open-meteo.com/v1/forecast?latitude=${_cityLanLon[index]?[0]}&longitude=${_cityLanLon[index]?[1]}&hourly=temperature_2m,weather_code,wind_speed_10m";
    late String today;
    var response;
    var data;

    response = await http.get(Uri.parse(url1));
    if (response.statusCode != 200) {
      setState(() {
        print(response.body);
        _toDisplay = response.body;
      });
      return ;
    }
    data = json.decode(response.body)['current'];
    today = data['time'].substring(0, 10);
    _toDisplayCurrent = [
      '${_citySuggestions[index]}',
      "Temperatur: ${data['temperature_2m']} °C",
      "Weather: ${weatherDescription[data['weather_code']]}",
      "Wind Speed: ${data['wind_speed_10m']} km/h"];


    response = await http.get(Uri.parse(url2));
    if (response.statusCode != 200) {
      setState(() {
        _toDisplay = response.body;
      });
      return ;
    }
    data = json.decode(response.body)['hourly'];
    _toDisplayToday = ['${_citySuggestions[index]}', today, ""];
    for (int cnt = 0; cnt <= 23; cnt++)
    {
      _toDisplayToday[2] += 
        "${data['time'][cnt].substring(11)}   " + 
        "${data['temperature_2m'][cnt]} °C    " +
        "${weatherDescription[data['weather_code'][cnt]]}   " +
        "${data['wind_speed_10m'][cnt]} km/h\n";
    }

    _toDisplayWeek = ['${_citySuggestions[index]}', today, ""];
    for (int cnt_day = 0; cnt_day < 7; cnt_day++)
    {
      double temperature_temporary = double.parse("${data['temperature_2m'][cnt_day * 7]}");
      double temMax = temperature_temporary;
      double temMin = temperature_temporary;
      double winAvarage = data['wind_speed_10m'][cnt_day * 7];
      for (int cnt = 1; cnt <= 23; cnt++)
      {
        temperature_temporary = double.parse("${data['temperature_2m'][cnt_day * 7 + 1]}");
        if (temMax < temperature_temporary)
          temMax = temperature_temporary;
        else if (temMin > temperature_temporary)
          temMin = temperature_temporary;
        winAvarage += data['wind_speed_10m'][cnt_day * 7 + cnt];
      }
      _toDisplayWeek.add(
        "${data['time'][cnt_day * 7].substring(0, 10)}   " + 
        "$temMin °C    " +
        "$temMax °C    " +
        "${weatherDescription[data['weather_code'][cnt_day * 7 + 12]]}   " +
        "${(winAvarage / 24).toStringAsFixed(2)} km/h\n"
      );
    }


    
    
//         In your first tab “Current”, you need to display:
// • The location (city name, countrycode/admin1/admin2, and country).
// • The current temperature (in Celsius).
// • The current weather description (e.g., cloudy, sunny, rainy).
// • The current wind speed (in km/h).
      //To day
      // ◦ The time of day.
      // ◦ The temperature at each hour.
      // ◦ The weather description (cloudy, sunny, rainy, etc.) at each hour.
      // ◦ The wind speed (in km/h) at each hour.
    setState(() {
      _searchController.clear();
      _updateSuggestions("");
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
                  if (_toDisplayCurrent.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.center, // horizental
                      children: [
                        Text("Currently", style: TextStyle(fontSize: 24)),
                        Text("Press button on the right top to check location", style: TextStyle(fontSize: 24)),
                      ]
                    ),
                  for (var each in _toDisplayCurrent)
                    Text("$each", style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // horizental
                children: [
                  if (_toDisplayToday.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.center, // horizental
                      children: [
                        Text("Today", style: TextStyle(fontSize: 24)),
                        Text("Press button on the right top to check location", style: TextStyle(fontSize: 24)),
                      ]
                    ),
                  for (var each in _toDisplayToday)
                    Text("$each", style: TextStyle(fontSize: 24)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                crossAxisAlignment: CrossAxisAlignment.center, // horizental
                children: [
                  if (_toDisplayWeek.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                      crossAxisAlignment: CrossAxisAlignment.center, // horizental
                      children: [
                        Text("Today", style: TextStyle(fontSize: 24)),
                        Text("Press button on the right top to check location", style: TextStyle(fontSize: 24)),
                      ]
                    ),
                  for (var each in _toDisplayWeek)
                    Text("$each", style: TextStyle(fontSize: 24)),
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
                onSubmitted: (value) => {searchInput(-1)},
                onChanged: (value) {
                  if (_debounce != null && _debounce?.isActive == true)
                    {_debounce?.cancel();}
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
                        print(index);
                        searchInput(index);
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
