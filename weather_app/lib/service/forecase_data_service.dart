import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/7dayforecast.dart';

class ForecastDataService {
  Future<Forecast> getWeatherFocast(
    double lat,
    double lon,
  ) async {
    // api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    // api.openweathermap.org/data/2.5/forecast?lat=12.4&lon=12.4&appid=e7faa38ee4bba1e7ff87a28aa06f29c1

    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': 'e7faa38ee4bba1e7ff87a28aa06f29c1',
    };

    final url = Uri.https(
        'api.openweathermap.org', '/data/2.5/forecast', queryParameters);

    final response = await http.get(url);

    final json = jsonDecode(response.body);
    print(json);

    return Forecast.fromJson(json);
  }
}
