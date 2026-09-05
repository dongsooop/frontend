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

String? formatSanctionTime(DateTime? time) {
  if (time == null) return null;
  return '${time.year}. ${time.month}. ${time.day} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}

String formatDuration(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

extension TimeStringExtensions on String {
  /// 서버 시간 문자열(H:mm, HH:mm, HH:mm:ss)을 HH:mm으로 정규화한다.
  ///
  /// 파싱할 수 없는 값은 원문을 그대로 반환한다.
  String toHourMinute() {
    final parts = trim().split(':');
    if (parts.length < 2) return this;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null || hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return this;
    }

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  int toMinutesFrom9AM() {
    final parts = split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return (hour - 9) * 60 + minute;
  }
}

extension MinutesToTimeString on int {
  String toTimeStringFrom9AM() {
    final totalMinutes = this + 9 * 60;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;

    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');

    return '$hh:$mm';
  }
}

String formatBlindDate(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}. ${dt.month}. ${dt.day}. ${two(dt.hour)}:${two(dt.minute)}';
}

String formatYmd(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final da = d.day.toString().padLeft(2, '0');
  return '$y-$m-$da';
}

String formatYmdDot(DateTime dt) => '${dt.year}. ${dt.month}. ${dt.day}.';