import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {

  const WeatherEntity({
    required this.cityName,
    required this.main,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.dateTime
  });

  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;
  final String dateTime;

  @override
  List < Object ? > get props => [
    cityName,
    main,
    description,
    iconCode,
    temperature,
    pressure,
    humidity,
    dateTime
  ];

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'main': main,
      'description': description,
      'iconCode': iconCode,
      'temperature': temperature,
      'pressure': pressure,
      'humidity': humidity,
      'dateTime': dateTime,
    };
  }

  factory WeatherEntity.fromJson(Map<String, dynamic> json) {
    return WeatherEntity(
      cityName: json['cityName'],
      main: json['main'],
      description: json['description'],
      iconCode: json['iconCode'],
      temperature: json['temperature'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      dateTime: json['dateTime'],
    );
  }

}