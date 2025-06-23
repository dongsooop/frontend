import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_model.freezed.dart';
part 'calendar_model.g.dart';

@freezed
@JsonSerializable()
class CalendarModel with _$CalendarModel {
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;

  CalendarModel({
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
  });

  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);

  factory CalendarModel.fromEntity(CalendarEntity entity) {
    return CalendarModel(
      title: entity.title,
      location: entity.location,
      startAt: entity.startAt,
      endAt: entity.endAt,
    );
  }
}
