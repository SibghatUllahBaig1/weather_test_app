import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import '../model/weather_model.dart';

part 'serializers.g.dart';

@SerializersFor([
  WeatherResponse,
  WeatherData,
  MainWeather,
  Weather,
  Clouds,
  Wind,
  Rain,
  Sys,
  City,
  Coord,
])
final Serializers serializers = (_$serializers.toBuilder()
  ..addPlugin(StandardJsonPlugin())
  ..addBuilderFactory(
    const FullType(BuiltList, [FullType(WeatherData)]),
        () => ListBuilder<WeatherData>(),
  )
  ..addBuilderFactory(
    const FullType(BuiltList, [FullType(Weather)]),
        () => ListBuilder<Weather>(),
  ))
    .build();