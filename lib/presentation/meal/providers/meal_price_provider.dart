import 'package:dongsoop/domain/cafeteria/entities/meal_price_entity.dart';
import 'package:dongsoop/presentation/home/providers/cafeteria_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 식권·단품 가격표.
///
/// 주간 식단과 따로 받는다. 가격표는 서버 설정 파일 값이라 실패해도 메뉴는
/// 그대로 보여야 하고, 아직 이 API 가 없는 서버에 붙은 앱도 있다.
final mealPriceProvider = FutureProvider<MealPriceEntity>((ref) async {
  final useCase = ref.watch(cafeteriaUseCaseProvider);
  return useCase.fetchPrices();
});
