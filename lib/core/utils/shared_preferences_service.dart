import 'package:weater_app/features/domain/entities/weather_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {

  static Future<void> saveWeatherEntityList(List<WeatherEntity> weatherList) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> weatherJsonList = weatherList.map((weather) => jsonEncode(weather.toJson())).toList();
    await prefs.setStringList('weather_entity_list', weatherJsonList);
  }

  static Future<List<WeatherEntity>?> getWeatherEntityList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? weatherJsonList = prefs.getStringList('weather_entity_list');

    if (weatherJsonList != null) {
      return weatherJsonList.map((weatherJson) {
        Map<String, dynamic> json = jsonDecode(weatherJson);
        return WeatherEntity.fromJson(json);
      }).toList();
    }

    return null;
  }


}