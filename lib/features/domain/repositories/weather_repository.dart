import '../../../core/error/failure.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<(List<WeatherEntity?>?, Failure?)> getWeather(double latitude, double longitude);
}