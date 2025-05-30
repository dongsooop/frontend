import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';

class CalendarModel {
  final int id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final String type;

  CalendarModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.type,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    return CalendarModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      startAt: DateTime.tryParse(json['startAt'] ?? '') ?? DateTime.now(),
      endAt: DateTime.tryParse(json['endAt'] ?? '') ?? DateTime.now(),
      type: json['type'] ?? '',
    );
  }
}

extension CalendarModelMapper on CalendarModel {
  CalendarEntity toEntity() {
    return CalendarEntity(
      id: id,
      title: title,
      location: location,
      startAt: startAt,
      endAt: endAt,
      type: type,
    );
  }
}
