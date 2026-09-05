import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/presentation/campus/restaurant_category_style.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/restaurants_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 오늘 뭐 먹지 — 좋아요 랭킹 상위 맛집.
///
/// `/restaurants/nearby` 가 이미 `likeCount desc, distance asc` 로 정렬해 내려주므로
/// 앞에서 몇 개만 잘라 쓰면 된다. 서버에 따로 추천 API 를 두지 않았다.
class CampusRestaurantList extends ConsumerWidget {
  const CampusRestaurantList({super.key});

  static const int _count = 6;
  static const double _cardWidth = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(userSessionProvider) != null;
    final useCase = ref.watch(getRestaurantsUseCaseProvider);

    return FutureBuilder<List<Restaurant>?>(
      future: useCase.execute(isLogin: isLogin, page: 0, size: _count),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 160,
            child: Center(
              child: CircularProgressIndicator(color: ColorStyles.primaryColor),
            ),
          );
        }

        final restaurants = snapshot.data ?? const <Restaurant>[];
        if (restaurants.isEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                '등록된 맛집이 아직 없어요',
                style: TextStyles.normalTextRegular.copyWith(
                  color: ColorStyles.gray4,
                ),
              ),
            ),
          );
        }

        return SizedBox(
          height: 172,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _RestaurantCard(restaurant: restaurants[index]),
          ),
        );
      },
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final style = RestaurantCategoryStyle.of(restaurant.category);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final url = restaurant.placeUrl;
        if (url == null || url.isEmpty) return;
        context.push('/restaurantWebView?url=$url');
      },
      child: SizedBox(
        width: CampusRestaurantList._cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카카오 로컬 API 에 이미지가 없어 카테고리 색 면으로 대신한다
            Container(
              height: 104,
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(style.emoji, style: const TextStyle(fontSize: 34)),
            ),
            const SizedBox(height: 8),
            Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.normalTextBold.copyWith(
                color: ColorStyles.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${restaurant.category} · 도보 ${_walkMinutes(restaurant.distance)}분',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.smallTextRegular.copyWith(
                color: ColorStyles.gray5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 성인 도보 속도를 분당 67m 로 잡아 올림한다. 0분으로 보이지 않게 최소 1분.
  int _walkMinutes(int distance) {
    final minutes = (distance / 67).ceil();
    return minutes < 1 ? 1 : minutes;
  }
}
