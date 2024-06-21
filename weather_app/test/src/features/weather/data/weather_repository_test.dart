import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/fetch_state.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:open_weather_example_flutter/src/model/weather_data.dart';

class MockHttpClient extends Mock implements http.Client {}

const encodedWeatherJsonResponse = """
{
  "coord": {
    "lon": -122.08,
    "lat": 37.39
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {
    "speed": 1.5,
    "deg": 350
  },
  "clouds": {
    "all": 1
  },
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
  }  
""";

final expectedWeatherFromJson = WeatherData(
  main: Main(
      temp: 282.55,
      tempMin: 280.37,
      tempMax: 284.26,
      feelsLike: 24.2,
      pressure: 12.4,
      humidity: 23),
  weather: [
    Weather(description: 'clear sky', icon: '01d', main: 'Clear', id: 0)
  ],
  dt: 1560350645,
);

void main() {
  late HttpWeatherRepository weatherRepository;
  late WeatherProvider provider;
  setupInjection();
  test('repository with mocked http client, success', () async {
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI('apiKey');
    final weatherRepository =
        HttpWeatherRepository(api: api, client: mockHttpClient);

    when(() => mockHttpClient.get(api.weather('mountain view'))).thenAnswer(
        (_) => Future.value(http.Response(encodedWeatherJsonResponse, 200)));
    final weather = await weatherRepository.getWeather(city: 'mountain view');

    expect(weather!.main!.temp, expectedWeatherFromJson.main!.temp);
    expect(weather.main!.tempMin, expectedWeatherFromJson.main!.tempMin);
    expect(weather.dt, expectedWeatherFromJson.dt);
  });

  test('repository with mocked http client, failure', () async {
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI('apiKey');
    final weatherRepository =
        HttpWeatherRepository(api: api, client: mockHttpClient);
    when(() => mockHttpClient.get(api.weather('unauthorized')))
        .thenAnswer((_) => Future.value(http.Response('{}', 401)));
    expect(() => weatherRepository.getWeather(city: 'unauthorized'),
        throwsA(isA<UnknownException>()));

    when(() => mockHttpClient.get(api.weather('citynotfound')))
        .thenAnswer((_) => Future.value(http.Response('{}', 404)));
    expect(() => weatherRepository.getWeather(city: 'citynotfound'),
        throwsA(isA<CityNotFoundException>()));
  });

  test('fetches weather data successfully', () async {
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI('apiKey');
    final mockRepository =
        HttpWeatherRepository(api: api, client: mockHttpClient);
    final provider = WeatherProvider();
    final mockWeatherData = WeatherData(
      main: Main(
          temp: 282.55,
          tempMin: 280.37,
          tempMax: 284.26,
          feelsLike: 24.2,
          pressure: 12.4,
          humidity: 23),
      weather: [
        Weather(main: 'Clear', id: 0, description: 'clear sky', icon: '01d')
      ],
      dt: 1560350645,
    );

    when(() => mockHttpClient.get(api.weather('mountain view'))).thenAnswer(
        (_) => Future.value(http.Response(encodedWeatherJsonResponse, 200)));
    await provider.getWeatherData();
    expect(provider.weatherFetchState, FetchState.done);
    expect(provider.currentWeatherProvider, mockWeatherData);
    expect(provider.errorMessage, null);
  });
}
