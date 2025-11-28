import 'package:dongsoop/domain/restaurants/enum/restaurants_tag.dart';
import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class RestaurantList extends StatelessWidget {
  final List<Restaurant>? data;
  final Future<void> Function(int id, bool likedByMe)? onTapLike;
  final VoidCallback? onLoadMore;

  const RestaurantList({
    super.key,
    this.data,
    this.onTapLike,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final restaurants = data ?? [];

    if (restaurants.isEmpty) {
      return Center(
        child: Text(
          '등록된 가게가 없어요!',
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 200) {
          onLoadMore?.call();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final card = restaurants[index];
          return RestaurantCard(
            restaurant: card,
            onTapLike: onTapLike,
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final Future<void> Function(int id, bool likedByMe)? onTapLike;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTapLike,
  });

  @override
  Widget build(BuildContext context) {
    final allTags = <String>[
      restaurant.category,
      ...?restaurant.tags?.map((tag) => tag.label),
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push('/mypageWebView?url=${restaurant.placeUrl}&title=서비스 이용약관');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          spacing: 8,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이름 & 좋아요
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (restaurant.likeCount >= 20) ...[
                  SvgPicture.asset(
                    'assets/icons/place_check.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      ColorStyles.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    restaurant.name,
                    style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await onTapLike?.call(
                      restaurant.id,
                      restaurant.isLikedByMe,
                    );
                  },
                  child: restaurant.isLikedByMe
                  ? SvgPicture.asset(
                    'assets/icons/favorite.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      ColorStyles.primaryColor,
                      BlendMode.srcIn,
                    ),
                  )
                  : SvgPicture.asset(
                    'assets/icons/favorite_outline.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      ColorStyles.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            // 위치 & 좋아요 수
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 4,
              children: [
                SvgPicture.asset(
                  'assets/icons/place.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.gray6,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  '${restaurant.distance}m',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                ),
                const SizedBox(width: 4),
                SvgPicture.asset(
                  'assets/icons/favorite.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    ColorStyles.gray6,
                    BlendMode.srcIn,
                  ),
                ),
                Text(
                  '${restaurant.likeCount}명이 좋아하는 가게예요',
                  style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
                ),
              ],
            ),
            // 카테고리 & 태그
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: allTags.map((t) {
                  if (t.isEmpty) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: ColorStyles.gray7,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      t,
                      style: TextStyles.smallTextBold.copyWith(color: ColorStyles.gray5),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: ColorStyles.gray2, height: 1),
          ],
        ),
      ),
    );
  }
}