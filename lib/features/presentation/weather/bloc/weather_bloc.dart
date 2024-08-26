import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weater_app/core/utils/shared_preferences_service.dart';
import '../../../domain/entities/weather_entity.dart';
import '../../../domain/usecases/get_weather.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase getWeatherUseCase;

  WeatherBloc({required this.getWeatherUseCase}) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {

      bool isConnected = await InternetConnection().hasInternetAccess;

      if (isConnected) {
        final (weatherEntities, failure) = await getWeatherUseCase.execute(event.latitude, event.longitude);
        if (weatherEntities != null) {
          emit(WeatherLoaded(weatherEntities));
        } else {
          emit(const WeatherError("Couldn't fetch weather data."));
        }
      } else {
        List<WeatherEntity>? weatherList = await SharedPreferencesService.getWeatherEntityList();
        emit(WeatherLoaded(weatherList));
      }
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      // Deserialize the JSON data to WeatherState
      List<WeatherEntity> weatherEntities = (json['weather'] as List)
          .map((data) => WeatherEntity(
        cityName: data['cityName'],
        main: data['main'],
        description: data['description'],
        iconCode: data['iconCode'],
        temperature: data['temperature'],
        pressure: data['pressure'],
        humidity: data['humidity'],
        dateTime: data['dateTime'],
      )).toList();

      return WeatherLoaded(weatherEntities);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state is WeatherLoaded) {
      // Serialize the WeatherState to JSON
      List<WeatherEntity>? weatherList = state.weatherList?.map((data) => WeatherEntity(
          cityName: data?.cityName ?? '',
          main: data?.main ?? '',
          description: data?.description ?? '',
          iconCode: data?.iconCode ?? '',
          temperature: data?.temperature ?? 0.0,
          pressure: data?.pressure ?? 0,
          humidity: data?.humidity ?? 0,
          dateTime: data?.dateTime ?? ''
      )).toList();

      SharedPreferencesService.saveWeatherEntityList(weatherList!);
      return {
        'weather': state.weatherList?.map((data) => {
          'cityName': data?.cityName,
          'main': data?.main,
          'description': data?.description,
          'iconCode': data?.iconCode,
          'temperature': data?.temperature,
          'pressure': data?.pressure,
          'humidity': data?.humidity,
          'dateTime': data?.dateTime,
        }).toList(),
      };
    }
    return null;
  }
}
