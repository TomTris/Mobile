import 'package:flutter/material.dart';

class CurrentPage extends StatelessWidget {
  const CurrentPage({
    super.key,
    required this.toDisplay,
    required this.toDisplayCurrent,
  });

  final String             toDisplay;
  final List<String> toDisplayCurrent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // horizental
      children: [
        if (toDisplayCurrent.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // horizental
            children: [
              Text("Currently", style: TextStyle(fontSize: 21)),
              Text(toDisplay, style: TextStyle(fontSize: 21)),
            ]
          ),
        for (var each in toDisplayCurrent)
          Text(each, style: const TextStyle(fontSize: 21)),
      ],
    );
  }
}

class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
    required this.toDisplay,
    required this.toDisplayToday,
  });

  final String             toDisplay;
  final List<String> toDisplayToday;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // horizental
      children: [
        if (toDisplayToday.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // horizental
            children: [
              Text("Today", style: TextStyle(fontSize: 21)),
              Text(toDisplay, style: TextStyle(fontSize: 21)),
            ]
          ),
        for (var each in toDisplayToday)
          Text(each, style: TextStyle(fontSize: 21)),
      ],
    );
  }
}

class WeekPage extends StatelessWidget {
  const WeekPage({
    super.key,
    required this.toDisplay,
    required this.toDisplayWeek,
  });

  final String             toDisplay;
  final List<String> toDisplayWeek;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // horizental
      children: [
        if (toDisplayWeek.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // horizental
            children: [
              Text("Currently", style: TextStyle(fontSize: 21)),
              Text(toDisplay, style: TextStyle(fontSize: 21)),
            ]
          ),
        for (var each in toDisplayWeek)
          Text(each, style: const TextStyle(fontSize: 21)),
      ],
    );
  }
}
