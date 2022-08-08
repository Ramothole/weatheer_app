import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/7dayforecast.dart';

import 'package:weather_app/model/weather.dart';

class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    // api.openweathermap.org/data/2.5/forecast?lat=12.4&lon=12.4&appid=e7faa38ee4bba1e7ff87a28aa06f29c1

    final queryParameters = {
      'q': city,
      'appid': 'e7faa38ee4bba1e7ff87a28aa06f29c1',
      'units': 'metric',
    };

    final uri = Uri.https(
      'api.openweathermap.org',
      '/data/2.5/weather',
      queryParameters,
    );

    final response = await http.get(uri);

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
