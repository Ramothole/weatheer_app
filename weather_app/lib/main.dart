import 'package:flutter/material.dart';

import 'package:weather_app/model/7dayforecast.dart';
import 'package:weather_app/model/weather.dart';
import 'package:weather_app/service/data_service.dart';
import 'package:weather_app/service/forecase_data_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();
  final _forecastDataService = ForecastDataService();
  WeatherResponse? weatherResponse;
  Forecast? forecastResponse;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpeg'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
          scale: 20,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Weather',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        width: 150,
                        child: TextField(
                            style: TextStyle(color: Colors.white),
                            controller: _cityTextController,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _search,
                      child: const Text('Search'),
                    ),
                  ],
                ),
                if (weatherResponse != null)
                  Column(
                    children: [
                      location(),
                      Container(
                        height: 80,
                        width: 90,
                        child: weatherIcon(
                            weatherResponse!.weather![0].description!),
                      ),
                      temparature(),
                      Text(weatherResponse!.weather![0].description!,
                          style: textStyle),
                      const SizedBox(
                        height: 16,
                      ),
                      dailyWeatherCast('Daily weather Forecast', 7,
                          '23/08/2022', 26, Axis.horizontal),
                      weatherCast(),
                      additionalInfo(
                          weatherResponse!.wind!.speed.toString(),
                          weatherResponse!.main!.humidity.toString(),
                          weatherResponse!.main!.pressure.toString(),
                          weatherResponse!.main!.feelsLike.toString()),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                if (weatherResponse == null)
                  const Center(
                    child: Text('Location not found'),
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  weatherIcon(String weatherDeescription) {
    switch (weatherDeescription) {
      case ('sunny'):
        return Image.asset('assets/sunny.jpeg');
      case ('few clouds'):
        return Image.asset('assets/few_clouds.png');

      case ('overcast clouds'):
        return Image.asset('assets/cloudy.png');
      case ('rain'):
        return Image.asset('assets/rain.jpeg');
      case ('scattered clouds'):
        return Image.asset('assets/ligh_rain.webp');
      case ('light rain'):
        return Image.asset('assets/ligh_rain.jpeg');
      default:
        return Image.asset('assets/few_clouds.png');
    }
  }

  temparature() {
    return Text(
      '${weatherResponse!.main!.temp}°',
      style: const TextStyle(
          fontWeight: FontWeight.w300, fontSize: 30, color: Colors.white),
    );
  }

  location() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //  Icon(Icons.place, size: 16, color: Colors.red),
        Text('${weatherResponse!.name}',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white))
      ],
    );
  }

  heading(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
              gradient:
                  LinearGradient(colors: [Colors.lightBlue, Colors.blueGrey]),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: Text(title, style: textStyle)));
  }

  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w300,
  );
  additionalInfo(
      String wind, String humidity, String pressure, String feelsLike) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [Colors.lightBlue, Colors.blueGrey]),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            heading('Additiona info '),
            const Divider(
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wind:', style: textStyle),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Humidity:', style: textStyle)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wind, style: textStyle),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(humidity, style: textStyle)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pressure:', style: textStyle),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('Feels Like:', style: textStyle)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pressure, style: textStyle),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(feelsLike, style: textStyle)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  dailyWeatherCast(
    String title,
    int itemCount,
    String date,
    int temp,
    Axis scrollDireection,
  ) {
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Card(
          color: Colors.transparent,
          child: Column(
            children: [
              heading(title),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueGrey]),
                ),
                child: const Divider(
                  color: Colors.white,
                ),
              ),
              Container(
                height: constraints.maxWidth / 3,
                width: constraints.maxWidth / 0.4,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueGrey]),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemCount,
                    scrollDirection: scrollDireection,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              date,
                              style: textStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                            width: 10,
                          ),
                          Container(
                              child: Image.asset(
                            'assets/sunny.jpeg',
                            scale: 24,
                          )),
                          const SizedBox(
                            height: 6,
                            width: 10,
                          ),
                          const SizedBox(
                            height: 6,
                            width: 10,
                          ),
                          Text(
                            '$temp°',
                            style: textStyle,
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  weatherCast() {
    return LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Card(
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            children: [
              heading('10-Day Weather Forecast'),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueGrey]),
                ),
                child: const Divider(
                  color: Colors.white,
                ),
              ),
              Container(
                height: constraints.maxWidth / 2,
                width: constraints.maxWidth + 10,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blueGrey]),
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 7,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'date',
                              style: textStyle,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                            width: 10,
                          ),
                          Container(
                              child: Image.asset(
                            'assets/sunny.jpeg',
                            scale: 40,
                          )),
                          // const Icon(
                          //   Icons.sunny,
                          //   size: 24,
                          //   color: Colors.yellow,
                          // ),
                          const SizedBox(
                            height: 6,
                            width: 10,
                          ),
                          Text(
                            '14°',
                            style: textStyle,
                          ),
                          Text(
                            '24°',
                            style: textStyle,
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _search() async {
    final response = await _dataService.getWeather(_cityTextController.text);
    setState(() => weatherResponse = response);

    final forecast = await _forecastDataService.getWeatherFocast(23.4, 12.3);
    setState(() {
      forecastResponse = forecast;
    });
  }
}
