import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/fetch_state.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_example_flutter/src/model/forecast_data.dart';
import 'package:open_weather_example_flutter/src/model/weather_data.dart';

class WeatherProvider extends ChangeNotifier {
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  );
  bool _isRefreshing = false;
  late String _errorMessage;
  FetchState _weatherFetchState = FetchState.not_fetched;
  FetchState _forecastweatherFetchState = FetchState.not_fetched;
  String city = '';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  Future<WeatherData?> getWeatherData([bool isRefresh = false]) async {
    if (isRefresh) {
      _isRefreshing = true;
    }
    _weatherFetchState = FetchState.fetching;
    notifyListeners();
    try {
      currentWeatherProvider = await repository.getWeather(city: city);
      _weatherFetchState = FetchState.done;
      _isRefreshing = false;
      await getForecastData();
      return currentWeatherProvider!;
    } catch (e) {
      _errorMessage = e.toString();
      _weatherFetchState = FetchState.errored;
      _isRefreshing = false;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getForecastData([bool isRefresh = false]) async {
    if (isRefresh) {
      _isRefreshing = true;
    }
    _forecastweatherFetchState = FetchState.fetching;
    notifyListeners();
    try {
      hourlyWeatherProvider = await repository.getForecast(city: city);
      _forecastweatherFetchState = FetchState.done;
      _isRefreshing = false;
    } catch (e) {
      _errorMessage = e.toString();
      _forecastweatherFetchState = FetchState.errored;
      _isRefreshing = false;
      notifyListeners();
    }
    notifyListeners();
  }

  void setCity(String newCity) {
    city = newCity;
    getWeatherData();
    notifyListeners();
  }

  FetchState get weatherFetchState => _weatherFetchState;
  FetchState get forecastweatherFetchState => _forecastweatherFetchState;
  String? get errorMessage =>
      forecastweatherFetchState == FetchState.errored ? _errorMessage : null;
  String? get weatherErrorMessage =>
      _weatherFetchState == FetchState.errored ? _errorMessage : null;

  void reset() {
    _weatherFetchState = FetchState.not_fetched;
    _forecastweatherFetchState = FetchState.not_fetched;
    notifyListeners();
  }
}
