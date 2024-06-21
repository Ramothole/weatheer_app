import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/model/forecast_data.dart';
import 'package:open_weather_example_flutter/src/model/weather_data.dart';

class HttpWeatherRepository {
  final OpenWeatherMapAPI api;
  final http.Client client;

  HttpWeatherRepository({required this.api, required this.client});

  @override
  Future<ForecastData?> getForecast({
    required String? city,
  }) async {
    try {
      final Uri uri = api.forecast(city!);
      final response = await client.get(uri).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw NoInternetConnectionException();
        },
      );
      final decodedBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return ForecastData.fromJson(decodedBody);
      } else if (response.statusCode == HttpStatus.notFound) {
        throw CityNotFoundException();
      } else {
        throw UnknownException();
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<WeatherData?> getWeather({required String? city}) async {
    try {
      final Uri uri = api.weather(city!);
      final response = await client.get(uri).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw NoInternetConnectionException();
        },
      );
      final decodedBody = json.decode(response.body);
      if (response.statusCode == HttpStatus.ok) {
        return WeatherData.fromJson(decodedBody);
      } else if (response.statusCode == HttpStatus.notFound) {
        throw CityNotFoundException();
      } else if (response.statusCode == HttpStatus.unauthorized) {
        throw InvalidApiKeyException();
      } else {
        throw UnknownException();
      }
    } catch (e) {
      throw e;
    }
  }
}
