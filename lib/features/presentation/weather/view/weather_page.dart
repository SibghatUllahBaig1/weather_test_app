// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:weater_app/core/utils/utils.dart';
// import '../bloc/weather_bloc.dart';
// import '../bloc/weather_event.dart';
// import '../bloc/weather_state.dart';
// import 'package:geolocator/geolocator.dart';
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({Key? key}) : super(key: key);
//
//   @override
//   _WeatherPageState createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//   late WeatherBloc _weatherBloc;
//
//   @override
//   void initState() {
//     super.initState();
//     _weatherBloc = BlocProvider.of<WeatherBloc>(context);
//     _weatherBloc.add(const FetchWeather(44.34, 10.99));
//     //_getLocationAndFetchWeather();
//   }
//
//   Future<void> _getLocationAndFetchWeather() async {
//     // Request location permission
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       // Handle permission denied case
//       return;
//     }
//
//     // Get the current position
//     Position position = await Geolocator.getCurrentPosition();
//
//     // Fetch weather using the obtained latitude and longitude
//     _weatherBloc.add(FetchWeather(position.latitude, position.longitude));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Weather Forecast')),
//       body: BlocBuilder<WeatherBloc, WeatherState>(
//         builder: (context, state) {
//           if (state is WeatherLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is WeatherLoaded) {
//             return ListView.builder(
//               itemCount: state.weatherList?.length,
//               itemBuilder: (context, index) {
//                 final weatherData = state.weatherList?[index];
//
//                 print(weatherData?.iconCode);
//                 return ListTile(
//                   title: Text('${weatherData?.cityName} ${weatherData?.description}'),
//                   subtitle: Text('Temp: ${kelvinToCelsius(weatherData?.temperature ?? 0.0)}°C  ${formatDateTime(weatherData?.dateTime ?? '')}'),
//                   //trailing: Image.network('http://openweathermap.org/img/wn/${weatherData?.iconCode}.png'),
//                   trailing: Image.asset('assets/images/${weatherData?.iconCode}.png'),
//                 );
//               },
//             );
//           } else if (state is WeatherError) {
//             return Center(child: Text('Error: ${state.message}'));
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weater_app/core/utils/utils.dart';
import 'package:weater_app/features/domain/entities/weather_entity.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherBloc _weatherBloc;

  @override
  void initState() {
    super.initState();
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
    //_weatherBloc.add(const FetchWeather(44.34, 10.99));
    _getLocationAndFetchWeather();
  }

  Future<void> _getLocationAndFetchWeather() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle permission denied case
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();

    // Fetch weather using the obtained latitude and longitude
    _weatherBloc.add(FetchWeather(position.latitude, position.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast')),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoaded) {
            // Group weather data by date
            final groupedWeather = _groupByDate(state.weatherList ?? []);

            return ListView(
              children: groupedWeather.entries.map((entry) {
                final date = entry.key;
                final weatherData = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header for the date
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        date,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // List of weather data for that date
                    ...weatherData.map((WeatherEntity weather) {
                      return ListTile(
                        title: Text('City: ${weather.cityName}, ${weather.description}'),
                        subtitle: Text('Temp: ${kelvinToCelsius(weather.temperature ?? 0.0)}°C  ${formatDateTime(weather.dateTime ?? '')}'),
                        trailing: Image.asset('assets/images/${weather.iconCode}.png'),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            );
          } else if (state is WeatherError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }

  // Group the weather data by date
  Map<String, List<WeatherEntity>> _groupByDate(List<WeatherEntity?> weatherList) {
    final Map<String, List<WeatherEntity>> grouped = {};

    for (var weather in weatherList) {
      final date = formatDateTime(weather?.dateTime ?? '').split(',')[0]; // Extract date part
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(weather!);
    }

    return grouped;
  }
}
