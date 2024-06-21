import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/fetch_state.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:open_weather_example_flutter/src/model/daily_data.dart';
import 'package:open_weather_example_flutter/src/model/forecast_data.dart';
import 'package:provider/provider.dart';

class WeatherForecast extends StatefulWidget {
  final bool isCelsius;
  const WeatherForecast({required this.isCelsius, Key? key});

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  @override
  Widget build(BuildContext context) {
    return Selector<
        WeatherProvider,
        (
          String city,
          ForecastData? weatherData,
          FetchState state,
          String? errorMessage,
        )>(
      selector: (context, provider) => (
        provider.city,
        provider.hourlyWeatherProvider,
        provider.forecastweatherFetchState,
        provider.errorMessage,
      ),
      builder: (context, data, _) {
        if (data.$3 == FetchState.fetching) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.rainBlueDark,
            ),
          );
        }
        if (data.$3 == FetchState.errored) {
          return Center(
            child: Text(data.$4 ?? ''),
          );
        }
        if (data.$3 == FetchState.done) {
          List<ListElement>? hourly = data.$2?.list;
          var dailyData = hourlyToDaily(data.$2!.list!);

          return Expanded(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: dailyData.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return WeatherHourlyList(
                  daily: dailyData[index],
                  isCelsius: widget.isCelsius,
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }

  List<DailyWeather> hourlyToDaily(List<ListElement> hourlyData) {
    Map<String, DailyWeather> dailyData = {};

    for (var hour in hourlyData) {
      DateTime date = DateTime.parse(hour.dtTxt!);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String dayOfWeek = DateFormat('EEE').format(date);

      if (!dailyData.containsKey(formattedDate)) {
        dailyData[formattedDate] = DailyWeather(
          day: dayOfWeek,
          minTemp: hour.main!.tempMin!,
          maxTemp: hour.main!.tempMax!,
          icon: hour.weather!.isNotEmpty ? hour.weather!.first.icon! : '',
        );
      }
    }

    return dailyData.values.toList();
  }
}

class WeatherHourlyList extends StatelessWidget {
  final DailyWeather daily;
  final bool isCelsius;

  WeatherHourlyList({Key? key, required this.daily, required this.isCelsius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(daily.day, style: textTheme.bodyMedium),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: WeatherIconImage(
            iconUrl: daily.icon,
            size: 120,
          ),
        ),
        const SizedBox(
          height: 16,
          width: 10,
        ),
        Text(
            isCelsius
                ? '${daily.maxTemp.toInt()}°C'
                : '${celsiusToFahrenheit(daily.maxTemp)}°F',
            style: textTheme.bodyMedium),
      ],
    );
  }

  int celsiusToFahrenheit(double celsius) {
    return ((celsius * 9 / 5) + 32).toInt();
  }
}
