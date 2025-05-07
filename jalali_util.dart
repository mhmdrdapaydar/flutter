import 'package:shamsi_date/shamsi_date.dart';

String toJalaliString(DateTime date) {
  final j = Jalali.fromDateTime(date);
  return '${j.year}/${j.month}/${j.day}';
}
