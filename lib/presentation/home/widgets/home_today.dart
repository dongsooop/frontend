import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';

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
          // 🔹 첫 번째 줄: 카드 2개
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: _buildCard(title: '강의시간표', type: 'lecture'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 140,
                  child: _buildCard(title: '일정', type: 'schedule'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 두 번째 줄: 카드 1개
          _buildCard(title: '오늘의 학식', type: 'meal'),
          const SizedBox(height: 12),

          // 🔹 세 번째 줄: 배너
          _buildCard(title: '', type: 'banner'),
        ],
      ),
    );
  }

  static Widget _buildCard({required String title, required String type}) {
    List<Widget> content = [];

    if (type == 'lecture') {
      content = [
        _buildRow('12:00', '프로그래밍언어실습'),
        _buildRow('14:00', '자바프로그래밍'),
        _buildRow('17:00', '슬기로운직장생활'),
      ];
    } else if (type == 'schedule') {
      content = [
        _buildRow('13:00', '프로젝트 회의'),
        _buildRow('19:00', '술먹기'),
      ];
    } else if (type == 'meal') {
      content = [
        Text(
          '백미밥, 닭갈비볶음, 피자왕춘권&칠리소스, 두부양념조림, 배추김치/요구르트, 소고기미역국',
          style: TextStyles.smallTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
        ),
      ];
    } else if (type == 'banner') {
      return Container(
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
                child: Icon(Icons.import_contacts)),
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
                            )),
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
      );
    }

    return Container(
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
                Icon(
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
