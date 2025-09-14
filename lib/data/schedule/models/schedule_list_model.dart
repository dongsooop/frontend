import 'package:dongsoop/data/schedule/mapper/schedule_type_mapper.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_list_model.freezed.dart';
part 'schedule_list_model.g.dart';

@freezed
@JsonSerializable()
class ScheduleListModel with _$ScheduleListModel {
  final int? id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final String type;

  ScheduleListModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.type,
  });

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleListModelFromJson(json);
}

extension ScheduleListModelMapper on ScheduleListModel {
  ScheduleListEntity toEntity() {
    return ScheduleListEntity(
      id: id,
      title: title,
      location: location.isEmpty ? null : location,
      startAt: startAt,
      endAt: endAt,
      type: ScheduleTypeMapper.fromApi(type),
    );
  }
}