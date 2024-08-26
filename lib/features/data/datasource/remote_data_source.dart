import 'dart:convert';
import 'package:weater_app/features/data/serializers/serializers.dart';

import '../../../core/constant/constant.dart';
import '../../../core/error/exception.dart';
import '../../../core/network/dio_client.dart';
import '../model/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherResponse?> getWeather(double latitude, double longitude);
}


class WeatherRemoteDataSourceImpl extends WeatherRemoteDataSource {
  final DioClient dioClient;

  WeatherRemoteDataSourceImpl({required this.dioClient});

  @override
  Future <WeatherResponse?> getWeather(double latitude, double longitude) async {
    final response = await dioClient.get(Urls.currentWeatherByLocation(latitude, longitude));

    if (response.statusCode == 200) {
      final weatherResponse = serializers.deserializeWith<WeatherResponse>(
        WeatherResponse.serializer,
        response.data,
      );
      return weatherResponse;
    } else {
      throw ServerException();
    }
  }
}
