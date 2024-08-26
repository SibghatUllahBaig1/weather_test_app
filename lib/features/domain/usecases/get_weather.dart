import '../../../core/error/failure.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {

  final WeatherRepository weatherRepository;

  GetWeatherUseCase({required this.weatherRepository});

  Future<(List<WeatherEntity?>?, Failure?)> execute(double latitude, double longitude) {
    return weatherRepository.getWeather(latitude, longitude);
  }
}