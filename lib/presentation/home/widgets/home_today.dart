import 'dart:ui';

import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeToday extends HookConsumerWidget {
  const HomeToday({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userSessionProvider);
    final cafeteriaState = ref.watch(cafeteriaViewModelProvider);
    final now = DateTime.now();
    final weekday = ['월', '화', '수', '목', '금', '토', '일'][now.weekday - 1];
    final todayString = '${now.month}월 ${now.day}일 ($weekday)';

    String cafeteriaText = cafeteriaState.when(
      data: (state) => state.todayMeal?.koreanMenu ?? '오늘은 학식이 제공되지 않아요!',
      loading: () => '불러오는 중...',
      error: (err, _) => err.toString(),
    );

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
          // 날짜 텍스트
          Text(
            todayString,
            style: TextStyles.titleTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),

          // 강의시간표 + 일정 (하나의 Stack으로 묶어서 blur 처리)
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        title: '강의시간표',
                        type: 'schedule',
                        context: context,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCard(
                        title: '일정',
                        type: 'calendar',
                        context: context,
                      ),
                    ),
                  ],
                ),
                if (user == null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.4),
                        child: Container(
                          alignment: Alignment.center,
                          color:
                              ColorStyles.white.withAlpha((255 * 0.5).round()),
                          child: Text(
                            '로그인이 필요한 서비스예요',
                            style: TextStyles.normalTextBold.copyWith(
                              color: ColorStyles.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 오늘의 학식
          SizedBox(
            child: _buildCard(
              title: '오늘의 학식',
              type: 'cafeteria',
              context: context,
              cafeteriaText: cafeteriaText,
            ),
          ),
          const SizedBox(height: 16),

          // 도서관 배너
          _buildCard(
            title: '',
            type: 'banner',
            context: context,
          ),
        ],
      ),
    );
  }

  static Widget _buildCard({
    required String title,
    required String type,
    required BuildContext context,
    String? cafeteriaText,
  }) {
    List<Widget> content = [];

    if (type == 'schedule') {
      content = [
        _buildRow('12:00', '프로그래밍언어실습'),
        _buildRow('14:00', '자바프로그래밍'),
        _buildRow('17:00', '슬기로운직장생활'),
      ];
    } else if (type == 'calendar') {
      content = [
        _buildRow('13:00', '프로젝트 회의'),
        _buildRow('19:00', '술먹기'),
      ];
    } else if (type == 'cafeteria') {
      content = [
        Text(
          cafeteriaText ?? '',
          style: TextStyles.smallTextRegular.copyWith(
            color: ColorStyles.gray4,
          ),
        ),
      ];
    }

    if (type == 'banner') {
      return GestureDetector(
        onTap: () {
          context.goNamed('libraryWebView');
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

    // 공통 카드 UI
    return GestureDetector(
      onTap: () {
        if (type == 'schedule') {
          context.push('/schedule');
        } else if (type == 'calendar') {
          context.push('/calendar');
        } else if (type == 'cafeteria') {
          context.goNamed('cafeteriaWebView');
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
            SizedBox(height: (type == 'cafeteria') ? 8 : 16),
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
