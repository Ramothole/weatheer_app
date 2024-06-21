import 'dart:convert';

class WeatherData {
  final List<Weather>? weather;
  final Main? main;
  final int? dt;

  WeatherData({required this.weather, required this.main, required this.dt});
  factory WeatherData.fromRawJson(String str) =>
      WeatherData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        weather:
            List<Weather>.from(json['weather'].map((x) => Weather.fromJson(x))),
        dt: json['dt'],
        main: Main.fromJson(json['main']),
      );

  Map<String, dynamic> toJson() => {
        'weather': List<dynamic>.from(weather!.map((x) => x.toJson())),
        'main': main!.toJson(),
        'dt': dt
      };
}

class Main {
  final dynamic temp;
  final dynamic feelsLike;
  final dynamic tempMin;
  final dynamic tempMax;
  final dynamic pressure;
  final dynamic humidity;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json['temp'],
        feelsLike: json['feels_like'],
        tempMin: json['temp_min'],
        tempMax: json['temp_max'],
        pressure: json['pressure'],
        humidity: json['humidity'],
      );

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'humidity': humidity,
      };
}

class Weather {
  final dynamic id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
