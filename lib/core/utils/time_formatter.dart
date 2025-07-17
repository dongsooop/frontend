import 'package:intl/intl.dart';

String formatLastActivityTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(time.year, time.month, time.day);

  if (date == today) {
    final isAM = time.hour < 12;
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '${isAM ? '오전' : '오후'} $hour:$minute';
  } else if (date == today.subtract(const Duration(days: 1))) {
    return '어제';
  } else {
    return '${time.month}/${time.day}';
  }
}

String formatTimestamp(DateTime time) {
  return DateFormat('a h:mm', 'ko').format(time);
}

String formatSanctionTime(DateTime time) {
  return '${time.year}. ${time.month}. ${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}