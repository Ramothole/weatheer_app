import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:provider/provider.dart';

class CitySearchBox extends StatefulWidget {
  const CitySearchBox({Key? key}) : super(key: key);

  @override
  State<CitySearchBox> createState() => _CitySearchRowState();
}

class _CitySearchRowState extends State<CitySearchBox> {
  static const _radius = 30.0;
  bool _validate = false;
  late final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // circular radius
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: _radius * 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Location",
                  errorText: _validate ? "City Can't Be Empty" : null,
                ),
              ),
            ),
            InkWell(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accentColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(_radius),
                    bottomRight: Radius.circular(_radius),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text('search',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                var provider = context.read<WeatherProvider>();
                provider.setCity(_searchController.text);
                setState(() {
                  _validate = _searchController.text.isEmpty;
                });
                if (_validate == false) {
                  Provider.of<WeatherProvider>(context, listen: false)
                      .getWeatherData()
                      .then((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CurrentWeather(city: _searchController.text),
                      ),
                    );
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
