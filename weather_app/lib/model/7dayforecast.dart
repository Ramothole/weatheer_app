import 'dart:convert';

class Forecast {
  Forecast({
    this.cod,
    this.cnt,
    this.list,
    this.city,
  });

  final String? cod;
  final int? cnt;
  final List<ListElement>? list;
  final City? city;

  factory Forecast.fromRawJson(String str) =>
      Forecast.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        cod: json["cod"],
        cnt: json["cnt"],
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        city: City.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() => {
        "cod": cod,
        "cnt": cnt,
        "list": List<dynamic>.from(list!.map((x) => x.toJson())),
        "city": city!.toJson(),
      };
}

class City {
  City({
    this.name,
  });

  final String? name;

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class ListElement {
  ListElement({
    this.dt,
    this.main,
    this.weather,
    this.dtTxt,
  });

  final int? dt;
  final MainClass? main;
  final List<Weather>? weather;

  final DateTime? dtTxt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        dt: json["dt"],
        main: MainClass.fromJson(json["main"]),
        weather:
            List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        dtTxt: DateTime.parse(json["dt_txt"]),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "main": main!.toJson(),
        "weather": List<dynamic>.from(weather!.map((x) => x.toJson())),
        "dt_txt": dtTxt!.toIso8601String(),
      };
}

class MainClass {
  MainClass({
    this.temp,
    this.tempMin,
    this.tempMax,
  });

  final double? temp;
  final double? tempMin;
  final double? tempMax;

  factory MainClass.fromJson(Map<String, dynamic> json) => MainClass(
        temp: json["temp"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "temp_min": tempMin,
        "temp_max": tempMax,
      };
}

class Weather {
  Weather({
    this.id,
    this.main,
    this.description,
  });

  final int? id;
  final MainEnum? main;
  final Description? description;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"],
        main: mainEnumValues.map![json["main"]],
        description: descriptionValues.map![json["description"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": mainEnumValues.reverse[main],
        "description": descriptionValues.reverse[description],
      };
}

enum Description { CLEAR_SKY, FEW_CLOUDS, SCATTERED_CLOUDS }

final descriptionValues = EnumValues({
  "clear sky": Description.CLEAR_SKY,
  "few clouds": Description.FEW_CLOUDS,
  "scattered clouds": Description.SCATTERED_CLOUDS
});

enum MainEnum { CLEAR, CLOUDS }

final mainEnumValues =
    EnumValues({"Clear": MainEnum.CLEAR, "Clouds": MainEnum.CLOUDS});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
