class Urls {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String apiKey = '37ea9939152496e5de6ca532f93817fd';

  static String currentWeatherByLocation(double latitude, double longitude) =>
      '$baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$apiKey';
}