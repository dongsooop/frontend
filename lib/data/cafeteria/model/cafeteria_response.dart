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

  /// 식당이 그 주에 붙인 공지. 없는 주가 더 많아 null 이 기본이다.
  ///
  /// 서버가 이 값을 내려주기 시작한 건 단품 크롤링 복구와 같은 배포라,
  /// 그 전에 캐시에 들어간 JSON 에는 이 키가 없다. 필수로 받으면 예전
  /// 캐시를 읽는 순간 파싱이 터진다.
  final String? notice;

  CafeteriaResponse({
    required this.startDate,
    required this.endDate,
    required this.dailyMeals,
    this.notice,
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

  /// 단품 메뉴. 학교 페이지가 `별미 메뉴` 행을 `단품 메뉴` 로 바꾸면서
  /// 한동안 비어 있던 값이다. 옛 캐시에는 키 자체가 없어 null 을 받는다.
  final String? specialMenu;

  DailyMealModel({
    required this.date,
    required this.dayOfWeek,
    required this.koreanMenu,
    this.specialMenu,
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
      notice: notice,
    );
  }
}

extension DailyMealModelMapper on DailyMealModel {
  DailyMealEntity toEntity() {
    return DailyMealEntity(
      date: date,
      dayOfWeek: dayOfWeek,
      koreanMenu: koreanMenu,
      specialMenu: specialMenu ?? '',
    );
  }
}
