// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:weater_app/features/data/datasource/remote_data_source.dart';
// import 'package:weater_app/features/data/repositories/weather_repository_impl.dart';
//
// import 'weather_repository_impl_test.mocks.dart';
//
//
// @GenerateNiceMocks([MockSpec<WeatherRemoteDataSource>()])
//
// void main(){
//   late WeatherRepositoryImpl repository;
//   late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
//
//   setUp(() {
//     mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
//     repository = WeatherRepositoryImpl(
//         weatherRemoteDataSource: mockWeatherRemoteDataSource
//     );
//   });
//
//   final tMovieModelList = [
//     MovieModel(id: 1, title: "Test Movie 1", overview: "Desc 1", posterPath: "/image1"),
//     MovieModel(id: 2, title: "Test Movie 2", overview: "Desc 2", posterPath: "/image2"),
//   ];
//
//   final tMoviesList = [
//     Movie(id: 1, title: "Test Movie 1", overview: "Desc 1", posterPath: "/image1"),
//     Movie(id: 2, title: "Test Movie 2", overview: "Desc 2", posterPath: "/image2"),
//   ];
//
//   final String tQuery = 'Inception';
//
//   test('should get trending movies from the remote data source', () async {
//     when(mockWeatherRemoteDataSource.getTrendingMovies())
//         .thenAnswer((_) async => tMovieModelList);
//
//     final result = await repository.getTrendingMovies();
//
//     verify(mockMovieRemoteDataSource.getTrendingMovies());
//
//     expect(result, isA<Right<Failure, List<Movie>>>());
//   });
//
//   test('should get popular movies from the remote data source', () async {
//     when(mockMovieRemoteDataSource.getPopularMovies())
//         .thenAnswer((_) async => tMovieModelList);
//
//     final result = await repository.getPopularMovies();
//
//     verify(mockMovieRemoteDataSource.getPopularMovies());
//     expect(result, isA<Right<Failure, List<Movie>>>());
//   });
//
//   test('should search movies from the remote data source', () async {
//     when(mockMovieRemoteDataSource.searchMovies(tQuery))
//         .thenAnswer((_) async => tMovieModelList);
//
//     final result = await repository.searchMovies(tQuery);
//
//     verify(mockMovieRemoteDataSource.searchMovies(tQuery));
//     expect(result, isA<Right<Failure, List<Movie>>>());
//   });
//
//   test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
//     when(mockMovieRemoteDataSource.getTrendingMovies())
//         .thenThrow(ServerException(message: '', statusCode: ''));
//
//     final result = await repository.getTrendingMovies();
//
//
//     expect(result, isA<Left<ServerFailure, List<Movie>>>());
//   });
//
//   test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
//     when(mockMovieRemoteDataSource.getPopularMovies())
//         .thenThrow(ServerException(message: '', statusCode: ''));
//
//     final result = await repository.getPopularMovies();
//
//     expect(result, isA<Left<ServerFailure, List<Movie>>>());
//   });
//
//   test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
//     when(mockMovieRemoteDataSource.searchMovies(tQuery))
//         .thenThrow(ServerException(message: '', statusCode: ''));
//
//     final result = await repository.searchMovies(tQuery);
//
//     expect(result, isA<Left<ServerFailure, List<Movie>>>());
//   });
//
// }


import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weater_app/core/error/exception.dart';
import 'package:weater_app/core/error/failure.dart';
import 'package:weater_app/features/data/datasource/remote_data_source.dart';
import 'package:weater_app/features/data/model/weather_model.dart';
import 'package:weater_app/features/data/repositories/weather_repository_impl.dart';
import 'package:weater_app/features/domain/entities/weather_entity.dart';
import 'package:mockito/annotations.dart';

import 'weather_repository_impl_test.mocks.dart';

// Define your mock class
@GenerateMocks([WeatherRemoteDataSource])
void main() {
  late MockWeatherRemoteDataSource mockWeatherRemoteDataSource;
  late WeatherRepositoryImpl weatherRepoImpl;

  setUp(() {
    mockWeatherRemoteDataSource = MockWeatherRemoteDataSource();
    weatherRepoImpl = WeatherRepositoryImpl(
      weatherRemoteDataSource: mockWeatherRemoteDataSource,
    );
  });

  const testWeatherEntity = WeatherEntity(
    cityName: 'Mountain View',
    main: 'Clear',
    description: 'clear sky',
    iconCode: '01d',
    temperature: 282.55,
    pressure: 1023,
    humidity: 100,
    dateTime: '2019-07-12 23:04:05', // Adjust the date-time to match your model
  );


  final weatherResponse = WeatherResponse((b) => b
    ..cod = '200'
    ..message = 0
    ..cnt = 1
    ..list.add(WeatherData((b) => b
      ..dt = 1560350645
      ..main = MainWeather((b) => b
        ..temp = 282.55
        ..feels_like = 281.86
        ..temp_min = 280.37
        ..temp_max = 284.26
        ..pressure = 1023
        ..sea_level = 1010
        ..grnd_level = 1005
        ..humidity = 100
        ..temp_kf = 0.0
      ) as MainWeatherBuilder?
      ..weather.add(Weather((b) => b
        ..id = 800
        ..main = 'Clear'
        ..description = 'clear sky'
        ..icon = '01d'
      ))
      ..clouds = Clouds((b) => b..all = 1) as CloudsBuilder?
      ..wind = Wind((b) => b
        ..speed = 1.5
        ..deg = 350
        ..gust = 2.0
      ) as WindBuilder?
      ..visibility = 16093
      ..pop = 0.0
      ..rain = Rain((b) => b..oneHour = 0.0) as RainBuilder?
      ..sys = Sys((b) => b..pod = 'd') as SysBuilder?
      ..dt_txt = '2019-07-11 12:00:00'
    ))
    ..city = City((b) => b
      ..id = 420006353
      ..name = 'Mountain View'
      ..coord = Coord((b) => b
        ..lat = 37.39
        ..lon = -122.08
      ) as CoordBuilder?
      ..country = 'US'
      ..population = 74000
      ..timezone = -25200
      ..sunrise = 1560343627
      ..sunset = 1560396563
    ) as CityBuilder?);

  final lat = 37.39;
  final lon = -122.08;

  group('WeatherRepositoryImpl', () {
    test('should return weather when a call to data source is successful', () async {
      // Arrange
      when(mockWeatherRemoteDataSource.getWeather(lat, lon))
          .thenAnswer((_) async => weatherResponse);

      // Act
      final result = await weatherRepoImpl.getWeather(lat, lon);

      // Assert
      expect(result, equals((testWeatherEntity)));
    });

    test('should return server failure when a call to data source is unsuccessful', () async {
      // Arrange
      when(mockWeatherRemoteDataSource.getWeather(lat, lon))
          .thenThrow(ServerException());

      // Act
      final result = await weatherRepoImpl.getWeather(lat, lon);

      // Assert
      expect(result, equals((ServerFailure('A server error has occurred'))));
    });

    test('should return connection failure when the device has no internet', () async {
      // Arrange
      when(mockWeatherRemoteDataSource.getWeather(lat, lon))
          .thenThrow(SocketException('Failed to connect to the network'));

      // Act
      final result = await weatherRepoImpl.getWeather(lat, lon);

      // Assert
      expect(result, equals((ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
