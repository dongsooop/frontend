import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePopularRecruits extends StatefulWidget {
  const HomePopularRecruits({super.key});

  @override
  State<HomePopularRecruits> createState() => _State();
}

class _State extends State<HomePopularRecruits> {
  final List<Map<String, dynamic>> popularList = [
    {
      "title": "DB 프로그래밍",
      "description": "DB 프로그래밍 튜터링 모집합니다] 교내 튜터링 인원 모집합니다..",
      "tags": ["컴퓨터소프트웨어공학과", "DB", "김희숙교수님"]
    },
    {
      "title": "웹 프로젝트 실습",
      "description": "팀원 잘 만나는 게 A+ 받는 방법이다",
      "tags": ["컴퓨터소프트웨어공학과", "JAVA", "장용미교수님"]
    },
    {
      "title": "운영체제 실습",
      "description": "리눅스를 배워보아요",
      "tags": ["컴퓨터소프트웨어공학과", "Linux", "전종로교수님"]
    },
  ];

  Widget _buildTag(String tag) {
    Color bgColor;
    Color textColor;

    if (tag == "컴퓨터소프트웨어공학과") {
      bgColor = ColorStyles.primary5;
      textColor = ColorStyles.primary100;
    } else if (tag == "DB" || tag == "JAVA" || tag == "Linux") {
      bgColor = ColorStyles.labelColorRed10;
      textColor = ColorStyles.labelColorRed100;
    } else if (tag == "김희숙교수님" || tag == "장용미교수님" || tag == "전종로교수님") {
      bgColor = ColorStyles.labelColorYellow10;
      textColor = ColorStyles.labelColorYellow100;
    } else {
      bgColor = ColorStyles.gray2;
      textColor = ColorStyles.gray4;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        tag,
        style: TextStyles.smallTextBold.copyWith(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorStyles.gray1,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '인기 모집',
                style: TextStyles.titleTextBold.copyWith(
                  color: ColorStyles.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.go(RoutePaths.board);
                },
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        '더보기',
                        style: TextStyles.normalTextRegular.copyWith(
                          color: ColorStyles.gray3,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: ColorStyles.gray3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(popularList.length, (index) {
                final notice = popularList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice['title'],
                      style: TextStyles.largeTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notice['description'],
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: notice['tags']
                          .map<Widget>((tag) => _buildTag(tag))
                          .toList(),
                    ),
                    if (index != popularList.length - 1)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        width: double.infinity,
                        height: 1,
                        color: ColorStyles.gray2,
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
