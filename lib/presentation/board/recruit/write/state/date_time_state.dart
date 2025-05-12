class DateTimeSelectorState {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool startTimePicked;
  final bool endTimePicked;

  const DateTimeSelectorState({
    required this.startDateTime,
    required this.endDateTime,
    required this.startTimePicked,
    required this.endTimePicked,
  });

  factory DateTimeSelectorState.initial() {
    final now = DateTime.now();
    final rounded = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      ((now.minute + 9) ~/ 10) * 10 % 60,
    );
    return DateTimeSelectorState(
      startDateTime: rounded,
      endDateTime: rounded.add(const Duration(days: 1)),
      startTimePicked: false,
      endTimePicked: false,
    );
  }

  DateTimeSelectorState copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? startTimePicked,
    bool? endTimePicked,
  }) {
    return DateTimeSelectorState(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      startTimePicked: startTimePicked ?? this.startTimePicked,
      endTimePicked: endTimePicked ?? this.endTimePicked,
    );
  }
}
