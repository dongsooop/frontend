class DateTimeState {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool startTimePicked;
  final bool endTimePicked;
  final DateTime currentMonth;

  DateTimeState({
    required this.startDateTime,
    required this.endDateTime,
    required this.startTimePicked,
    required this.endTimePicked,
    required this.currentMonth,
  });

  DateTimeState copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? startTimePicked,
    bool? endTimePicked,
    DateTime? currentMonth,
  }) {
    return DateTimeState(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      startTimePicked: startTimePicked ?? this.startTimePicked,
      endTimePicked: endTimePicked ?? this.endTimePicked,
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }
}
