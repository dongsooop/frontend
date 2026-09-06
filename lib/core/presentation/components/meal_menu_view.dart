import 'package:dongsoop/core/presentation/components/swipe_deck.dart';
import 'package:dongsoop/domain/cafeteria/entities/cafeteria_entity.dart';
import 'package:dongsoop/domain/cafeteria/meal_menu.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 학식을 그리는 조각들. 홈과 캠퍼스가 같은 모양으로 쓴다.
///
/// 상태(`CafeteriaState`)를 알지 못하고 값만 받는다. 감싸는 그릇 — 홈은
/// 왼쪽 세로선, 캠퍼스는 회색 카드 — 은 각 화면이 정한다.

/// 이번 주 학식을 좌우로 넘겨 본다.
///
/// 날짜를 판 안에 둔다. 구획 제목에 두면 넘길 때마다 제목이 바뀌어야 해서
/// 화면마다 페이지 상태를 들고 있어야 하는데, 홈과 캠퍼스가 같은 것을 두 번
/// 만들 이유가 없다.
class MealDeck extends StatelessWidget {
  /// 이번 주 월~금. 급식이 없는 날은 `koreanMenu` 가 비어 있다.
  final List<DailyMealEntity> weekMeals;

  /// 그 주 내내 되풀이돼 뒤로 물릴 항목. `findMealStaples` 참고.
  final List<String> staples;

  /// 판 높이. `PageView` 는 장마다 높이를 달리 주지 못해 하나로 고정한다.
  static const double _deckHeight = 118;

  const MealDeck({
    super.key,
    required this.weekMeals,
    required this.staples,
  });

  @override
  Widget build(BuildContext context) {
    if (weekMeals.isEmpty) {
      return const MealNoticeView('이번 주 학식 정보가 없어요');
    }

    return SwipeDeck(
      itemCount: weekMeals.length,
      initialPage: _todayIndex(),
      height: _deckHeight,
      itemBuilder: (context, index) => _page(weekMeals[index]),
    );
  }

  Widget _page(DailyMealEntity meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dateLabel(meal),
          style: TextStyles.smallTextBold.copyWith(color: ColorStyles.gray5),
        ),
        const SizedBox(height: 7),
        if (meal.koreanMenu.isEmpty)
          Text(
            '학식을 하지 않는 날이에요',
            style: TextStyles.normalTextBold.copyWith(
              color: ColorStyles.gray5,
            ),
          )
        else
          MealMenuView(menu: meal.koreanMenu, staples: staples),
      ],
    );
  }

  /// 처음 보일 장. 오늘이 이번 주 급식일이면 오늘, 아니면 첫 날이다.
  int _todayIndex() {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    for (var i = 0; i < weekMeals.length; i++) {
      if (weekMeals[i].date == today) return i;
    }
    return 0;
  }

  /// 메뉴가 없는 날은 서버가 요일을 비워 보내므로 날짜에서 직접 구한다.
  String _dateLabel(DailyMealEntity meal) {
    final parsed = DateTime.tryParse(meal.date);
    if (parsed == null) return meal.date;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final dayOfWeek = meal.dayOfWeek.isNotEmpty
        ? meal.dayOfWeek
        : weekdays[parsed.weekday - 1];

    return '${DateFormat('M월 d일', 'ko').format(parsed)}($dayOfWeek)';
  }
}

/// 하루치 메뉴.
///
/// 위에 오는 항목들은 전부 같은 무게다. 대표 메뉴를 뽑지 않는다 — 어떤
/// 메뉴가 앞에 올지 서버가 보장하지 않아, 앞자리를 주메뉴로 올리면 엉뚱한
/// 게 대표가 된다.
///
/// 대신 그 주 내내 되풀이되는 것만 아래로 내린다. 하루 일곱 항목 중 밥·김치·
/// 요구르트가 매일 같은데, 일곱을 같은 무게로 늘어놓으면 자리의 절반을 매일
/// 같은 글자가 먹는다. 무엇이 되풀이인지는 `findMealStaples` 가 그 주를 세서
/// 정한다.
class MealMenuView extends StatelessWidget {
  final String menu;
  final List<String> staples;

  const MealMenuView({
    super.key,
    required this.menu,
    required this.staples,
  });

  @override
  Widget build(BuildContext context) {
    final items = splitMealMenu(menu);
    final served = items.where((item) => !staples.contains(item)).toList();
    final repeated = items.where((item) => staples.contains(item)).toList();

    // 되풀이를 내리고 위가 비면 내리지 않는다. `findMealStaples` 가 이미
    // 같은 판단을 하지만, 이 위젯만 봐도 빈 화면이 안 나오는 게 낫다
    if (served.isEmpty) return _line(items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _line(served),
        if (repeated.isNotEmpty) ...[
          const SizedBox(height: 9),
          // gray1 을 쓰면 캠퍼스의 gray1 카드 위에서 선이 사라진다
          const Divider(height: 1, thickness: 1, color: ColorStyles.gray2),
          const SizedBox(height: 8),
          Text(
            repeated.join(' · '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.smallTextRegular.copyWith(
              color: ColorStyles.gray4,
            ),
          ),
        ],
      ],
    );
  }

  Widget _line(List<String> items) {
    return Text(
      items.join(' · '),
      // 판 높이가 고정이라 아주 긴 날은 잘라 낸다
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.normalTextBold.copyWith(
        color: ColorStyles.black,
        height: 1.55,
      ),
    );
  }
}

/// 급식 정보가 아예 없거나 불러오지 못했을 때.
class MealNoticeView extends StatelessWidget {
  final String message;

  const MealNoticeView(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyles.normalTextBold.copyWith(color: ColorStyles.gray5),
    );
  }
}

/// 불러오는 중. 회색 막대 두 줄이면 충분하다.
class MealSkeletonView extends StatelessWidget {
  const MealSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bar(widthFactor: 0.7),
        const SizedBox(height: 9),
        _bar(widthFactor: 0.48),
      ],
    );
  }

  Widget _bar({required double widthFactor}) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          // gray1 카드 위에서도 보여야 해서 한 칸 진한 회색을 쓴다
          color: ColorStyles.gray2,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
