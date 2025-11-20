import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class RestaurantList extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const RestaurantList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    const kakaoUrl = 'http://place.map.kakao.com/26338954';

    if (data.isEmpty) {
      return Center(
        child: Text(
          '등록된 가게가 없어요!',
          style: TextStyles.normalTextRegular.copyWith(color: ColorStyles.black),
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final card = data[index];

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // 웹뷰 카카오 url 이동
            context.push('/mypageWebView?url=$kakaoUrl&title=서비스 이용약관');
          },
          child: RestaurantCard(
            title: card['title'] as String,
            distance: card['distance'] as int,
            likeCount: card['likeCount'] as int,
            category: card['category'] as String,
            tags: List<String>.from(card['tag'] as List),
          ),
        );
      },
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final String title;
  final int distance;
  final int likeCount;
  final String category;
  final List<String>? tags;

  const RestaurantCard({
    super.key,
    required this.title,
    required this.distance,
    required this.likeCount,
    required this.category,
    this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final allTags = <String>[category, ...?tags];

    return Container(
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
              if (likeCount >= 20) ...[
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
                  title,
                  style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  // TODO: 좋아요 / 취소
                },
                child: SvgPicture.asset(
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
                '${distance}m',
                style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
              ),
              const SizedBox(width: 12),
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
                '${likeCount}명이 좋아하는 가게예요',
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
    );
  }
}