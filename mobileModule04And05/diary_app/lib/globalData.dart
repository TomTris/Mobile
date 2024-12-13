import 'package:flutter/material.dart';

class GlobalData {
  static var entries = null;
  static var entriesSorted = null;
  static final List<String> feelingList = ['very_happy', 'happy', 'sad', 'very_sad', 'angry', 'neutral'];

  static int getPercentage(String feeling)
  {
    int found = 0;
    int count = 0;
  
    if (entriesSorted == null || entriesSorted.length == 0)
      return (0);
    for (String each in feelingList) {
      if (each == feeling) {
        found = 1;
        break;
      }
    }
    if (found == 0)
      return (0);
    for (var each in entriesSorted) {
      if (feeling == each.value['feeling']) {
        count += 1;
      }
    }
    return (count * 100 / entriesSorted.length).toInt();
  }
  
  static Icon getIcon(String feeling)
  {
    late IconData res;
    var color;

    switch (feeling)
    {
      case ('very_happy'):
        res = Icons.sentiment_satisfied_alt;
        color = Colors.orange;
      case ('happy'):
        res = Icons.sentiment_very_satisfied;
        color = const Color.fromARGB(255, 191, 150, 15);
      case ('sad'):
        res = Icons.sentiment_dissatisfied;
        color = Colors.grey;
      case ('very_sad'):
        res = Icons.sentiment_very_dissatisfied;
        color = Colors.black;
      case ('angry'):
        res = Icons.face;
        color = Colors.red;
      case ('neutral'):
        res = Icons.sentiment_neutral;
        color = Colors.green;
    }
    return (
      Icon( res,
        color: color,
        size: 35,
      ));
  }
}
