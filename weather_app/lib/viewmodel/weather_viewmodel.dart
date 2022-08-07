import 'package:flutter/material.dart';
import 'package:weather_app/fetchState.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/service/data_service.dart';

class WeatherViewModel extends ChangeNotifier {
  late DataService? _repository;

  FetchState _weatherFetchState = FetchState.not_fetched;
  WeatherResponse? _weatherResponse;
  String? _errorMessage;

  WeatherViewModel({required DataService repository})
      : _repository = repository;
  Future<WeatherResponse> getWeather(String city) async {
    _weatherFetchState = FetchState.fetching;
    notifyListeners();
    try {
      _weatherResponse = (await _repository!.getWeather(city));
      _weatherFetchState = FetchState.done;
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _weatherFetchState = FetchState.errored;
      notifyListeners();
    }
    notifyListeners();

    return _weatherResponse!;
  }

  FetchState get legalContentFetchState => _weatherFetchState;

  WeatherResponse? get weather => _weatherResponse;

  String? get errorMessage =>
      legalContentFetchState == FetchState.errored ? _errorMessage : null;
}
