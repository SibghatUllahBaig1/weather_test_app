import 'dart:io';
import 'package:weater_app/features/domain/entities/weather_entity.dart';
import '../../../core/error/exception.dart';
import '../../../core/error/failure.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasource/remote_data_source.dart';
import '../model/weather_model.dart';

class WeatherRepositoryImpl extends WeatherRepository {

  final WeatherRemoteDataSource weatherRemoteDataSource;
  WeatherRepositoryImpl({required this.weatherRemoteDataSource});

  @override
  Future<(List<WeatherEntity>?, Failure?)> getWeather(double latitude, double longitude) async {
    try {
      // Fetch data from the remote data source
      final WeatherResponse? response = await weatherRemoteDataSource.getWeather(latitude, longitude);

      // Check if response is valid and contains data
      if (response != null && response.list.isNotEmpty) {
        // Convert response data to a list of WeatherEntity
        final List<WeatherEntity> weatherEntities = response.list.map((weatherData) {
          return WeatherEntity(
            cityName: response.city.name,
            main: weatherData.weather.isNotEmpty ? weatherData.weather[0].main : '',
            description: weatherData.weather.isNotEmpty ? weatherData.weather[0].description : '',
            iconCode: weatherData.weather.isNotEmpty ? weatherData.weather[0].icon : '',
            temperature: weatherData.main.temp,
            pressure: weatherData.main.pressure,
            humidity: weatherData.main.humidity,
            dateTime: weatherData.dt_txt
          );
        }).toList();

        // Return the list of WeatherEntity
        return (weatherEntities, null);
      } else {
        return (null, const ServerFailure('No weather data found.'));
      }
    } on ServerException {
      return (null, const ServerFailure('An error has occurred'));
    } on SocketException {
      return (null, const ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      return (null, ServerFailure('Unknown error: $e'));
    }
  }

}