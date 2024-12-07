import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'classes.dart';

IconData getWeatherIcon(int number) {
  switch (number) {
    case 0:
      return Icons.wb_sunny; // Clear sky
    case 1:
      return Icons.wb_sunny; // Mainly clear
    case 2:
      return Icons.cloud_queue; // Partly cloudy
    case 3:
      return Icons.cloud; // Overcast
    case 45:
    case 48:
      return Icons.dehaze; // Fog / Depositing rime fog
    case 51:
    case 53:
    case 55:
      return Icons.grain; // Light to dense drizzle
    case 56:
    case 57:
      return Icons.ac_unit; // Freezing drizzle
    case 61:
    case 63:
    case 65:
      return Icons.umbrella; // Light to heavy rain
    case 66:
    case 67:
      return Icons.ac_unit; // Freezing rain
    case 71:
    case 73:
    case 75:
      return Icons.ac_unit; // Snowfall
    case 77:
      return Icons.snowing; // Snow grains (or fallback to ac_unit)
    case 80:
    case 81:
    case 82:
      return Icons.umbrella; // Rain showers
    case 85:
    case 86:
      return Icons.ac_unit; // Snow showers
    case 95:
      return Icons.flash_on; // Slight thunderstorm
    case 96:
    case 99:
      return Icons.bolt; // Thunderstorm with hail
    default:
      return Icons.help_outline; // Undefined weather
  }
}

class CurrentPage extends StatelessWidget {
  const CurrentPage({
    super.key,
    required this.toDisplay,
    required this.toDisplayCurrent,
    required this.weather_code,
  });

  final String             toDisplay;
  final List<String> toDisplayCurrent;
  final int weather_code;

  @override
  Widget build(BuildContext context) {
    List<Widget> toDisplayCurrentPage(int weather_code){
      if (toDisplayCurrent.isEmpty) {
        return  [Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // horizental
          children: [Text(toDisplay, style: TextStyle(fontSize: 21, color: Colors.white70)),]
        )];
      }
      if (toDisplayCurrent.length < 4) {
        return [
          for (var each in toDisplayCurrent)
            Text(each, style: TextStyle(fontSize: 21, color: Colors.white),)
        ];
      }
      int count = 0;
      return [
        Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.blue)),
        if (toDisplayCurrent.length == 6)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white54,),
              Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 19, color: Colors.white70)),],
          ),
        Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 19, color: Colors.white70)),
        Text (""), Text (""), Text (""),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.thermostat, color: Colors.orange, size: 60,),
            Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 37, color: Colors.orange,)),]
        ),
        Text (""), Text (""),
        Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 21, color: Colors.white)),
        Icon(
          getWeatherIcon(weather_code), 
          color: Colors.blue,
          size: 60,),
        Text (""), Text (""),
        Row (
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.air, color: Colors.blue, size: 35,),
            Text (toDisplayCurrent[count++], style: TextStyle(fontSize: 21, color: Colors.white,)),]
        ),
      ];
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // horizental
      children: toDisplayCurrentPage(weather_code),
    );
  }
}


class TodayPage extends StatelessWidget {
  const TodayPage({
    super.key,
    required this.toDisplay,
    required this.toDisplayToday,
    required this.chartData
  });

  final String             toDisplay;
  final List<String> toDisplayToday;
  final List<InHourData>? chartData;
  
  @override
  Widget build(BuildContext context) {
  List<Widget> toDisplayTodayPage()
  {
    int count = 0;
    if (toDisplayToday.isEmpty) {
        return  [Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // horizental
          children: [Text(toDisplay, style: TextStyle(fontSize: 21, color: Colors.white70)),]
        )];
      }
      if (toDisplayToday.length < 4) {
        return [
          for (var each in toDisplayToday)
            Text(each, style: TextStyle(fontSize: 21, color: Colors.white),)
        ];
      }
    return [
      Text (toDisplayToday[count++], style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.blue)),
      if (toDisplayToday.length == 28)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, color: Colors.white54,),
            Text (toDisplayToday[count++], style: TextStyle(fontSize: 19, color: Colors.white70)),],
        ),
      Text (toDisplayToday[count++], style: TextStyle(fontSize: 19, color: Colors.white70)),
      Row (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.today, color: Colors.orange, size: 19,),
          Text (toDisplayToday[count++], style: TextStyle(fontSize: 19, color: Colors.orange,)),]
      ),
      SfCartesianChart(
        title: ChartTitle(
          text: 'Temperatur of Today'),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <ChartSeries>[
          StackedLineSeries<InHourData, int>(
            dataSource:   chartData!,
            xValueMapper: (InHourData exp, _)=> exp.hour,
            yValueMapper: (InHourData exp, _)=> exp.temperature_2m,
            name: "Father",
            markerSettings:  MarkerSettings(isVisible: true),
            color: Colors.orange
            ),
        ],
        primaryXAxis: NumericAxis(
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel('${details.value.toString().padLeft(2, '0')}:00', TextStyle(color: Colors.white60));
          },
        ),
        primaryYAxis: NumericAxis(
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            return ChartAxisLabel('${details.value}°C', TextStyle(color: Colors.white60));
          },
        ),
      )
    ];
  }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center, // horizental
      children: toDisplayTodayPage());
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
              Text(toDisplay, style: TextStyle(fontSize: 21)),
            ]
          ),
        for (var each in toDisplayWeek)
          Text(each, style: const TextStyle(fontSize: 21)),
      ],
    );
  }
}
