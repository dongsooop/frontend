import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeNewNotice extends StatefulWidget {
  const HomeNewNotice({super.key});

  @override
  State<HomeNewNotice> createState() => _State();
}

class _State extends State<HomeNewNotice> {
  final List<Map<String, dynamic>> noticeList = [
    {
      "title": "[선관위] 2025학년도 학과대표 보궐선거 선거일정 공고",
      "tags": ["동양공지", "학교생활"]
    },
    {
      "title": "2025학년도 신입생 캠퍼스커넥트 프로그램 토크콘서트 안내",
      "tags": ["동양공지", "학교생활"]
    },
    {
      "title": "[학부] 2025학년도 1학기 학습공동체(전공 튜터링) 프로그램 시행 안내",
      "tags": ["학과공지", "학부"]
    },
  ];

  Widget _buildTag(String tag) {
    Color bgColor;
    Color textColor;

    if (tag == "동양공지" || tag == "학과공지") {
      bgColor = ColorStyles.primary5;
      textColor = ColorStyles.primary100;
    } else if (tag == "학교생활" || tag == "학부") {
      bgColor = ColorStyles.labelColorRed10;
      textColor = ColorStyles.labelColorRed100;
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
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '새로운 공지',
                  style: TextStyles.titleTextBold.copyWith(
                    color: ColorStyles.black,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '더보기',
                      style: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray3,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorStyles.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(noticeList.length, (index) {
                final notice = noticeList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notice['title'],
                      style: TextStyles.largeTextBold.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: notice['tags']
                          .map<Widget>((tag) => _buildTag(tag))
                          .toList(),
                    ),
                    if (index != noticeList.length - 1)
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
