import 'package:dongsoop/data/calendar/mapper/calendar_type_mapper.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_list_model.freezed.dart';
part 'calendar_list_model.g.dart';

@freezed
@JsonSerializable()
class CalendarListModel with _$CalendarListModel {
  final int? id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final String type;

  CalendarListModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.type,
  });

  factory CalendarListModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarListModelFromJson(json);
}

extension CalendarListModelMapper on CalendarListModel {
  CalendarListEntity toEntity() {
    return CalendarListEntity(
      id: id,
      title: title,
      location: location.isEmpty ? null : location,
      startAt: startAt,
      endAt: endAt,
      type: CalendarTypeMapper.fromApi(type),
    );
  }
}