import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cafeteria_response.freezed.dart';
part 'cafeteria_response.g.dart';

@freezed
@JsonSerializable()
class CafeteriaResponse with _$CafeteriaResponse {
  final String startDate;
  final String endDate;
  final List<DailyMealModel> dailyMeals;

  CafeteriaResponse({
    required this.startDate,
    required this.endDate,
    required this.dailyMeals,
  });

  factory CafeteriaResponse.fromJson(Map<String, dynamic> json) =>
      _$CafeteriaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CafeteriaResponseToJson(this);
}

@JsonSerializable()
class DailyMealModel {
  final String date;
  final String dayOfWeek;
  final String koreanMenu;

  DailyMealModel({
    required this.date,
    required this.dayOfWeek,
    required this.koreanMenu,
  });

  factory DailyMealModel.fromJson(Map<String, dynamic> json) =>
      _$DailyMealModelFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMealModelToJson(this);
}

extension CafeteriaMapper on CafeteriaResponse {
  CafeteriaEntity toEntity() {
    return CafeteriaEntity(
      startDate: startDate,
      endDate: endDate,
      dailyMeals: dailyMeals.map((e) => e.toEntity()).toList(),
    );
  }
}

extension DailyMealModelMapper on DailyMealModel {
  DailyMealEntity toEntity() {
    return DailyMealEntity(
      date: date,
      dayOfWeek: dayOfWeek,
      koreanMenu: koreanMenu,
    );
  }
}
