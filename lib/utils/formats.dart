import 'package:intl/intl.dart';

class Formats {
  static String date(DateTime dateTime) => DateFormat("d MMMM yyyy").format(dateTime);
  static String time(DateTime dateTime) => DateFormat("hh:mm a").format(dateTime);
  static String dateTime(DateTime value) => "${date(value)}, ${time(value)}";

  static String id(DateTime dateTime) => DateFormat("yyMMdd").format(dateTime);

  static String duration(int minutes){
    final days = minutes~/(24*60);
    final hours = (minutes%(24*60))~/60;
    final min = (minutes%(24*60))%60;
    return '${days}d: ${hours}h: ${min}m';
  }
}