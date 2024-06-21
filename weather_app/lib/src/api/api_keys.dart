import 'package:get_it/get_it.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
   sl.registerSingleton<String>('b3ca9ace28074a20fea6db7070833388', instanceName: 'api_key');
  sl.registerLazySingleton<HttpWeatherRepository>(() => HttpWeatherRepository(
   api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
  ));
}
