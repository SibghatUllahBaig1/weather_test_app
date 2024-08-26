
import 'package:intl/intl.dart';

double kelvinToCelsius(double kelvin) {
  double celsius = kelvin - 273.15;
  return double.parse(celsius.toStringAsFixed(1));
}

String formatDateTime(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  String formattedDate = DateFormat('MMMM dd, yyyy, h:mm a').format(dateTime);
  return formattedDate;
}