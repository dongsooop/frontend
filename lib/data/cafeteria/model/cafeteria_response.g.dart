// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafeteria_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CafeteriaResponse _$CafeteriaResponseFromJson(Map<String, dynamic> json) =>
    CafeteriaResponse(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      dailyMeals: (json['dailyMeals'] as List<dynamic>)
          .map((e) => DailyMealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CafeteriaResponseToJson(CafeteriaResponse instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'dailyMeals': instance.dailyMeals,
    };

DailyMealModel _$DailyMealModelFromJson(Map<String, dynamic> json) =>
    DailyMealModel(
      date: json['date'] as String,
      dayOfWeek: json['dayOfWeek'] as String,
      koreanMenu: json['koreanMenu'] as String,
    );

Map<String, dynamic> _$DailyMealModelToJson(DailyMealModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'dayOfWeek': instance.dayOfWeek,
      'koreanMenu': instance.koreanMenu,
    };
