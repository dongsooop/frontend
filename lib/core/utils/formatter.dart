import 'package:intl/intl.dart';

String formatTimestamp(DateTime time) {
  return DateFormat('a h:mm', 'ko').format(time);
}