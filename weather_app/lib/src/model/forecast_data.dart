import 'dart:convert';

class ForecastData {
  final String? cod;
  final List<ListElement>? list;

  ForecastData({
    required this.cod,
    required this.list,
  });

  factory ForecastData.fromRawJson(String str) =>
      ForecastData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    return ForecastData(
      cod: json['cod'],
      list: (json['list'] as List<dynamic>?)
        ?.map((e) => ListElement.fromJson(e))
        .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'cod': cod,
        'list':  list?.map((x) => x.toJson()).toList(),
      };
}

class Coord {
  final double? lat;
  final double? lon;

  Coord({
    required this.lat,
    required this.lon,
  });

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lat: json['lat'],
      lon: json['lon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };
}

class ListElement {
  final Main? main;
  final List<Weather>? weather;
  final dynamic pop;

  final String? dtTxt;

  ListElement({
    required this.main,
    required this.weather,
    required this.pop,

    required this.dtTxt,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) {
    return ListElement(
      main: Main.fromJson(json['main']),
      weather: (json['weather'] as List<dynamic>?)
        ?.map((e) => Weather.fromJson(e))
        .toList(),
      pop: json['pop'],
      dtTxt: json['dt_txt'],
    );
  }

  Map<String, dynamic> toJson() => {
        'main': main!.toJson(),
        'weather':List<Map<String, dynamic>>.from(
            (weather)!.map((x) => x.toJson())),
        'pop': pop,
        'dt_txt': dtTxt,
      };
}

class Main {
  final dynamic temp;
  final dynamic feelsLike;
  final dynamic tempMin;
  final dynamic tempMax;
  final dynamic tempKf;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.tempKf,
  });

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: json['temp'],
      feelsLike: json['feels_like'],
      tempMin: json['temp_min'],
      tempMax: json['temp_max'],
      tempKf: json['temp_kf'],
    );
  }

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'temp_kf': tempKf,
      };
}

class Weather {
   final dynamic id;
  final String? main;
  final String? description;
  final String? icon;

  Weather({
     required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
       id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
