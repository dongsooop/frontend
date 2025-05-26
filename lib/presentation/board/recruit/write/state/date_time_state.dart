class DateTimeSelectorState {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool startTimePicked;
  final bool endTimePicked;
  final DateTime currentMonth;

  DateTimeSelectorState({
    required this.startDateTime,
    required this.endDateTime,
    required this.startTimePicked,
    required this.endTimePicked,
    required this.currentMonth,
  });

  DateTimeSelectorState copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? startTimePicked,
    bool? endTimePicked,
    DateTime? currentMonth,
  }) {
    return DateTimeSelectorState(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      startTimePicked: startTimePicked ?? this.startTimePicked,
      endTimePicked: endTimePicked ?? this.endTimePicked,
      currentMonth: currentMonth ?? this.currentMonth,
    );
  }
}
