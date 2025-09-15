import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

@freezed
@JsonSerializable()
class ScheduleModel with _$ScheduleModel {
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;

  ScheduleModel({
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
  });

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  factory ScheduleModel.fromEntity(ScheduleEntity entity) {
    return ScheduleModel(
      title: entity.title,
      location: entity.location,
      startAt: entity.startAt,
      endAt: entity.endAt,
    );
  }
}
