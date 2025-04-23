class Schedule {
  final String name;
  final String? professor;
  final String? classroom;
  final String day;
  final int startTime; // 예: '10:00'
  final int endTime;   // 예: '12:50'

  Schedule({
    required this.name,
    this.professor,
    this.classroom,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      name: json['강의명'] ?? '',
      professor: json['교수'],           // nullable
      classroom: json['강의실'],         // nullable
      day: json['요일'] ?? '',
      startTime: _parseTimeToMinutes(json['시작시간'] ?? '00:00'),
      endTime: _parseTimeToMinutes(json['종료시간'] ?? '00:00'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '강의명': name,
      '교수': professor,
      '강의실': classroom,
      '요일': day,
      '시작시간': startTime,
      '종료시간': endTime,
    };
  }

  /// '10:30' → 630
  static int _parseTimeToMinutes(String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return (hour - 9) * 60 + minute;
  }

  /// 630 → '10:30'
  static String _minutesToTimeString(int minutes) {
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final min = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$min';
  }

  @override
  String toString() {
    return 'Schedule(name: $name, professor: $professor, classroom: $classroom, day: $day, startTime: $startTime, endTime: $endTime)';
  }
}

