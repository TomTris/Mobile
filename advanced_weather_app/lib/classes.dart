class InHourData {
  InHourData(
    this.hour, this.temperature_2m, this.weather_code, this.wind_speed_10m
  );
  final int hour;
  final double temperature_2m;
  final int weather_code;
  final double wind_speed_10m;
}

class WeekData {
  WeekData(
    this.dayMonth, this.max, this.min, this.weather_code
  );
  final String dayMonth;
  final double max;
  final double min;
  final int weather_code;
}
