import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/fetch_state.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_forecast.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:open_weather_example_flutter/src/model/weather_data.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatefulWidget {
  CurrentWeather({super.key, required this.city});
  final String city;

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool isCelsius = true;
  final List<bool> _selectedWeather = <bool>[true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.rainBlueLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Weather'),
        ),
        body: Selector<
                WeatherProvider,
                (
                  String city,
                  WeatherData? weatherData,
                  FetchState state,
                  String? errorMessage
                )>(
            selector: (context, provider) => (
                  provider.city,
                  provider.currentWeatherProvider,
                  provider.weatherFetchState,
                  provider.weatherErrorMessage
                ),
            builder: (context, data, _) {
              if (data.$3 == FetchState.fetching) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.rainBlueDark,
                ));
              }
              if (data.$3 == FetchState.errored) {
                return Center(child: Text(data.$4 ?? ''));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToggleButtons(
                    selectedColor: Colors.white,
                    fillColor: Colors.blue[200],
                    isSelected: _selectedWeather,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedWeather.length; i++) {
                          _selectedWeather[i] = i == index;
                        }
                      });
                    },
                    children: const [
                      Text('°C'),
                      Text('°F'),
                    ],
                  ),
                  Center(
                      child: Text(data.$1,
                          style: Theme.of(context).textTheme.headlineMedium)),
                  Expanded(
                      child: CurrentWeatherContents(
                          data: data.$2!, celsius: _selectedWeather[0])),
                  Expanded(
                      child: WeatherForecast(
                    isCelsius: _selectedWeather[0],
                  )),
                ],
              );
            }));
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents(
      {super.key, required this.data, required this.celsius});
  final bool celsius;
  final WeatherData? data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (data == null) return const SizedBox();

    final temp = data?.main!.temp;
    final minTemp = data?.main!.tempMin;
    final maxTemp = data?.main!.tempMax;
    final weatherDesc = data?.weather!.first.description;
    final icon = data?.weather!.first.icon;
    final highAndLow = celsius
        ? 'H:${maxTemp.toInt()}°  L:${minTemp.toInt()}°'
        : 'H:${celsiusToFahrenheit(maxTemp)}°F  L:${celsiusToFahrenheit(minTemp)}°F';
    return Column(mainAxisSize: MainAxisSize.min, children: [
      WeatherIconImage(iconUrl: icon!, size: 120),
      Text(weatherDesc ?? '', style: textTheme.bodyMedium),
      Text(celsius ? '${temp.toInt()}°C' : '${celsiusToFahrenheit(temp)}°F',
          style: textTheme.displayMedium),
      Text(highAndLow, style: textTheme.bodyMedium),
    ]);
  }

  celsiusToFahrenheit(double celsius) {
    return ((celsius * 9 / 5) + 32).toInt();
  }
}
