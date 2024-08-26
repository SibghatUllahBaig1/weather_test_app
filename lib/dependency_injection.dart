// Setup in a configuration file

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'features/data/datasource/remote_data_source.dart';
import 'features/data/repositories/weather_repository_impl.dart';
import 'features/domain/repositories/weather_repository.dart';
import 'features/domain/usecases/get_weather.dart';
import 'features/presentation/weather/bloc/weather_bloc.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<DioClient>(DioClient(getIt<Dio>()));
  getIt.registerSingleton<WeatherRemoteDataSource>(WeatherRemoteDataSourceImpl(dioClient: getIt<DioClient>()));
  getIt.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(weatherRemoteDataSource: getIt<WeatherRemoteDataSource>()));
  getIt.registerSingleton<GetWeatherUseCase>(GetWeatherUseCase(weatherRepository: getIt<WeatherRepository>()));
  getIt.registerFactory<WeatherBloc>(() => WeatherBloc(getWeatherUseCase: getIt<GetWeatherUseCase>()));
}