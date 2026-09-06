import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 캠퍼스 탭의 "오늘 뭐 먹지" 목록.
///
/// 공용 restaurants provider는 data source/repository/use case 조립만 담당하고,
/// 캠퍼스 화면에 필요한 "상위 6개" 정책은 feature provider에 둔다.
final topRestaurantsProvider =
    FutureProvider.autoDispose<List<Restaurant>>((ref) async {
  final isLogin = ref.watch(userSessionProvider) != null;
  final useCase = ref.watch(getRestaurantsUseCaseProvider);

  final restaurants = await useCase.execute(
    isLogin: isLogin,
    page: 0,
    size: 6,
  );

  return restaurants ?? const [];
});
