import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/7dayforecast.dart';

class ForecastDataService {
  Future<Forecast> getWeatherFocast(
    String lat,
    String lon,
  ) async {
    final queryParameters = {
      'lat': lat,
      'lon': lon,
      'appid': 'e7faa38ee4bba1e7ff87a28aa06f29c1',
      'units': 'metric'
    };

    final url = Uri.https(
        'api.openweathermap.org', '/data/2.5/forecast', queryParameters);

    final response = await http.get(url);

    final json = jsonDecode(response.body);

    return Forecast.fromJson(json);
  }
}
