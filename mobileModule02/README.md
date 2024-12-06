API to get reverse:
https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json

API to for forecast and searching.
https://api.open-meteo.com/v1/forecast?latitude=${cityLanLon[index]?[0]}&longitude=${cityLanLon[index]?[1]}&current=temperature_2m,weather_code,wind_speed_10m
https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=10&language=en&format=json

Features:
- Click in geography button -> search current location + weather at current location
- search weather at a city as you want by putting a name into search bar with some difference information