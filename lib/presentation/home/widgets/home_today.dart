import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeToday extends StatelessWidget {
  const HomeToday({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 64, top: 32),
      decoration: const BoxDecoration(
        color: ColorStyles.gray1,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorStyles.white, ColorStyles.gray1],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4월 7일 (월)',
            style: TextStyles.titleTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: _buildCard(
                    title: '강의시간표',
                    type: 'schedule',
                    context: context,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: _buildCard(
                    title: '일정',
                    type: 'calendar',
                    context: context,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCard(title: '오늘의 학식', type: 'meal', context: context),
          const SizedBox(height: 12),
          _buildCard(title: '', type: 'banner', context: context),
        ],
      ),
    );
  }

  static Widget _buildCard({
    required String title,
    required String type,
    required BuildContext context,
  }) {
    List<Widget> content = [];
    String? routeName;

    if (type == 'schedule') {
      content = [
        _buildRow('12:00', '프로그래밍언어실습'),
        _buildRow('14:00', '자바프로그래밍'),
        _buildRow('17:00', '슬기로운직장생활'),
      ];
      routeName = 'schedule';
    } else if (type == 'calendar') {
      content = [
        _buildRow('13:00', '프로젝트 회의'),
        _buildRow('19:00', '술먹기'),
      ];
      routeName = 'calendar';
    } else if (type == 'meal') {
      content = [
        Text(
          '백미밥, 닭갈비볶음, 피자왕춘권&칠리소스, 두부양념조림, 배추김치/요구르트, 소고기미역국',
          style: TextStyles.smallTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
        ),
      ];
      // routeName = 'mealWebview';
    }

    if (type == 'banner') {
      return GestureDetector(
        onTap: () {
          // context.goNamed('studyRoom'); // 예: 도서관 예약 웹뷰페이지
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorStyles.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SvgPicture.asset(
                  'assets/icons/book.svg',
                  width: 24,
                  height: 24,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '팀원들과 시너지를 올릴 공간이 필요하신가요?',
                      style: TextStyles.smallTextRegular.copyWith(
                        color: ColorStyles.black,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '도서관 스터디룸',
                            style: TextStyles.smallTextBold.copyWith(
                              color: ColorStyles.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '을 예약해 보세요',
                            style: TextStyles.smallTextRegular.copyWith(
                              color: ColorStyles.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: ColorStyles.gray3,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 카드 클릭 시 라우팅
    return GestureDetector(
      onTap: () {
        if (routeName != null) {
          context.goNamed(routeName);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyles.normalTextBold.copyWith(
                      color: ColorStyles.black,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ColorStyles.gray3,
                  ),
                ],
              ),
            ),
            SizedBox(height: (type == 'meal') ? 8 : 16),
            ...content,
          ],
        ),
      ),
    );
  }

  static Widget _buildRow(String time, String subject) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            subject,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ],
      ),
    );
  }
}
