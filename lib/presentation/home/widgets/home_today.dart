import 'package:dongsoop/presentation/home/view_models/cafeteria_view_model.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';

class HomeToday extends HookConsumerWidget {
  const HomeToday({
    super.key,
    required this.timeTable,
    required this.schedule,
    required this.isLoggedOut,
  });

  final List<Slot> timeTable;
  final List<Schedule> schedule;
  final bool isLoggedOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cafeteriaState = ref.watch(cafeteriaViewModelProvider);
    final now = DateTime.now();
    final weekday = ['월', '화', '수', '목', '금', '토', '일'][now.weekday - 1];
    final todayString = '${now.month}월 ${now.day}일 ($weekday)';

    final cafeteriaText = cafeteriaState.when(
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
          Text(
            todayString,
            style: TextStyles.titleTextBold.copyWith(
              color: ColorStyles.black,
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: isLoggedOut ? 112 : 140,
            child: Row(
              children: [
                if (!isLoggedOut) ...[
                  Expanded(
                    child: _buildCard(
                      title: '강의시간표',
                      type: _CardType.timetable,
                      context: context,
                      slots: timeTable,
                      isLoggedOut: isLoggedOut,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: _buildCard(
                    title: '일정',
                    type: _CardType.schedule,
                    context: context,
                    schedule: schedule,
                    isLoggedOut: isLoggedOut,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _buildCard(
            title: '오늘의 학식',
            type: _CardType.cafeteria,
            context: context,
            cafeteriaText: cafeteriaText,
            isLoggedOut: isLoggedOut,
          ),
          const SizedBox(height: 16),

          _buildCard(
            title: '',
            type: _CardType.banner,
            context: context,
            isLoggedOut: isLoggedOut,
          ),
        ],
      ),
    );
  }

  static String formatHourMinute(String value) {
    final match = RegExp(r'^\s*(\d{1,2}):(\d{2})(?::\d{2})?\s*$').firstMatch(value);
    if (match != null) {
      final hourPart = match.group(1)!.padLeft(2, '0');
      final minutePart = match.group(2)!;
      return '$hourPart:$minutePart';
    }
    return value;
  }

  static String _displayTimeForSchedule(Schedule s) {
    final isOfficial = s.type == ScheduleType.official;
    return isOfficial ? '학사' : formatHourMinute(s.startAt);
  }

  static Widget _buildCard({
    required String title,
    required _CardType type,
    required BuildContext context,
    List<Slot> slots = const [],
    List<Schedule> schedule = const [],
    String? cafeteriaText,
    bool isLoggedOut = false,
  }) {
    List<Widget> content = [];

    if (type == _CardType.timetable) {
      content = slots.isEmpty
          ? [
        Text(
          '오늘 수업이 없어요',
          style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      ]
          : slots
          .take(3)
          .map((s) => _buildRow(formatHourMinute(s.startAt), s.title))
          .toList();

    } else if (type == _CardType.schedule) {
      if (isLoggedOut) {
        final officialOnly = schedule
            .where((s) => s.type == ScheduleType.official)
            .toList();

        content = officialOnly.isEmpty
            ? [
          Text(
            '오늘 학사 일정이 없어요',
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ]
            : officialOnly
            .take(3)
            .map((c) => _buildRow('학사', c.title))
            .toList();
      } else {
        content = schedule.isEmpty
            ? [
          Text(
            '오늘 일정이 없어요',
            style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
          ),
        ]
            : schedule
            .take(3)
            .map((c) => _buildRow(_displayTimeForSchedule(c), c.title))
            .toList();
      }

    } else if (type == _CardType.cafeteria) {
      content = [
        Text(
          cafeteriaText ?? '',
          style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4),
        ),
      ];
    }

    if (type == _CardType.banner) {
      return GestureDetector(
        onTap: () => context.goNamed('libraryWebView'),
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

    return GestureDetector(
      onTap: () {
        switch (type) {
          case _CardType.timetable:
            context.push('/timetable');
            break;
          case _CardType.schedule:
            context.push('/schedule');
            break;
          case _CardType.cafeteria:
            context.goNamed('cafeteriaWebView');
            break;
          case _CardType.banner:
            break;
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
                  Text(title, style: TextStyles.normalTextBold.copyWith(color: ColorStyles.black)),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: ColorStyles.gray3),
                ],
              ),
            ),
            SizedBox(height: (type == _CardType.cafeteria) ? 8 : 16),
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
          Text(time, style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.gray4)),
          const SizedBox(width: 8),
          Text(subject, style: TextStyles.smallTextRegular.copyWith(color: ColorStyles.black)),
        ],
      ),
    );
  }
}

enum _CardType { timetable, schedule, cafeteria, banner }
